/*
  # Create vendors table

  1. New Tables
    - `vendors`
      - `id` (uuid, primary key)
      - `name` (text)
      - `gst_number` (text, optional)
      - `address` (jsonb)
      - `contact` (jsonb)
      - `category` (text)
      - `tenant_id` (text)
      - `created_at` (timestamp)

  2. Security
    - Enable RLS on `vendors` table
    - Add policies for CRUD operations
*/

CREATE TABLE IF NOT EXISTS vendors (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  gst_number text,
  address jsonb NOT NULL DEFAULT '{}',
  contact jsonb NOT NULL DEFAULT '{}',
  category text NOT NULL,
  tenant_id text NOT NULL,
  created_at timestamptz DEFAULT now()
);

ALTER TABLE vendors ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can read own vendors"
  ON vendors
  FOR SELECT
  TO authenticated
  USING (tenant_id = auth.jwt() ->> 'tenant_id');

CREATE POLICY "Users can insert own vendors"
  ON vendors
  FOR INSERT
  TO authenticated
  WITH CHECK (tenant_id = auth.jwt() ->> 'tenant_id');

CREATE POLICY "Users can update own vendors"
  ON vendors
  FOR UPDATE
  TO authenticated
  USING (tenant_id = auth.jwt() ->> 'tenant_id');

CREATE POLICY "Users can delete own vendors"
  ON vendors
  FOR DELETE
  TO authenticated
  USING (tenant_id = auth.jwt() ->> 'tenant_id');

-- Insert dummy data
INSERT INTO vendors (name, gst_number, address, contact, category, tenant_id) VALUES
('Dell Technologies India', '29AABCD1234E1Z5',
 '{"street": "Dell Campus, Outer Ring Road", "city": "Bangalore", "state": "Karnataka", "pincode": "560037"}',
 '{"phone": "+91-80-12345678", "email": "sales@dell.com"}', 'Electronics', 'tenant_1'),
('Godrej Interio', '27AABCG1234F1Z6',
 '{"street": "Godrej One, Pirojshanagar", "city": "Mumbai", "state": "Maharashtra", "pincode": "400079"}',
 '{"phone": "+91-22-12345679", "email": "corporate@godrejinterio.com"}', 'Furniture', 'tenant_1'),
('Logitech India Pvt Ltd', '29AABCL1234G1Z7',
 '{"street": "Logitech Building, Electronic City", "city": "Bangalore", "state": "Karnataka", "pincode": "560100"}',
 '{"phone": "+91-80-12345680", "email": "business@logitech.com"}', 'Electronics', 'tenant_1'),
('JK Paper Ltd', '09AABCJ1234H1Z8',
 '{"street": "JK House, Connaught Place", "city": "New Delhi", "state": "Delhi", "pincode": "110001"}',
 '{"phone": "+91-11-12345681", "email": "sales@jkpaper.com"}', 'Stationery', 'tenant_1'),
('LG Electronics India', '27AABCL1234I1Z9',
 '{"street": "LG Campus, Noida", "city": "Noida", "state": "Uttar Pradesh", "pincode": "201301"}',
 '{"phone": "+91-120-12345682", "email": "b2b@lge.com"}', 'Electronics', 'tenant_1'),
('Tata Solar Systems', '27AABCT1234J1Z0',
 '{"street": "Tata Centre, Nariman Point", "city": "Mumbai", "state": "Maharashtra", "pincode": "400021"}',
 '{"phone": "+91-22-12345683", "email": "solar@tata.com"}', 'Solar Equipment', 'tenant_2'),
('Luminous Power Technologies', '09AABCL1234K1Z1',
 '{"street": "Luminous House, Sector 37", "city": "Gurgaon", "state": "Haryana", "pincode": "122001"}',
 '{"phone": "+91-124-12345684", "email": "sales@luminousindia.com"}', 'Solar Equipment', 'tenant_2'),
('Exide Industries Ltd', '19AABCE1234L1Z2',
 '{"street": "Exide House, 59E Chowringhee Road", "city": "Kolkata", "state": "West Bengal", "pincode": "700020"}',
 '{"phone": "+91-33-12345685", "email": "industrial@exide.co.in"}', 'Solar Equipment', 'tenant_2'),
('Polycab India Ltd', '24AABCP1234M1Z3',
 '{"street": "Polycab House, Makwana Road", "city": "Mumbai", "state": "Maharashtra", "pincode": "400009"}',
 '{"phone": "+91-22-12345686", "email": "solar@polycab.com"}', 'Solar Equipment', 'tenant_2'),
('Waaree Energies Ltd', '24AABCW1234N1Z4',
 '{"street": "Waaree House, 602 Western Edge II", "city": "Mumbai", "state": "Maharashtra", "pincode": "400063"}',
 '{"phone": "+91-22-12345687", "email": "info@waaree.com"}', 'Solar Equipment', 'tenant_2');