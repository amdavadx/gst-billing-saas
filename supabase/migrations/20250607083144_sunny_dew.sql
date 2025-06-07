/*
  # Create employees table

  1. New Tables
    - `employees`
      - `id` (uuid, primary key)
      - `name` (text)
      - `employee_id` (text, unique)
      - `email` (text)
      - `phone` (text)
      - `position` (text)
      - `department` (text)
      - `salary` (decimal)
      - `join_date` (date)
      - `status` (text)
      - `address` (jsonb)
      - `tenant_id` (text)
      - `created_at` (timestamp)

  2. Security
    - Enable RLS on `employees` table
    - Add policies for CRUD operations
*/

CREATE TABLE IF NOT EXISTS employees (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  employee_id text UNIQUE NOT NULL,
  email text NOT NULL,
  phone text NOT NULL,
  position text NOT NULL,
  department text NOT NULL,
  salary decimal(10,2) NOT NULL DEFAULT 0,
  join_date date NOT NULL,
  status text NOT NULL DEFAULT 'active' CHECK (status IN ('active', 'inactive')),
  address jsonb NOT NULL DEFAULT '{}',
  tenant_id text NOT NULL,
  created_at timestamptz DEFAULT now()
);

ALTER TABLE employees ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can read own employees"
  ON employees
  FOR SELECT
  TO authenticated
  USING (tenant_id = auth.jwt() ->> 'tenant_id');

CREATE POLICY "Users can insert own employees"
  ON employees
  FOR INSERT
  TO authenticated
  WITH CHECK (tenant_id = auth.jwt() ->> 'tenant_id');

CREATE POLICY "Users can update own employees"
  ON employees
  FOR UPDATE
  TO authenticated
  USING (tenant_id = auth.jwt() ->> 'tenant_id');

CREATE POLICY "Users can delete own employees"
  ON employees
  FOR DELETE
  TO authenticated
  USING (tenant_id = auth.jwt() ->> 'tenant_id');

-- Insert dummy data
INSERT INTO employees (name, employee_id, email, phone, position, department, salary, join_date, status, address, tenant_id) VALUES
('Arjun Sharma', 'EMP001', 'arjun.sharma@techcorp.com', '+91-9876543230', 'Software Engineer', 'Development', 75000.00, '2023-01-15', 'active',
 '{"street": "12 Tech Avenue", "city": "Mumbai", "state": "Maharashtra", "pincode": "400003"}', 'tenant_1'),
('Sneha Patel', 'EMP002', 'sneha.patel@techcorp.com', '+91-9876543231', 'UI/UX Designer', 'Design', 65000.00, '2023-02-20', 'active',
 '{"street": "34 Design Street", "city": "Mumbai", "state": "Maharashtra", "pincode": "400004"}', 'tenant_1'),
('Vikram Singh', 'EMP003', 'vikram.singh@techcorp.com', '+91-9876543232', 'Project Manager', 'Management', 95000.00, '2022-11-10', 'active',
 '{"street": "56 Manager Lane", "city": "Mumbai", "state": "Maharashtra", "pincode": "400005"}', 'tenant_1'),
('Kavya Reddy', 'EMP004', 'kavya.reddy@techcorp.com', '+91-9876543233', 'QA Engineer', 'Quality Assurance', 55000.00, '2023-03-05', 'active',
 '{"street": "78 Quality Road", "city": "Mumbai", "state": "Maharashtra", "pincode": "400006"}', 'tenant_1'),
('Rohit Kumar', 'EMP005', 'rohit.kumar@techcorp.com', '+91-9876543234', 'DevOps Engineer', 'Operations', 80000.00, '2023-01-30', 'active',
 '{"street": "90 Ops Boulevard", "city": "Mumbai", "state": "Maharashtra", "pincode": "400007"}', 'tenant_1'),
('Sunita Agarwal', 'GE001', 'sunita.agarwal@greenenergy.com', '+91-9876543235', 'Solar Engineer', 'Engineering', 70000.00, '2023-01-10', 'active',
 '{"street": "15 Solar Street", "city": "Delhi", "state": "Delhi", "pincode": "110002"}', 'tenant_2'),
('Manoj Gupta', 'GE002', 'manoj.gupta@greenenergy.com', '+91-9876543236', 'Sales Manager', 'Sales', 85000.00, '2022-12-15', 'active',
 '{"street": "25 Sales Avenue", "city": "Delhi", "state": "Delhi", "pincode": "110003"}', 'tenant_2'),
('Deepika Joshi', 'GE003', 'deepika.joshi@greenenergy.com', '+91-9876543237', 'Installation Supervisor', 'Operations', 60000.00, '2023-02-01', 'active',
 '{"street": "35 Install Road", "city": "Delhi", "state": "Delhi", "pincode": "110004"}', 'tenant_2'),
('Ravi Mehta', 'GE004', 'ravi.mehta@greenenergy.com', '+91-9876543238', 'Finance Manager', 'Finance', 90000.00, '2022-10-20', 'active',
 '{"street": "45 Finance Lane", "city": "Delhi", "state": "Delhi", "pincode": "110005"}', 'tenant_2'),
('Anita Verma', 'GE005', 'anita.verma@greenenergy.com', '+91-9876543239', 'HR Executive', 'Human Resources', 55000.00, '2023-03-10', 'active',
 '{"street": "55 HR Street", "city": "Delhi", "state": "Delhi", "pincode": "110006"}', 'tenant_2');