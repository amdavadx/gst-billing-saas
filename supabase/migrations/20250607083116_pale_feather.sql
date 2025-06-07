/*
  # Create customers table

  1. New Tables
    - `customers`
      - `id` (uuid, primary key)
      - `name` (text)
      - `gst_number` (text, optional)
      - `address` (jsonb)
      - `contact` (jsonb)
      - `customer_type` (text)
      - `tenant_id` (text)
      - `created_at` (timestamp)

  2. Security
    - Enable RLS on `customers` table
    - Add policies for CRUD operations
*/

CREATE TABLE IF NOT EXISTS customers (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  gst_number text,
  address jsonb NOT NULL DEFAULT '{}',
  contact jsonb NOT NULL DEFAULT '{}',
  customer_type text NOT NULL CHECK (customer_type IN ('individual', 'business')),
  tenant_id text NOT NULL,
  created_at timestamptz DEFAULT now()
);

ALTER TABLE customers ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can read own customers"
  ON customers
  FOR SELECT
  TO authenticated
  USING (tenant_id = auth.jwt() ->> 'tenant_id');

CREATE POLICY "Users can insert own customers"
  ON customers
  FOR INSERT
  TO authenticated
  WITH CHECK (tenant_id = auth.jwt() ->> 'tenant_id');

CREATE POLICY "Users can update own customers"
  ON customers
  FOR UPDATE
  TO authenticated
  USING (tenant_id = auth.jwt() ->> 'tenant_id');

CREATE POLICY "Users can delete own customers"
  ON customers
  FOR DELETE
  TO authenticated
  USING (tenant_id = auth.jwt() ->> 'tenant_id');

-- Insert dummy data
INSERT INTO customers (name, gst_number, address, contact, customer_type, tenant_id) VALUES
('Acme Corporation Ltd', '27AABCA1234C1Z5', 
 '{"street": "Plot 123, Industrial Area", "city": "Mumbai", "state": "Maharashtra", "pincode": "400002"}',
 '{"phone": "+91-9876543220", "email": "purchase@acmecorp.com"}', 'business', 'tenant_1'),
('Rajesh Kumar', NULL,
 '{"street": "45 MG Road", "city": "Bangalore", "state": "Karnataka", "pincode": "560001"}',
 '{"phone": "+91-9876543221", "email": "rajesh.kumar@email.com"}', 'individual', 'tenant_1'),
('Global Tech Solutions', '29AABCG1234D1Z2',
 '{"street": "Tower B, Tech Park", "city": "Pune", "state": "Maharashtra", "pincode": "411001"}',
 '{"phone": "+91-9876543222", "email": "info@globaltech.com"}', 'business', 'tenant_1'),
('Priya Sharma', NULL,
 '{"street": "12 Park Street", "city": "Kolkata", "state": "West Bengal", "pincode": "700001"}',
 '{"phone": "+91-9876543223", "email": "priya.sharma@email.com"}', 'individual', 'tenant_1'),
('Metro Industries Pvt Ltd', '27AABCM1234E1Z3',
 '{"street": "56 Industrial Estate", "city": "Chennai", "state": "Tamil Nadu", "pincode": "600001"}',
 '{"phone": "+91-9876543224", "email": "orders@metroindustries.com"}', 'business', 'tenant_1'),
('SunPower Energy Ltd', '09AABCS1234F1Z4',
 '{"street": "Solar Complex, Sector 12", "city": "Gurgaon", "state": "Haryana", "pincode": "122001"}',
 '{"phone": "+91-9876543225", "email": "procurement@sunpower.com"}', 'business', 'tenant_2'),
('Amit Patel', NULL,
 '{"street": "23 Gandhi Nagar", "city": "Ahmedabad", "state": "Gujarat", "pincode": "380001"}',
 '{"phone": "+91-9876543226", "email": "amit.patel@email.com"}', 'individual', 'tenant_2'),
('EcoHome Solutions', '24AABCE1234G1Z5',
 '{"street": "Green Building, Eco Park", "city": "Surat", "state": "Gujarat", "pincode": "395001"}',
 '{"phone": "+91-9876543227", "email": "info@ecohome.com"}', 'business', 'tenant_2'),
('Neha Singh', NULL,
 '{"street": "78 Civil Lines", "city": "Jaipur", "state": "Rajasthan", "pincode": "302001"}',
 '{"phone": "+91-9876543228", "email": "neha.singh@email.com"}', 'individual', 'tenant_2'),
('Renewable Tech Corp', '27AABCR1234H1Z6',
 '{"street": "Innovation Hub, Phase 2", "city": "Noida", "state": "Uttar Pradesh", "pincode": "201301"}',
 '{"phone": "+91-9876543229", "email": "sales@renewabletech.com"}', 'business', 'tenant_2');