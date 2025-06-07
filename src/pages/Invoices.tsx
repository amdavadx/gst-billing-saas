import React, { useState } from 'react';
import { Plus, Search, Edit, Trash2, FileText, Download, Eye } from 'lucide-react';
import { useAppContext } from '../context/AppContext';
import { Invoice, InvoiceItem } from '../types';

export function Invoices() {
  const { state, dispatch } = useAppContext();
  const [showForm, setShowForm] = useState(false);
  const [editingInvoice, setEditingInvoice] = useState<Invoice | null>(null);
  const [searchTerm, setSearchTerm] = useState('');
  const [invoiceItems, setInvoiceItems] = useState<InvoiceItem[]>([]);

  const filteredInvoices = state.invoices.filter(invoice =>
    invoice.invoiceNumber.toLowerCase().includes(searchTerm.toLowerCase()) ||
    invoice.customerName.toLowerCase().includes(searchTerm.toLowerCase())
  );

  const calculateGST = (items: InvoiceItem[]) => {
    let subtotal = 0;
    let totalGst = 0;
    
    items.forEach(item => {
      const amount = item.quantity * item.rate;
      const gstAmount = (amount * item.gstRate) / 100;
      item.amount = amount;
      item.gstAmount = gstAmount;
      item.totalAmount = amount + gstAmount;
      subtotal += amount;
      totalGst += gstAmount;
    });

    return { subtotal, totalGst, grandTotal: subtotal + totalGst };
  };

  const addInvoiceItem = () => {
    const newItem: InvoiceItem = {
      productId: '',
      productName: '',
      hsn: '',
      quantity: 1,
      unit: 'PCS',
      rate: 0,
      gstRate: 18,
      amount: 0,
      gstAmount: 0,
      totalAmount: 0,
    };
    setInvoiceItems([...invoiceItems, newItem]);
  };

  const updateInvoiceItem = (index: number, field: keyof InvoiceItem, value: string | number) => {
    const updatedItems = [...invoiceItems];
    updatedItems[index] = { ...updatedItems[index], [field]: value };
    
    if (field === 'productId' && value) {
      const product = state.products.find(p => p.id === value);
      if (product) {
        updatedItems[index].productName = product.name;
        updatedItems[index].hsn = product.hsn;
        updatedItems[index].rate = product.price;
        updatedItems[index].gstRate = product.gstRate;
        updatedItems[index].unit = product.unit;
      }
    }
    
    setInvoiceItems(updatedItems);
  };

  const removeInvoiceItem = (index: number) => {
    setInvoiceItems(invoiceItems.filter((_, i) => i !== index));
  };

  const handleSubmit = (e: React.FormEvent<HTMLFormElement>) => {
    e.preventDefault();
    const formData = new FormData(e.currentTarget);
    
    const customerId = formData.get('customerId') as string;
    const customer = state.customers.find(c => c.id === customerId);
    
    if (!customer) return;

    const { subtotal, totalGst, grandTotal } = calculateGST([...invoiceItems]);
    
    // Check if customer is from same state for GST calculation
    const isSameState = customer.address.state === state.company?.address.state;
    
    const invoiceData: Invoice = {
      id: editingInvoice?.id || Date.now().toString(),
      invoiceNumber: formData.get('invoiceNumber') as string,
      customerId: customer.id,
      customerName: customer.name,
      customerAddress: `${customer.address.street}, ${customer.address.city}, ${customer.address.state} - ${customer.address.pincode}`,
      customerGST: customer.gstNumber,
      date: new Date(formData.get('date') as string),
      dueDate: new Date(formData.get('dueDate') as string),
      items: [...invoiceItems],
      subtotal,
      cgst: isSameState ? totalGst / 2 : 0,
      sgst: isSameState ? totalGst / 2 : 0,
      igst: !isSameState ? totalGst : 0,
      totalGst,
      grandTotal,
      status: 'draft',
      type: formData.get('type') as 'regular' | 'proforma',
      createdAt: editingInvoice?.createdAt || new Date(),
    };

    if (editingInvoice) {
      dispatch({ type: 'UPDATE_INVOICE', payload: invoiceData });
    } else {
      dispatch({ type: 'ADD_INVOICE', payload: invoiceData });
    }

    setShowForm(false);
    setEditingInvoice(null);
    setInvoiceItems([]);
  };

  const handleEdit = (invoice: Invoice) => {
    setEditingInvoice(invoice);
    setInvoiceItems([...invoice.items]);
    setShowForm(true);
  };

  const handleDelete = (id: string) => {
    if (window.confirm('Are you sure you want to delete this invoice?')) {
      dispatch({ type: 'DELETE_INVOICE', payload: id });
    }
  };

  const getStatusColor = (status: string) => {
    switch (status) {
      case 'paid':
        return 'bg-green-100 text-green-800';
      case 'sent':
        return 'bg-blue-100 text-blue-800';
      case 'overdue':
        return 'bg-red-100 text-red-800';
      default:
        return 'bg-gray-100 text-gray-800';
    }
  };

  const generateInvoiceNumber = () => {
    return `INV-${new Date().getFullYear()}-${String(state.invoices.length + 1).padStart(4, '0')}`;
  };

  return (
    <div className="space-y-6">
      <div className="flex justify-between items-center">
        <div>
          <h1 className="text-2xl font-bold text-gray-900">Invoices</h1>
          <p className="mt-1 text-sm text-gray-500">Create and manage GST compliant invoices</p>
        </div>
        <div className="flex space-x-3">
          <button
            onClick={() => setShowForm(true)}
            className="flex items-center px-4 py-2 text-sm font-medium text-white bg-blue-600 rounded-lg hover:bg-blue-700"
          >
            <Plus className="w-4 h-4 mr-2" />
            Create Invoice
          </button>
        </div>
      </div>

      <div className="bg-white shadow-sm border border-gray-200 rounded-lg">
        <div className="p-6 border-b border-gray-200">
          <div className="relative">
            <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 w-4 h-4 text-gray-400" />
            <input
              type="text"
              placeholder="Search invoices..."
              value={searchTerm}
              onChange={(e) => setSearchTerm(e.target.value)}
              className="pl-10 pr-4 py-2 w-full border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
            />
          </div>
        </div>

        <div className="overflow-x-auto">
          <table className="min-w-full divide-y divide-gray-200">
            <thead className="bg-gray-50">
              <tr>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Invoice
                </th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Customer
                </th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Amount
                </th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Status
                </th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Date
                </th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Actions
                </th>
              </tr>
            </thead>
            <tbody className="bg-white divide-y divide-gray-200">
              {filteredInvoices.length === 0 ? (
                <tr>
                  <td colSpan={6} className="px-6 py-12 text-center">
                    <FileText className="mx-auto h-12 w-12 text-gray-400" />
                    <h3 className="mt-2 text-sm font-medium text-gray-900">No invoices</h3>
                    <p className="mt-1 text-sm text-gray-500">Get started by creating a new invoice.</p>
                  </td>
                </tr>
              ) : (
                filteredInvoices.map((invoice) => (
                  <tr key={invoice.id}>
                    <td className="px-6 py-4 whitespace-nowrap">
                      <div>
                        <div className="text-sm font-medium text-gray-900">{invoice.invoiceNumber}</div>
                        <div className="text-sm text-gray-500">{invoice.type}</div>
                      </div>
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap">
                      <div className="text-sm text-gray-900">{invoice.customerName}</div>
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                      ₹{invoice.grandTotal.toLocaleString('en-IN')}
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap">
                      <span className={`inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium ${getStatusColor(invoice.status)}`}>
                        {invoice.status}
                      </span>
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                      {invoice.date.toLocaleDateString('en-IN')}
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm font-medium">
                      <div className="flex space-x-2">
                        <button className="text-gray-600 hover:text-gray-900">
                          <Eye className="w-4 h-4" />
                        </button>
                        <button
                          onClick={() => handleEdit(invoice)}
                          className="text-blue-600 hover:text-blue-900"
                        >
                          <Edit className="w-4 h-4" />
                        </button>
                        <button className="text-green-600 hover:text-green-900">
                          <Download className="w-4 h-4" />
                        </button>
                        <button
                          onClick={() => handleDelete(invoice.id)}
                          className="text-red-600 hover:text-red-900"
                        >
                          <Trash2 className="w-4 h-4" />
                        </button>
                      </div>
                    </td>
                  </tr>
                ))
              )}
            </tbody>
          </table>
        </div>
      </div>

      {showForm && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center p-4 z-50">
          <div className="bg-white rounded-lg max-w-6xl w-full max-h-screen overflow-y-auto">
            <div className="p-6 border-b border-gray-200">
              <h3 className="text-lg font-medium text-gray-900">
                {editingInvoice ? 'Edit Invoice' : 'Create New Invoice'}
              </h3>
            </div>
            
            <form onSubmit={handleSubmit} className="p-6 space-y-6">
              <div className="grid grid-cols-4 gap-4">
                <div>
                  <label className="block text-sm font-medium text-gray-700">Invoice Number</label>
                  <input
                    type="text"
                    name="invoiceNumber"
                    defaultValue={editingInvoice?.invoiceNumber || generateInvoiceNumber()}
                    required
                    className="mt-1 block w-full border border-gray-300 rounded-md px-3 py-2 focus:ring-blue-500 focus:border-blue-500"
                  />
                </div>
                <div>
                  <label className="block text-sm font-medium text-gray-700">Customer</label>
                  <select
                    name="customerId"
                    defaultValue={editingInvoice?.customerId}
                    required
                    className="mt-1 block w-full border border-gray-300 rounded-md px-3 py-2 focus:ring-blue-500 focus:border-blue-500"
                  >
                    <option value="">Select Customer</option>
                    {state.customers.map(customer => (
                      <option key={customer.id} value={customer.id}>{customer.name}</option>
                    ))}
                  </select>
                </div>
                <div>
                  <label className="block text-sm font-medium text-gray-700">Invoice Date</label>
                  <input
                    type="date"
                    name="date"
                    defaultValue={editingInvoice?.date.toISOString().split('T')[0] || new Date().toISOString().split('T')[0]}
                    required
                    className="mt-1 block w-full border border-gray-300 rounded-md px-3 py-2 focus:ring-blue-500 focus:border-blue-500"
                  />
                </div>
                <div>
                  <label className="block text-sm font-medium text-gray-700">Due Date</label>
                  <input
                    type="date"
                    name="dueDate"
                    defaultValue={editingInvoice?.dueDate.toISOString().split('T')[0]}
                    required
                    className="mt-1 block w-full border border-gray-300 rounded-md px-3 py-2 focus:ring-blue-500 focus:border-blue-500"
                  />
                </div>
              </div>

              <div>
                <label className="block text-sm font-medium text-gray-700">Invoice Type</label>
                <select
                  name="type"
                  defaultValue={editingInvoice?.type || 'regular'}
                  className="mt-1 block w-full border border-gray-300 rounded-md px-3 py-2 focus:ring-blue-500 focus:border-blue-500"
                >
                  <option value="regular">Regular Invoice</option>
                  <option value="proforma">Proforma Invoice</option>
                </select>
              </div>

              <div>
                <div className="flex justify-between items-center mb-4">
                  <h4 className="text-lg font-medium text-gray-900">Invoice Items</h4>
                  <button
                    type="button"
                    onClick={addInvoiceItem}
                    className="flex items-center px-3 py-2 text-sm font-medium text-blue-600 bg-blue-50 border border-blue-200 rounded-md hover:bg-blue-100"
                  >
                    <Plus className="w-4 h-4 mr-1" />
                    Add Item
                  </button>
                </div>

                <div className="overflow-x-auto">
                  <table className="min-w-full border border-gray-300">
                    <thead className="bg-gray-50">
                      <tr>
                        <th className="px-3 py-2 text-left text-xs font-medium text-gray-500 uppercase border-r">Product</th>
                        <th className="px-3 py-2 text-left text-xs font-medium text-gray-500 uppercase border-r">HSN</th>
                        <th className="px-3 py-2 text-left text-xs font-medium text-gray-500 uppercase border-r">Qty</th>
                        <th className="px-3 py-2 text-left text-xs font-medium text-gray-500 uppercase border-r">Unit</th>
                        <th className="px-3 py-2 text-left text-xs font-medium text-gray-500 uppercase border-r">Rate</th>
                        <th className="px-3 py-2 text-left text-xs font-medium text-gray-500 uppercase border-r">GST%</th>
                        <th className="px-3 py-2 text-left text-xs font-medium text-gray-500 uppercase border-r">Amount</th>
                        <th className="px-3 py-2 text-left text-xs font-medium text-gray-500 uppercase">Action</th>
                      </tr>
                    </thead>
                    <tbody>
                      {invoiceItems.map((item, index) => (
                        <tr key={index} className="border-t">
                          <td className="px-3 py-2 border-r">
                            <select
                              value={item.productId}
                              onChange={(e) => updateInvoiceItem(index, 'productId', e.target.value)}
                              className="w-full border border-gray-300 rounded px-2 py-1 text-sm"
                            >
                              <option value="">Select Product</option>
                              {state.products.map(product => (
                                <option key={product.id} value={product.id}>{product.name}</option>
                              ))}
                            </select>
                          </td>
                          <td className="px-3 py-2 border-r">
                            <input
                              type="text"
                              value={item.hsn}
                              onChange={(e) => updateInvoiceItem(index, 'hsn', e.target.value)}
                              className="w-full border border-gray-300 rounded px-2 py-1 text-sm"
                            />
                          </td>
                          <td className="px-3 py-2 border-r">
                            <input
                              type="number"
                              value={item.quantity}
                              onChange={(e) => updateInvoiceItem(index, 'quantity', parseFloat(e.target.value))}
                              className="w-full border border-gray-300 rounded px-2 py-1 text-sm"
                            />
                          </td>
                          <td className="px-3 py-2 border-r">
                            <input
                              type="text"
                              value={item.unit}
                              onChange={(e) => updateInvoiceItem(index, 'unit', e.target.value)}
                              className="w-full border border-gray-300 rounded px-2 py-1 text-sm"
                            />
                          </td>
                          <td className="px-3 py-2 border-r">
                            <input
                              type="number"
                              step="0.01"
                              value={item.rate}
                              onChange={(e) => updateInvoiceItem(index, 'rate', parseFloat(e.target.value))}
                              className="w-full border border-gray-300 rounded px-2 py-1 text-sm"
                            />
                          </td>
                          <td className="px-3 py-2 border-r">
                            <input
                              type="number"
                              value={item.gstRate}
                              onChange={(e) => updateInvoiceItem(index, 'gstRate', parseFloat(e.target.value))}
                              className="w-full border border-gray-300 rounded px-2 py-1 text-sm"
                            />
                          </td>
                          <td className="px-3 py-2 border-r text-sm">
                            ₹{(item.quantity * item.rate).toFixed(2)}
                          </td>
                          <td className="px-3 py-2">
                            <button
                              type="button"
                              onClick={() => removeInvoiceItem(index)}
                              className="text-red-600 hover:text-red-900"
                            >
                              <Trash2 className="w-4 h-4" />
                            </button>
                          </td>
                        </tr>
                      ))}
                    </tbody>
                  </table>
                </div>

                {invoiceItems.length > 0 && (
                  <div className="mt-4 bg-gray-50 p-4 rounded-lg">
                    <div className="flex justify-end">
                      <div className="w-64 space-y-2">
                        <div className="flex justify-between text-sm">
                          <span>Subtotal:</span>
                          <span>₹{calculateGST(invoiceItems).subtotal.toFixed(2)}</span>
                        </div>
                        <div className="flex justify-between text-sm">
                          <span>GST:</span>
                          <span>₹{calculateGST(invoiceItems).totalGst.toFixed(2)}</span>
                        </div>
                        <div className="flex justify-between font-medium text-base border-t pt-2">
                          <span>Total:</span>
                          <span>₹{calculateGST(invoiceItems).grandTotal.toFixed(2)}</span>
                        </div>
                      </div>
                    </div>
                  </div>
                )}
              </div>

              <div className="flex justify-end space-x-3 pt-4 border-t">
                <button
                  type="button"
                  onClick={() => {
                    setShowForm(false);
                    setEditingInvoice(null);
                    setInvoiceItems([]);
                  }}
                  className="px-4 py-2 text-sm font-medium text-gray-700 bg-white border border-gray-300 rounded-md hover:bg-gray-50"
                >
                  Cancel
                </button>
                <button
                  type="submit"
                  className="px-4 py-2 text-sm font-medium text-white bg-blue-600 border border-transparent rounded-md hover:bg-blue-700"
                >
                  {editingInvoice ? 'Update Invoice' : 'Create Invoice'}
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </div>
  );
}