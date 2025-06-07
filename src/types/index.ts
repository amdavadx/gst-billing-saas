export interface Company {
  id: string;
  name: string;
  gstNumber: string;
  panNumber: string;
  address: {
    street: string;
    city: string;
    state: string;
    pincode: string;
  };
  contact: {
    phone: string;
    email: string;
    website?: string;
  };
  bankDetails: {
    accountName: string;
    accountNumber: string;
    ifscCode: string;
    bankName: string;
  };
  createdAt: Date;
}

export interface Product {
  id: string;
  name: string;
  description?: string;
  hsn: string;
  unit: string;
  price: number;
  gstRate: number;
  category: string;
  warehouse: string;
  stock: number;
  minStock: number;
  createdAt: Date;
}

export interface Customer {
  id: string;
  name: string;
  gstNumber?: string;
  address: {
    street: string;
    city: string;
    state: string;
    pincode: string;
  };
  contact: {
    phone: string;
    email: string;
  };
  customerType: 'individual' | 'business';
  createdAt: Date;
}

export interface InvoiceItem {
  productId: string;
  productName: string;
  hsn: string;
  quantity: number;
  unit: string;
  rate: number;
  gstRate: number;
  amount: number;
  gstAmount: number;
  totalAmount: number;
}

export interface Invoice {
  id: string;
  invoiceNumber: string;
  customerId: string;
  customerName: string;
  customerAddress: string;
  customerGST?: string;
  date: Date;
  dueDate: Date;
  items: InvoiceItem[];
  subtotal: number;
  cgst: number;
  sgst: number;
  igst: number;
  totalGst: number;
  grandTotal: number;
  status: 'draft' | 'sent' | 'paid' | 'overdue';
  type: 'regular' | 'proforma';
  createdAt: Date;
}

export interface Employee {
  id: string;
  name: string;
  employeeId: string;
  email: string;
  phone: string;
  position: string;
  department: string;
  salary: number;
  joinDate: Date;
  status: 'active' | 'inactive';
  address: {
    street: string;
    city: string;
    state: string;
    pincode: string;
  };
}

export interface Attendance {
  id: string;
  employeeId: string;
  date: Date;
  checkIn?: Date;
  checkOut?: Date;
  status: 'present' | 'absent' | 'late' | 'half-day';
  notes?: string;
}

export interface Vendor {
  id: string;
  name: string;
  gstNumber?: string;
  address: {
    street: string;
    city: string;
    state: string;
    pincode: string;
  };
  contact: {
    phone: string;
    email: string;
  };
  category: string;
  createdAt: Date;
}