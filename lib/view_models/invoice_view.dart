import 'package:point_of_sale/models/invoice.dart';
import 'package:point_of_sale/utils/database.dart';

import '../models/customer.dart';
import 'invoiceitem_view.dart';

class InvoiceViewModel{
  int id;
  final String barcode;
  final Customer customer;
  final double invoiceTotal;
  final double discountTotal;
  final double grandTotal;
  final DateTime invoiceDate;
  final double paidAmount;
  final double balance;

  InvoiceViewModel(this.id, this.barcode, this.customer, this.invoiceTotal, this.discountTotal, this.grandTotal, this.invoiceDate, this.paidAmount, this.balance);
  
  static Future<List<InvoiceViewModel>> getAllLimit({int limit = 20})async{
    List<InvoiceViewModel> invoices = [];
    final pool = MySQLDatabase().pool;
    var results =await pool.execute("SELECT * FROM invoice LIMIT $limit");

    for (var row in results.rows) {
      InvoiceViewModel invoice = InvoiceViewModel(
        int.parse(row.colByName(Invoice.COLNAME_ID) as String),
        row.colByName(Invoice.COLNAME_BARCODE) as String,
        await Customer.getByID(row.colByName(Invoice.COLNAME_CUSTOMER) as String),
        double.parse(row.colByName(Invoice.COLNAME_INVOICE_TOTAL) as String),
        double.parse(row.colByName(Invoice.COLNAME_DISCOUNT_TOTAL) as String),
        double.parse(row.colByName(Invoice.COLNAME_GRAND_TOTAL) as String),
        DateTime.parse(row.colByName(Invoice.COLNAME_INVOICE_DATE) as String),
        double.parse(row.colByName(Invoice.COLNAME_PAID_AMOUNT) as String),
        double.parse(row.colByName(Invoice.COLNAME_BALANCE) as String),

      );

      invoices.add(invoice);

    }


    return invoices;
    
  }
}