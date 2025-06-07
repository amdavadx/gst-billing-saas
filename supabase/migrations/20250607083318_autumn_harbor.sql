/*
  # Insert sample invoices with items

  1. Sample Data
    - Create 10 sample invoices with invoice items
    - Mix of different customers and products
    - Various statuses and types
*/

-- First, let's get some customer and product IDs for our sample invoices
-- We'll create the invoices with realistic data

-- Sample Invoice 1
DO $$
DECLARE
    invoice_id uuid;
    customer_uuid uuid;
    product1_uuid uuid;
    product2_uuid uuid;
BEGIN
    -- Get customer ID
    SELECT id INTO customer_uuid FROM customers WHERE name = 'Acme Corporation Ltd' AND tenant_id = 'tenant_1' LIMIT 1;
    
    -- Get product IDs
    SELECT id INTO product1_uuid FROM products WHERE name = 'Laptop Dell Inspiron 15' AND tenant_id = 'tenant_1' LIMIT 1;
    SELECT id INTO product2_uuid FROM products WHERE name = 'Wireless Mouse Logitech' AND tenant_id = 'tenant_1' LIMIT 1;
    
    -- Insert invoice
    INSERT INTO invoices (
        invoice_number, customer_id, customer_name, customer_address, customer_gst,
        date, due_date, subtotal, cgst, sgst, igst, total_gst, grand_total,
        status, type, tenant_id
    ) VALUES (
        'INV-2024-0001', customer_uuid, 'Acme Corporation Ltd',
        'Plot 123, Industrial Area, Mumbai, Maharashtra - 400002', '27AABCA1234C1Z5',
        '2024-01-15', '2024-02-14', 46200.00, 4158.00, 4158.00, 0, 8316.00, 54516.00,
        'paid', 'regular', 'tenant_1'
    ) RETURNING id INTO invoice_id;
    
    -- Insert invoice items
    INSERT INTO invoice_items (
        invoice_id, product_id, product_name, hsn, quantity, unit, rate, gst_rate,
        amount, gst_amount, total_amount
    ) VALUES 
    (invoice_id, product1_uuid::text, 'Laptop Dell Inspiron 15', '84713020', 1, 'PCS', 45000.00, 18, 45000.00, 8100.00, 53100.00),
    (invoice_id, product2_uuid::text, 'Wireless Mouse Logitech', '84716020', 1, 'PCS', 1200.00, 18, 1200.00, 216.00, 1416.00);
END $$;

-- Sample Invoice 2
DO $$
DECLARE
    invoice_id uuid;
    customer_uuid uuid;
    product_uuid uuid;
BEGIN
    SELECT id INTO customer_uuid FROM customers WHERE name = 'Global Tech Solutions' AND tenant_id = 'tenant_1' LIMIT 1;
    SELECT id INTO product_uuid FROM products WHERE name = 'Office Chair Executive' AND tenant_id = 'tenant_1' LIMIT 1;
    
    INSERT INTO invoices (
        invoice_number, customer_id, customer_name, customer_address, customer_gst,
        date, due_date, subtotal, cgst, sgst, igst, total_gst, grand_total,
        status, type, tenant_id
    ) VALUES (
        'INV-2024-0002', customer_uuid, 'Global Tech Solutions',
        'Tower B, Tech Park, Pune, Maharashtra - 411001', '29AABCG1234D1Z2',
        '2024-01-20', '2024-02-19', 42500.00, 3825.00, 3825.00, 0, 7650.00, 50150.00,
        'sent', 'regular', 'tenant_1'
    ) RETURNING id INTO invoice_id;
    
    INSERT INTO invoice_items (
        invoice_id, product_id, product_name, hsn, quantity, unit, rate, gst_rate,
        amount, gst_amount, total_amount
    ) VALUES 
    (invoice_id, product_uuid::text, 'Office Chair Executive', '94013000', 5, 'PCS', 8500.00, 18, 42500.00, 7650.00, 50150.00);
END $$;

-- Sample Invoice 3
DO $$
DECLARE
    invoice_id uuid;
    customer_uuid uuid;
    product_uuid uuid;
BEGIN
    SELECT id INTO customer_uuid FROM customers WHERE name = 'Rajesh Kumar' AND tenant_id = 'tenant_1' LIMIT 1;
    SELECT id INTO product_uuid FROM products WHERE name = 'LED Monitor 24 inch' AND tenant_id = 'tenant_1' LIMIT 1;
    
    INSERT INTO invoices (
        invoice_number, customer_id, customer_name, customer_address, customer_gst,
        date, due_date, subtotal, cgst, sgst, igst, total_gst, grand_total,
        status, type, tenant_id
    ) VALUES (
        'INV-2024-0003', customer_uuid, 'Rajesh Kumar',
        '45 MG Road, Bangalore, Karnataka - 560001', NULL,
        '2024-01-25', '2024-02-24', 24000.00, 0, 0, 4320.00, 4320.00, 28320.00,
        'draft', 'regular', 'tenant_1'
    ) RETURNING id INTO invoice_id;
    
    INSERT INTO invoice_items (
        invoice_id, product_id, product_name, hsn, quantity, unit, rate, gst_rate,
        amount, gst_amount, total_amount
    ) VALUES 
    (invoice_id, product_uuid::text, 'LED Monitor 24 inch', '85285200', 2, 'PCS', 12000.00, 18, 24000.00, 4320.00, 28320.00);
END $$;

-- Sample Invoice 4
DO $$
DECLARE
    invoice_id uuid;
    customer_uuid uuid;
    product_uuid uuid;
BEGIN
    SELECT id INTO customer_uuid FROM customers WHERE name = 'Metro Industries Pvt Ltd' AND tenant_id = 'tenant_1' LIMIT 1;
    SELECT id INTO product_uuid FROM products WHERE name = 'A4 Paper Ream' AND tenant_id = 'tenant_1' LIMIT 1;
    
    INSERT INTO invoices (
        invoice_number, customer_id, customer_name, customer_address, customer_gst,
        date, due_date, subtotal, cgst, sgst, igst, total_gst, grand_total,
        status, type, tenant_id
    ) VALUES (
        'INV-2024-0004', customer_uuid, 'Metro Industries Pvt Ltd',
        '56 Industrial Estate, Chennai, Tamil Nadu - 600001', '27AABCM1234E1Z3',
        '2024-02-01', '2024-03-02', 7000.00, 0, 0, 840.00, 840.00, 7840.00,
        'overdue', 'regular', 'tenant_1'
    ) RETURNING id INTO invoice_id;
    
    INSERT INTO invoice_items (
        invoice_id, product_id, product_name, hsn, quantity, unit, rate, gst_rate,
        amount, gst_amount, total_amount
    ) VALUES 
    (invoice_id, product_uuid::text, 'A4 Paper Ream', '48025590', 20, 'PCS', 350.00, 12, 7000.00, 840.00, 7840.00);
END $$;

-- Sample Invoice 5
DO $$
DECLARE
    invoice_id uuid;
    customer_uuid uuid;
    product_uuid uuid;
BEGIN
    SELECT id INTO customer_uuid FROM customers WHERE name = 'Priya Sharma' AND tenant_id = 'tenant_1' LIMIT 1;
    SELECT id INTO product_uuid FROM products WHERE name = 'Wireless Mouse Logitech' AND tenant_id = 'tenant_1' LIMIT 1;
    
    INSERT INTO invoices (
        invoice_number, customer_id, customer_name, customer_address, customer_gst,
        date, due_date, subtotal, cgst, sgst, igst, total_gst, grand_total,
        status, type, tenant_id
    ) VALUES (
        'PRO-2024-0001', customer_uuid, 'Priya Sharma',
        '12 Park Street, Kolkata, West Bengal - 700001', NULL,
        '2024-02-05', '2024-03-06', 3600.00, 0, 0, 648.00, 648.00, 4248.00,
        'draft', 'proforma', 'tenant_1'
    ) RETURNING id INTO invoice_id;
    
    INSERT INTO invoice_items (
        invoice_id, product_id, product_name, hsn, quantity, unit, rate, gst_rate,
        amount, gst_amount, total_amount
    ) VALUES 
    (invoice_id, product_uuid::text, 'Wireless Mouse Logitech', '84716020', 3, 'PCS', 1200.00, 18, 3600.00, 648.00, 4248.00);
END $$;

-- Solar company invoices (tenant_2)
-- Sample Invoice 6
DO $$
DECLARE
    invoice_id uuid;
    customer_uuid uuid;
    product1_uuid uuid;
    product2_uuid uuid;
BEGIN
    SELECT id INTO customer_uuid FROM customers WHERE name = 'SunPower Energy Ltd' AND tenant_id = 'tenant_2' LIMIT 1;
    SELECT id INTO product1_uuid FROM products WHERE name = 'Solar Panel 100W' AND tenant_id = 'tenant_2' LIMIT 1;
    SELECT id INTO product2_uuid FROM products WHERE name = 'Inverter 1000W' AND tenant_id = 'tenant_2' LIMIT 1;
    
    INSERT INTO invoices (
        invoice_number, customer_id, customer_name, customer_address, customer_gst,
        date, due_date, subtotal, cgst, sgst, igst, total_gst, grand_total,
        status, type, tenant_id
    ) VALUES (
        'GE-2024-0001', customer_uuid, 'SunPower Energy Ltd',
        'Solar Complex, Sector 12, Gurgaon, Haryana - 122001', '09AABCS1234F1Z4',
        '2024-01-10', '2024-02-09', 97000.00, 0, 0, 8745.00, 8745.00, 105745.00,
        'paid', 'regular', 'tenant_2'
    ) RETURNING id INTO invoice_id;
    
    INSERT INTO invoice_items (
        invoice_id, product_id, product_name, hsn, quantity, unit, rate, gst_rate,
        amount, gst_amount, total_amount
    ) VALUES 
    (invoice_id, product1_uuid::text, 'Solar Panel 100W', '85414020', 10, 'PCS', 8500.00, 5, 85000.00, 4250.00, 89250.00),
    (invoice_id, product2_uuid::text, 'Inverter 1000W', '85044000', 1, 'PCS', 12000.00, 18, 12000.00, 2160.00, 14160.00);
END $$;

-- Sample Invoice 7
DO $$
DECLARE
    invoice_id uuid;
    customer_uuid uuid;
    product_uuid uuid;
BEGIN
    SELECT id INTO customer_uuid FROM customers WHERE name = 'EcoHome Solutions' AND tenant_id = 'tenant_2' LIMIT 1;
    SELECT id INTO product_uuid FROM products WHERE name = 'Battery Lithium 12V' AND tenant_id = 'tenant_2' LIMIT 1;
    
    INSERT INTO invoices (
        invoice_number, customer_id, customer_name, customer_address, customer_gst,
        date, due_date, subtotal, cgst, sgst, igst, total_gst, grand_total,
        status, type, tenant_id
    ) VALUES (
        'GE-2024-0002', customer_uuid, 'EcoHome Solutions',
        'Green Building, Eco Park, Surat, Gujarat - 395001', '24AABCE1234G1Z5',
        '2024-01-18', '2024-02-17', 60000.00, 5400.00, 5400.00, 0, 10800.00, 70800.00,
        'sent', 'regular', 'tenant_2'
    ) RETURNING id INTO invoice_id;
    
    INSERT INTO invoice_items (
        invoice_id, product_id, product_name, hsn, quantity, unit, rate, gst_rate,
        amount, gst_amount, total_amount
    ) VALUES 
    (invoice_id, product_uuid::text, 'Battery Lithium 12V', '85076000', 4, 'PCS', 15000.00, 18, 60000.00, 10800.00, 70800.00);
END $$;

-- Sample Invoice 8
DO $$
DECLARE
    invoice_id uuid;
    customer_uuid uuid;
    product_uuid uuid;
BEGIN
    SELECT id INTO customer_uuid FROM customers WHERE name = 'Amit Patel' AND tenant_id = 'tenant_2' LIMIT 1;
    SELECT id INTO product_uuid FROM products WHERE name = 'Mounting Structure' AND tenant_id = 'tenant_2' LIMIT 1;
    
    INSERT INTO invoices (
        invoice_number, customer_id, customer_name, customer_address, customer_gst,
        date, due_date, subtotal, cgst, sgst, igst, total_gst, grand_total,
        status, type, tenant_id
    ) VALUES (
        'GE-2024-0003', customer_uuid, 'Amit Patel',
        '23 Gandhi Nagar, Ahmedabad, Gujarat - 380001', NULL,
        '2024-02-02', '2024-03-03', 7000.00, 630.00, 630.00, 0, 1260.00, 8260.00,
        'draft', 'regular', 'tenant_2'
    ) RETURNING id INTO invoice_id;
    
    INSERT INTO invoice_items (
        invoice_id, product_id, product_name, hsn, quantity, unit, rate, gst_rate,
        amount, gst_amount, total_amount
    ) VALUES 
    (invoice_id, product_uuid::text, 'Mounting Structure', '76109000', 2, 'SET', 3500.00, 18, 7000.00, 1260.00, 8260.00);
END $$;

-- Sample Invoice 9
DO $$
DECLARE
    invoice_id uuid;
    customer_uuid uuid;
    product_uuid uuid;
BEGIN
    SELECT id INTO customer_uuid FROM customers WHERE name = 'Renewable Tech Corp' AND tenant_id = 'tenant_2' LIMIT 1;
    SELECT id INTO product_uuid FROM products WHERE name = 'Cable Solar 4mm' AND tenant_id = 'tenant_2' LIMIT 1;
    
    INSERT INTO invoices (
        invoice_number, customer_id, customer_name, customer_address, customer_gst,
        date, due_date, subtotal, cgst, sgst, igst, total_gst, grand_total,
        status, type, tenant_id
    ) VALUES (
        'GE-2024-0004', customer_uuid, 'Renewable Tech Corp',
        'Innovation Hub, Phase 2, Noida, Uttar Pradesh - 201301', '27AABCR1234H1Z6',
        '2024-02-08', '2024-03-09', 4500.00, 0, 0, 810.00, 810.00, 5310.00,
        'overdue', 'regular', 'tenant_2'
    ) RETURNING id INTO invoice_id;
    
    INSERT INTO invoice_items (
        invoice_id, product_id, product_name, hsn, quantity, unit, rate, gst_rate,
        amount, gst_amount, total_amount
    ) VALUES 
    (invoice_id, product_uuid::text, 'Cable Solar 4mm', '85444900', 100, 'MTR', 45.00, 18, 4500.00, 810.00, 5310.00);
END $$;

-- Sample Invoice 10
DO $$
DECLARE
    invoice_id uuid;
    customer_uuid uuid;
    product1_uuid uuid;
    product2_uuid uuid;
BEGIN
    SELECT id INTO customer_uuid FROM customers WHERE name = 'Neha Singh' AND tenant_id = 'tenant_2' LIMIT 1;
    SELECT id INTO product1_uuid FROM products WHERE name = 'Solar Panel 100W' AND tenant_id = 'tenant_2' LIMIT 1;
    SELECT id INTO product2_uuid FROM products WHERE name = 'Battery Lithium 12V' AND tenant_id = 'tenant_2' LIMIT 1;
    
    INSERT INTO invoices (
        invoice_number, customer_id, customer_name, customer_address, customer_gst,
        date, due_date, subtotal, cgst, sgst, igst, total_gst, grand_total,
        status, type, tenant_id
    ) VALUES (
        'PRO-GE-2024-0001', customer_uuid, 'Neha Singh',
        '78 Civil Lines, Jaipur, Rajasthan - 302001', NULL,
        '2024-02-12', '2024-03-13', 32000.00, 0, 0, 3330.00, 3330.00, 35330.00,
        'draft', 'proforma', 'tenant_2'
    ) RETURNING id INTO invoice_id;
    
    INSERT INTO invoice_items (
        invoice_id, product_id, product_name, hsn, quantity, unit, rate, gst_rate,
        amount, gst_amount, total_amount
    ) VALUES 
    (invoice_id, product1_uuid::text, 'Solar Panel 100W', '85414020', 2, 'PCS', 8500.00, 5, 17000.00, 850.00, 17850.00),
    (invoice_id, product2_uuid::text, 'Battery Lithium 12V', '85076000', 1, 'PCS', 15000.00, 18, 15000.00, 2700.00, 17700.00);
END $$;