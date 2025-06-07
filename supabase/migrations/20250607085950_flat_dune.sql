/*
  # Create Authentication Accounts

  1. Super Admin Account
    - Email: superadmin@gstbilling.com
    - Password: SuperAdmin@123
    - Role: super_admin
    - Access: All tenants

  2. Demo Tenant Accounts (5 accounts)
    - TechCorp Solutions (tenant_1)
    - Green Energy Systems (tenant_2) 
    - Manufacturing Corp (tenant_3)
    - Retail Solutions (tenant_4)
    - Service Industries (tenant_5)

  3. Authentication Setup
    - User metadata includes tenant_id and role
    - RLS policies updated for super admin access
*/

-- Create a function to create users with metadata (this would typically be done via Supabase Auth API)
-- Note: This is a reference for the accounts that need to be created manually in Supabase Auth

-- SUPER ADMIN ACCOUNT
-- Email: superadmin@gstbilling.com
-- Password: SuperAdmin@123
-- Metadata: {"role": "super_admin", "tenant_id": null}

-- TENANT 1 - TechCorp Solutions
-- Email: admin@techcorp.com
-- Password: TechCorp@123
-- Metadata: {"role": "tenant_admin", "tenant_id": "tenant_1", "company_name": "TechCorp Solutions Pvt Ltd"}

-- TENANT 2 - Green Energy Systems  
-- Email: admin@greenenergy.com
-- Password: GreenEnergy@123
-- Metadata: {"role": "tenant_admin", "tenant_id": "tenant_2", "company_name": "Green Energy Systems"}

-- TENANT 3 - Manufacturing Corp
-- Email: admin@manufacturing.com
-- Password: Manufacturing@123
-- Metadata: {"role": "tenant_admin", "tenant_id": "tenant_3", "company_name": "Manufacturing Corp Ltd"}

-- TENANT 4 - Retail Solutions
-- Email: admin@retail.com
-- Password: Retail@123
-- Metadata: {"role": "tenant_admin", "tenant_id": "tenant_4", "company_name": "Retail Solutions Pvt Ltd"}

-- TENANT 5 - Service Industries
-- Email: admin@service.com
-- Password: Service@123
-- Metadata: {"role": "tenant_admin", "tenant_id": "tenant_5", "company_name": "Service Industries Ltd"}

-- Update RLS policies to allow super admin access
DO $$
BEGIN
  -- Companies table - Super admin can access all
  DROP POLICY IF EXISTS "Super admin can access all companies" ON companies;
  CREATE POLICY "Super admin can access all companies"
    ON companies
    FOR ALL
    TO authenticated
    USING (auth.jwt() ->> 'role' = 'super_admin');

  -- Products table - Super admin can access all
  DROP POLICY IF EXISTS "Super admin can access all products" ON products;
  CREATE POLICY "Super admin can access all products"
    ON products
    FOR ALL
    TO authenticated
    USING (auth.jwt() ->> 'role' = 'super_admin');

  -- Customers table - Super admin can access all
  DROP POLICY IF EXISTS "Super admin can access all customers" ON customers;
  CREATE POLICY "Super admin can access all customers"
    ON customers
    FOR ALL
    TO authenticated
    USING (auth.jwt() ->> 'role' = 'super_admin');

  -- Invoices table - Super admin can access all
  DROP POLICY IF EXISTS "Super admin can access all invoices" ON invoices;
  CREATE POLICY "Super admin can access all invoices"
    ON invoices
    FOR ALL
    TO authenticated
    USING (auth.jwt() ->> 'role' = 'super_admin');

  -- Invoice items table - Super admin can access all
  DROP POLICY IF EXISTS "Super admin can access all invoice items" ON invoice_items;
  CREATE POLICY "Super admin can access all invoice items"
    ON invoice_items
    FOR ALL
    TO authenticated
    USING (auth.jwt() ->> 'role' = 'super_admin');

  -- Employees table - Super admin can access all
  DROP POLICY IF EXISTS "Super admin can access all employees" ON employees;
  CREATE POLICY "Super admin can access all employees"
    ON employees
    FOR ALL
    TO authenticated
    USING (auth.jwt() ->> 'role' = 'super_admin');

  -- Vendors table - Super admin can access all
  DROP POLICY IF EXISTS "Super admin can access all vendors" ON vendors;
  CREATE POLICY "Super admin can access all vendors"
    ON vendors
    FOR ALL
    TO authenticated
    USING (auth.jwt() ->> 'role' = 'super_admin');
END $$;