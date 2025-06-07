/*
  # Create Additional Tenant Data

  1. New Companies
    - Manufacturing Corp Ltd (tenant_3)
    - Retail Solutions Pvt Ltd (tenant_4) 
    - Service Industries Ltd (tenant_5)

  2. Sample Data
    - Products for each tenant
    - Customers for each tenant
    - Basic company profiles
*/

-- Insert additional companies
INSERT INTO companies (name, gst_number, pan_number, address, contact, bank_details, tenant_id) VALUES
('Manufacturing Corp Ltd', '24AABCM1234F1Z7', 'AABCM1234F',
 '{"street": "Industrial Zone, Plot 45", "city": "Ahmedabad", "state": "Gujarat", "pincode": "380015"}',
 '{"phone": "+91-9876543240", "email": "info@manufacturing.com", "website": "www.manufacturing.com"}',
 '{"accountName": "Manufacturing Corp Ltd", "accountNumber": "3456789012", "ifscCode": "SBI0003456", "bankName": "State Bank of India"}',
 'tenant_3'),
('Retail Solutions Pvt Ltd', '27AABCR1234G1Z8', 'AABCR1234G',
 '{"street": "Commercial Complex, Sector 18", "city": "Noida", "state": "Uttar Pradesh", "pincode": "201301"}',
 '{"phone": "+91-9876543241", "email": "contact@retail.com", "website": "www.retailsolutions.com"}',
 '{"accountName": "Retail Solutions Pvt Ltd", "accountNumber": "4567890123", "ifscCode": "AXIS0004567", "bankName": "Axis Bank"}',
 'tenant_4'),
('Service Industries Ltd', '29AABCS1234H1Z9', 'AABCS1234H',
 '{"street": "Service Hub, IT Park", "city": "Hyderabad", "state": "Telangana", "pincode": "500081"}',
 '{"phone": "+91-9876543242", "email": "hello@service.com", "website": "www.serviceindustries.com"}',
 '{"accountName": "Service Industries Ltd", "accountNumber": "5678901234", "ifscCode": "KOTAK0005678", "bankName": "Kotak Mahindra Bank"}',
 'tenant_5');

-- Insert products for Manufacturing Corp (tenant_3)
INSERT INTO products (name, description, hsn, unit, price, gst_rate, category, warehouse, stock, min_stock, tenant_id) VALUES
('Steel Rod 12mm', 'High grade steel reinforcement rod', '72142000', 'KG', 65.00, 18, 'Raw Materials', 'Warehouse A', 5000, 500, 'tenant_3'),
('Cement Bag 50kg', 'OPC Grade 53 cement', '25231000', 'BAG', 450.00, 28, 'Construction', 'Warehouse A', 200, 50, 'tenant_3'),
('Paint Primer 1L', 'Wall primer for interior/exterior', '32081000', 'LTR', 280.00, 18, 'Paints', 'Warehouse B', 150, 30, 'tenant_3'),
('Electrical Wire 2.5mm', 'Copper electrical wire', '85444200', 'MTR', 25.00, 18, 'Electrical', 'Warehouse B', 2000, 200, 'tenant_3'),
('PVC Pipe 4 inch', 'Pressure pipe for plumbing', '39172900', 'MTR', 180.00, 18, 'Plumbing', 'Warehouse A', 300, 50, 'tenant_3');

-- Insert products for Retail Solutions (tenant_4)
INSERT INTO products (name, description, hsn, unit, price, gst_rate, category, warehouse, stock, min_stock, tenant_id) VALUES
('T-Shirt Cotton', 'Premium cotton t-shirt', '61091000', 'PCS', 450.00, 12, 'Apparel', 'Store A', 500, 50, 'tenant_4'),
('Jeans Denim', 'Branded denim jeans', '62034200', 'PCS', 1200.00, 12, 'Apparel', 'Store A', 200, 20, 'tenant_4'),
('Sports Shoes', 'Running sports shoes', '64041100', 'PAIR', 2500.00, 18, 'Footwear', 'Store B', 100, 10, 'tenant_4'),
('Backpack Travel', 'Waterproof travel backpack', '42021200', 'PCS', 1800.00, 18, 'Accessories', 'Store B', 80, 10, 'tenant_4'),
('Mobile Cover', 'Silicone mobile phone cover', '39269099', 'PCS', 150.00, 18, 'Electronics', 'Store A', 300, 50, 'tenant_4');

-- Insert products for Service Industries (tenant_5)
INSERT INTO products (name, description, hsn, unit, price, gst_rate, category, warehouse, stock, min_stock, tenant_id) VALUES
('Consulting Hours', 'Business consulting service', '99831000', 'HOUR', 2500.00, 18, 'Consulting', 'Virtual', 0, 0, 'tenant_5'),
('Software License', 'Annual software license', '99831000', 'LICENSE', 25000.00, 18, 'Software', 'Virtual', 50, 5, 'tenant_5'),
('Training Program', 'Professional training program', '99831000', 'PROGRAM', 15000.00, 18, 'Training', 'Virtual', 20, 2, 'tenant_5'),
('Maintenance Contract', 'Annual maintenance service', '99831000', 'CONTRACT', 50000.00, 18, 'Maintenance', 'Virtual', 10, 1, 'tenant_5'),
('Support Package', 'Technical support package', '99831000', 'PACKAGE', 8000.00, 18, 'Support', 'Virtual', 30, 5, 'tenant_5');

-- Insert customers for Manufacturing Corp (tenant_3)
INSERT INTO customers (name, gst_number, address, contact, customer_type, tenant_id) VALUES
('BuildTech Constructions', '24AABCB1234I1Z0',
 '{"street": "Construction Site 12", "city": "Ahmedabad", "state": "Gujarat", "pincode": "380016"}',
 '{"phone": "+91-9876543250", "email": "orders@buildtech.com"}', 'business', 'tenant_3'),
('Home Builders Pvt Ltd', '27AABCH1234J1Z1',
 '{"street": "Builder Complex", "city": "Mumbai", "state": "Maharashtra", "pincode": "400050"}',
 '{"phone": "+91-9876543251", "email": "purchase@homebuilders.com"}', 'business', 'tenant_3'),
('Suresh Contractor', NULL,
 '{"street": "Contractor Lane 45", "city": "Surat", "state": "Gujarat", "pincode": "395007"}',
 '{"phone": "+91-9876543252", "email": "suresh.contractor@email.com"}', 'individual', 'tenant_3');

-- Insert customers for Retail Solutions (tenant_4)
INSERT INTO customers (name, gst_number, address, contact, customer_type, tenant_id) VALUES
('Fashion Hub Stores', '09AABCF1234K1Z2',
 '{"street": "Mall Complex, Sector 15", "city": "Gurgaon", "state": "Haryana", "pincode": "122015"}',
 '{"phone": "+91-9876543253", "email": "buying@fashionhub.com"}', 'business', 'tenant_4'),
('Style Point Retail', '24AABCS1234L1Z3',
 '{"street": "Shopping Center", "city": "Pune", "state": "Maharashtra", "pincode": "411038"}',
 '{"phone": "+91-9876543254", "email": "orders@stylepoint.com"}', 'business', 'tenant_4'),
('Rahul Sharma', NULL,
 '{"street": "Residential Area", "city": "Delhi", "state": "Delhi", "pincode": "110025"}',
 '{"phone": "+91-9876543255", "email": "rahul.sharma@email.com"}', 'individual', 'tenant_4');

-- Insert customers for Service Industries (tenant_5)
INSERT INTO customers (name, gst_number, address, contact, customer_type, tenant_id) VALUES
('TechStart Solutions', '36AABCT1234M1Z4',
 '{"street": "Tech Park Phase 3", "city": "Hyderabad", "state": "Telangana", "pincode": "500032"}',
 '{"phone": "+91-9876543256", "email": "admin@techstart.com"}', 'business', 'tenant_5'),
('Digital Innovations Ltd', '29AABCD1234N1Z5',
 '{"street": "Innovation Hub", "city": "Bangalore", "state": "Karnataka", "pincode": "560103"}',
 '{"phone": "+91-9876543257", "email": "contact@digitalinnovations.com"}', 'business', 'tenant_5'),
('Startup Accelerator', '27AABCS1234O1Z6',
 '{"street": "Startup Campus", "city": "Mumbai", "state": "Maharashtra", "pincode": "400070"}',
 '{"phone": "+91-9876543258", "email": "info@startupaccelerator.com"}', 'business', 'tenant_5');

-- Insert employees for Manufacturing Corp (tenant_3)
INSERT INTO employees (name, employee_id, email, phone, position, department, salary, join_date, status, address, tenant_id) VALUES
('Rajesh Patel', 'MFG001', 'rajesh.patel@manufacturing.com', '+91-9876543260', 'Production Manager', 'Production', 85000.00, '2023-01-05', 'active',
 '{"street": "Industrial Area", "city": "Ahmedabad", "state": "Gujarat", "pincode": "380017"}', 'tenant_3'),
('Priya Shah', 'MFG002', 'priya.shah@manufacturing.com', '+91-9876543261', 'Quality Engineer', 'Quality Control', 65000.00, '2023-02-10', 'active',
 '{"street": "Quality Street", "city": "Ahmedabad", "state": "Gujarat", "pincode": "380018"}', 'tenant_3');

-- Insert employees for Retail Solutions (tenant_4)
INSERT INTO employees (name, employee_id, email, phone, position, department, salary, join_date, status, address, tenant_id) VALUES
('Amit Kumar', 'RET001', 'amit.kumar@retail.com', '+91-9876543262', 'Store Manager', 'Retail Operations', 55000.00, '2023-01-15', 'active',
 '{"street": "Retail Complex", "city": "Noida", "state": "Uttar Pradesh", "pincode": "201302"}', 'tenant_4'),
('Sneha Gupta', 'RET002', 'sneha.gupta@retail.com', '+91-9876543263', 'Sales Executive', 'Sales', 35000.00, '2023-03-01', 'active',
 '{"street": "Sales Avenue", "city": "Noida", "state": "Uttar Pradesh", "pincode": "201303"}', 'tenant_4');

-- Insert employees for Service Industries (tenant_5)
INSERT INTO employees (name, employee_id, email, phone, position, department, salary, join_date, status, address, tenant_id) VALUES
('Vikash Singh', 'SER001', 'vikash.singh@service.com', '+91-9876543264', 'Senior Consultant', 'Consulting', 95000.00, '2022-11-01', 'active',
 '{"street": "Consultant Lane", "city": "Hyderabad", "state": "Telangana", "pincode": "500082"}', 'tenant_5'),
('Kavita Reddy', 'SER002', 'kavita.reddy@service.com', '+91-9876543265', 'Training Specialist', 'Training', 70000.00, '2023-01-20', 'active',
 '{"street": "Training Center", "city": "Hyderabad", "state": "Telangana", "pincode": "500083"}', 'tenant_5');

-- Insert vendors for Manufacturing Corp (tenant_3)
INSERT INTO vendors (name, gst_number, address, contact, category, tenant_id) VALUES
('Steel Suppliers Ltd', '24AABCS1234P1Z7',
 '{"street": "Steel Market", "city": "Ahmedabad", "state": "Gujarat", "pincode": "380019"}',
 '{"phone": "+91-79-12345690", "email": "sales@steelsuppliers.com"}', 'Raw Materials', 'tenant_3'),
('Cement Works India', '24AABCC1234Q1Z8',
 '{"street": "Cement Factory Road", "city": "Rajkot", "state": "Gujarat", "pincode": "360001"}',
 '{"phone": "+91-281-12345691", "email": "orders@cementworks.com"}', 'Construction', 'tenant_3');

-- Insert vendors for Retail Solutions (tenant_4)
INSERT INTO vendors (name, gst_number, address, contact, category, tenant_id) VALUES
('Fashion Wholesale Hub', '09AABCF1234R1Z9',
 '{"street": "Wholesale Market", "city": "Delhi", "state": "Delhi", "pincode": "110006"}',
 '{"phone": "+91-11-12345692", "email": "wholesale@fashionhub.com"}', 'Apparel', 'tenant_4'),
('Footwear Distributors', '27AABCF1234S1Z0',
 '{"street": "Shoe Market", "city": "Agra", "state": "Uttar Pradesh", "pincode": "282001"}',
 '{"phone": "+91-562-12345693", "email": "distribution@footwear.com"}', 'Footwear', 'tenant_4');

-- Insert vendors for Service Industries (tenant_5)
INSERT INTO vendors (name, gst_number, address, contact, category, tenant_id) VALUES
('Software Partners Ltd', '29AABCS1234T1Z1',
 '{"street": "Software Park", "city": "Bangalore", "state": "Karnataka", "pincode": "560104"}',
 '{"phone": "+91-80-12345694", "email": "partnerships@softwarepartners.com"}', 'Software', 'tenant_5'),
('Training Resources Inc', '36AABCT1234U1Z2',
 '{"street": "Education Hub", "city": "Hyderabad", "state": "Telangana", "pincode": "500084"}',
 '{"phone": "+91-40-12345695", "email": "resources@trainingresources.com"}', 'Training', 'tenant_5');