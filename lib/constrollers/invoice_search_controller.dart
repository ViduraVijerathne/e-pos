import 'package:point_of_sale/models/invoice.dart';
import 'package:point_of_sale/utils/other_utils.dart';

import '../models/customer.dart';
import '../utils/database.dart';
import '../view_models/invoice_view.dart';

class InvoiceSearchController{
  String baseQuery = "SELECT * FROM invoice ";
  List<String> conditions = [];


  void searchByID(String id){
    conditions.add(" ${Invoice.COLNAME_ID} = '$id' ");
  }

  void searchByBarcode(String barcode){
    conditions.add(" ${Invoice.COLNAME_BARCODE} = '$barcode' ");
  }

  void searchByCustomer(String customer){
    conditions.add(" ${Invoice.COLNAME_CUSTOMER} = '$customer' ");
  }

  void searchByInvoiceDate(DateTime invoiceDate){
    conditions.add(" ${Invoice.COLNAME_INVOICE_DATE} LIKE '%${OtherUtils.getDate(invoiceDate)}%' ");
  }

  void searchByInvoiceTotal(String invoiceTotal){
    conditions.add(" ${Invoice.COLNAME_INVOICE_TOTAL} = '$invoiceTotal' ");
  }

  void searchByGrandTotal(String grandTotal){
    conditions.add(" ${Invoice.COLNAME_GRAND_TOTAL} = '$grandTotal' ");
  }

  Future<List<InvoiceViewModel>> searchResults()async{
    if(conditions.isEmpty){
      return InvoiceViewModel.getAllLimit(limit: 20);
    }
    List<InvoiceViewModel> invoices = [];
    final pool = MySQLDatabase().pool;
    var results =await pool.execute("$baseQuery WHERE ${conditions.join(" OR ")}");
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