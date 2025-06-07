/*
  # Create products table

  1. New Tables
    - `products`
      - `id` (uuid, primary key)
      - `name` (text)
      - `description` (text)
      - `hsn` (text)
      - `unit` (text)
      - `price` (decimal)
      - `gst_rate` (decimal)
      - `category` (text)
      - `warehouse` (text)
      - `stock` (integer)
      - `min_stock` (integer)
      - `tenant_id` (text)
      - `created_at` (timestamp)

  2. Security
    - Enable RLS on `products` table
    - Add policies for CRUD operations
*/

CREATE TABLE IF NOT EXISTS products (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  description text DEFAULT '',
  hsn text NOT NULL,
  unit text NOT NULL,
  price decimal(10,2) NOT NULL DEFAULT 0,
  gst_rate decimal(5,2) NOT NULL DEFAULT 18,
  category text NOT NULL,
  warehouse text NOT NULL,
  stock integer NOT NULL DEFAULT 0,
  min_stock integer NOT NULL DEFAULT 10,
  tenant_id text NOT NULL,
  created_at timestamptz DEFAULT now()
);

ALTER TABLE products ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can read own products"
  ON products
  FOR SELECT
  TO authenticated
  USING (tenant_id = auth.jwt() ->> 'tenant_id');

CREATE POLICY "Users can insert own products"
  ON products
  FOR INSERT
  TO authenticated
  WITH CHECK (tenant_id = auth.jwt() ->> 'tenant_id');

CREATE POLICY "Users can update own products"
  ON products
  FOR UPDATE
  TO authenticated
  USING (tenant_id = auth.jwt() ->> 'tenant_id');

CREATE POLICY "Users can delete own products"
  ON products
  FOR DELETE
  TO authenticated
  USING (tenant_id = auth.jwt() ->> 'tenant_id');

-- Insert dummy data
INSERT INTO products (name, description, hsn, unit, price, gst_rate, category, warehouse, stock, min_stock, tenant_id) VALUES
('Laptop Dell Inspiron 15', 'High-performance laptop for business use', '84713020', 'PCS', 45000.00, 18, 'Electronics', 'Main Warehouse', 25, 5, 'tenant_1'),
('Office Chair Executive', 'Ergonomic office chair with lumbar support', '94013000', 'PCS', 8500.00, 18, 'Furniture', 'Main Warehouse', 15, 3, 'tenant_1'),
('Wireless Mouse Logitech', 'Bluetooth wireless mouse', '84716020', 'PCS', 1200.00, 18, 'Electronics', 'Main Warehouse', 50, 10, 'tenant_1'),
('A4 Paper Ream', 'Premium quality A4 printing paper', '48025590', 'PCS', 350.00, 12, 'Stationery', 'Main Warehouse', 100, 20, 'tenant_1'),
('LED Monitor 24 inch', 'Full HD LED monitor', '85285200', 'PCS', 12000.00, 18, 'Electronics', 'Main Warehouse', 20, 5, 'tenant_1'),
('Solar Panel 100W', 'Monocrystalline solar panel', '85414020', 'PCS', 8500.00, 5, 'Solar Equipment', 'Warehouse A', 30, 5, 'tenant_2'),
('Battery Lithium 12V', 'Deep cycle lithium battery', '85076000', 'PCS', 15000.00, 18, 'Solar Equipment', 'Warehouse A', 20, 3, 'tenant_2'),
('Inverter 1000W', 'Pure sine wave inverter', '85044000', 'PCS', 12000.00, 18, 'Solar Equipment', 'Warehouse A', 15, 2, 'tenant_2'),
('Cable Solar 4mm', 'UV resistant solar cable', '85444900', 'MTR', 45.00, 18, 'Solar Equipment', 'Warehouse B', 500, 100, 'tenant_2'),
('Mounting Structure', 'Aluminum mounting structure for rooftop', '76109000', 'SET', 3500.00, 18, 'Solar Equipment', 'Warehouse A', 25, 5, 'tenant_2');