/*
  # Create companies table

  1. New Tables
    - `companies`
      - `id` (uuid, primary key)
      - `name` (text)
      - `gst_number` (text, unique)
      - `pan_number` (text)
      - `address` (jsonb)
      - `contact` (jsonb)
      - `bank_details` (jsonb)
      - `tenant_id` (text)
      - `created_at` (timestamp)

  2. Security
    - Enable RLS on `companies` table
    - Add policy for authenticated users to read their own company data
*/

CREATE TABLE IF NOT EXISTS companies (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  gst_number text UNIQUE NOT NULL,
  pan_number text NOT NULL,
  address jsonb NOT NULL DEFAULT '{}',
  contact jsonb NOT NULL DEFAULT '{}',
  bank_details jsonb NOT NULL DEFAULT '{}',
  tenant_id text NOT NULL,
  created_at timestamptz DEFAULT now()
);

ALTER TABLE companies ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can read own company data"
  ON companies
  FOR SELECT
  TO authenticated
  USING (tenant_id = auth.jwt() ->> 'tenant_id');

CREATE POLICY "Users can insert own company data"
  ON companies
  FOR INSERT
  TO authenticated
  WITH CHECK (tenant_id = auth.jwt() ->> 'tenant_id');

CREATE POLICY "Users can update own company data"
  ON companies
  FOR UPDATE
  TO authenticated
  USING (tenant_id = auth.jwt() ->> 'tenant_id');

-- Insert dummy data
INSERT INTO companies (name, gst_number, pan_number, address, contact, bank_details, tenant_id) VALUES
('TechCorp Solutions Pvt Ltd', '27AABCT1234C1Z5', 'AABCT1234C', 
 '{"street": "123 Tech Park, Sector 5", "city": "Mumbai", "state": "Maharashtra", "pincode": "400001"}',
 '{"phone": "+91-9876543210", "email": "info@techcorp.com", "website": "www.techcorp.com"}',
 '{"accountName": "TechCorp Solutions Pvt Ltd", "accountNumber": "1234567890", "ifscCode": "HDFC0001234", "bankName": "HDFC Bank"}',
 'tenant_1'),
('Green Energy Systems', '09AABCG5678D1Z2', 'AABCG5678D',
 '{"street": "456 Green Avenue", "city": "Delhi", "state": "Delhi", "pincode": "110001"}',
 '{"phone": "+91-9876543211", "email": "contact@greenenergy.com", "website": "www.greenenergy.com"}',
 '{"accountName": "Green Energy Systems", "accountNumber": "2345678901", "ifscCode": "ICICI0002345", "bankName": "ICICI Bank"}',
 'tenant_2');