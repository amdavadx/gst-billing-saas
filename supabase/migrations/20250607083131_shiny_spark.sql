/*
  # Create invoices and invoice_items tables

  1. New Tables
    - `invoices`
      - `id` (uuid, primary key)
      - `invoice_number` (text, unique)
      - `customer_id` (uuid, foreign key)
      - `customer_name` (text)
      - `customer_address` (text)
      - `customer_gst` (text, optional)
      - `date` (date)
      - `due_date` (date)
      - `subtotal` (decimal)
      - `cgst` (decimal)
      - `sgst` (decimal)
      - `igst` (decimal)
      - `total_gst` (decimal)
      - `grand_total` (decimal)
      - `status` (text)
      - `type` (text)
      - `tenant_id` (text)
      - `created_at` (timestamp)
    
    - `invoice_items`
      - `id` (uuid, primary key)
      - `invoice_id` (uuid, foreign key)
      - `product_id` (text)
      - `product_name` (text)
      - `hsn` (text)
      - `quantity` (decimal)
      - `unit` (text)
      - `rate` (decimal)
      - `gst_rate` (decimal)
      - `amount` (decimal)
      - `gst_amount` (decimal)
      - `total_amount` (decimal)

  2. Security
    - Enable RLS on both tables
    - Add policies for CRUD operations
*/

CREATE TABLE IF NOT EXISTS invoices (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  invoice_number text UNIQUE NOT NULL,
  customer_id uuid NOT NULL,
  customer_name text NOT NULL,
  customer_address text NOT NULL,
  customer_gst text,
  date date NOT NULL,
  due_date date NOT NULL,
  subtotal decimal(12,2) NOT NULL DEFAULT 0,
  cgst decimal(12,2) NOT NULL DEFAULT 0,
  sgst decimal(12,2) NOT NULL DEFAULT 0,
  igst decimal(12,2) NOT NULL DEFAULT 0,
  total_gst decimal(12,2) NOT NULL DEFAULT 0,
  grand_total decimal(12,2) NOT NULL DEFAULT 0,
  status text NOT NULL DEFAULT 'draft' CHECK (status IN ('draft', 'sent', 'paid', 'overdue')),
  type text NOT NULL DEFAULT 'regular' CHECK (type IN ('regular', 'proforma')),
  tenant_id text NOT NULL,
  created_at timestamptz DEFAULT now()
);

CREATE TABLE IF NOT EXISTS invoice_items (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  invoice_id uuid NOT NULL REFERENCES invoices(id) ON DELETE CASCADE,
  product_id text NOT NULL,
  product_name text NOT NULL,
  hsn text NOT NULL,
  quantity decimal(10,3) NOT NULL,
  unit text NOT NULL,
  rate decimal(10,2) NOT NULL,
  gst_rate decimal(5,2) NOT NULL,
  amount decimal(12,2) NOT NULL,
  gst_amount decimal(12,2) NOT NULL,
  total_amount decimal(12,2) NOT NULL
);

ALTER TABLE invoices ENABLE ROW LEVEL SECURITY;
ALTER TABLE invoice_items ENABLE ROW LEVEL SECURITY;

-- Policies for invoices
CREATE POLICY "Users can read own invoices"
  ON invoices
  FOR SELECT
  TO authenticated
  USING (tenant_id = auth.jwt() ->> 'tenant_id');

CREATE POLICY "Users can insert own invoices"
  ON invoices
  FOR INSERT
  TO authenticated
  WITH CHECK (tenant_id = auth.jwt() ->> 'tenant_id');

CREATE POLICY "Users can update own invoices"
  ON invoices
  FOR UPDATE
  TO authenticated
  USING (tenant_id = auth.jwt() ->> 'tenant_id');

CREATE POLICY "Users can delete own invoices"
  ON invoices
  FOR DELETE
  TO authenticated
  USING (tenant_id = auth.jwt() ->> 'tenant_id');

-- Policies for invoice_items
CREATE POLICY "Users can read own invoice items"
  ON invoice_items
  FOR SELECT
  TO authenticated
  USING (EXISTS (
    SELECT 1 FROM invoices 
    WHERE invoices.id = invoice_items.invoice_id 
    AND invoices.tenant_id = auth.jwt() ->> 'tenant_id'
  ));

CREATE POLICY "Users can insert own invoice items"
  ON invoice_items
  FOR INSERT
  TO authenticated
  WITH CHECK (EXISTS (
    SELECT 1 FROM invoices 
    WHERE invoices.id = invoice_items.invoice_id 
    AND invoices.tenant_id = auth.jwt() ->> 'tenant_id'
  ));

CREATE POLICY "Users can update own invoice items"
  ON invoice_items
  FOR UPDATE
  TO authenticated
  USING (EXISTS (
    SELECT 1 FROM invoices 
    WHERE invoices.id = invoice_items.invoice_id 
    AND invoices.tenant_id = auth.jwt() ->> 'tenant_id'
  ));

CREATE POLICY "Users can delete own invoice items"
  ON invoice_items
  FOR DELETE
  TO authenticated
  USING (EXISTS (
    SELECT 1 FROM invoices 
    WHERE invoices.id = invoice_items.invoice_id 
    AND invoices.tenant_id = auth.jwt() ->> 'tenant_id'
  ));