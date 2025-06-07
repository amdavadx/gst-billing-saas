/*
  # Enforce tenant integrity for invoices

  1. Add foreign key for invoices.customer_id
  2. Check customer belongs to same tenant
  3. Update RLS policies on invoices
*/

-- Add foreign key referencing customers
ALTER TABLE invoices
  ADD CONSTRAINT invoices_customer_id_fkey
  FOREIGN KEY (customer_id) REFERENCES customers(id);

-- Ensure the customer belongs to the same tenant as the invoice
ALTER TABLE invoices
  ADD CONSTRAINT invoices_customer_tenant_check
  CHECK (
    EXISTS (
      SELECT 1 FROM customers
      WHERE customers.id = customer_id
        AND customers.tenant_id = tenant_id
    )
  );

-- Replace insert policy with tenant-aware check
DROP POLICY IF EXISTS "Users can insert own invoices" ON invoices;
CREATE POLICY "Users can insert own invoices"
  ON invoices
  FOR INSERT
  TO authenticated
  WITH CHECK (
    tenant_id = auth.jwt() ->> 'tenant_id'
    AND EXISTS (
      SELECT 1 FROM customers
      WHERE customers.id = customer_id
        AND customers.tenant_id = auth.jwt() ->> 'tenant_id'
    )
  );

-- Replace update policy with tenant-aware check
DROP POLICY IF EXISTS "Users can update own invoices" ON invoices;
CREATE POLICY "Users can update own invoices"
  ON invoices
  FOR UPDATE
  TO authenticated
  USING (tenant_id = auth.jwt() ->> 'tenant_id')
  WITH CHECK (
    tenant_id = auth.jwt() ->> 'tenant_id'
    AND EXISTS (
      SELECT 1 FROM customers
      WHERE customers.id = customer_id
        AND customers.tenant_id = auth.jwt() ->> 'tenant_id'
    )
  );
