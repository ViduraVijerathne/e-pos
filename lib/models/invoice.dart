import 'package:mysql_client/mysql_client.dart';
import 'package:point_of_sale/models/customer.dart';
import 'package:point_of_sale/models/invoice_item.dart';

import '../utils/app_data.dart';
import '../utils/database.dart';

class Invoice{

   int id;
  final String barcode;
  final Customer customer;
  final double invoiceTotal;
  final double discountTotal;
  final double grandTotal;
  final DateTime invoiceDate;
  final double paidAmount;
  final double balance;
  List<InvoiceItem> items;


  Invoice({required this.id,required this.barcode,required this.customer,required this.invoiceTotal,required this.discountTotal,required this.grandTotal,required this.invoiceDate,
  required this.paidAmount,required this.balance,required this.items});

  static const String COLNAME_ID = "invoice_id";
  static const String COLNAME_BARCODE = "barcode";
  static const String COLNAME_CUSTOMER = "customer_customer_id";
  static const String COLNAME_INVOICE_TOTAL = "invoice_total";
  static const String COLNAME_DISCOUNT_TOTAL = "invoice_all_descount";
  static const String COLNAME_GRAND_TOTAL = "invoice_grand_total";
  static const String COLNAME_INVOICE_DATE = "invoice_date";
  static const String COLNAME_PAID_AMOUNT = "paid_amount";
  static const String COLNAME_BALANCE = "balance";
  static const String TABLE_NAME = "invoice";

  static const String INSERTQUERY = "INSERT INTO `invoice` (`barcode`, `customer_customer_id`, `invoice_total`, `invoice_all_descount`, `invoice_grand_total`, `paid_amount`, `balance`, `invoice_date`) VALUES (?,?,?,?,?,?,?,?)";
  static const String SELECTQUERY = "SELECT * FROM invoice ";

  Future<void> insert()async{
    final conn = await MySQLConnection.createConnection(
      host: AppData.dbURL,
      port: AppData.dbPORT,
      userName: AppData.dbUser,
      password: AppData.dbPassword,
      databaseName: AppData.dbName, // optional
    );

    await conn.connect();
    var smtp = await conn.prepare(INSERTQUERY);
    var results = await smtp.execute([
      barcode,
      customer.id,
      invoiceTotal,
      discountTotal,
      grandTotal,
     paidAmount,
      balance,
      invoiceDate.toIso8601String()
    ]);
    print(results.lastInsertID);
    id = results.lastInsertID.toInt();
    for(var item in items){
      item.invoiceID = results.lastInsertID.toInt();

      await item.insert();
    }
    conn.close();
  }

  static Stream<List<Invoice>> getAll() async*{
    List<Invoice> invoices = [];
    final pool = MySQLDatabase().pool;
    var results = await pool.execute(SELECTQUERY);
    print("INVOICES COUNT : ${results.rows.length}");
    for(var row in results.rows){
      print("INVOICE ID ${row.colByName(COLNAME_ID)}");
      List<InvoiceItem> invoiceItem = await InvoiceItem.getByInvoiceID(row.colByName(COLNAME_ID) as String);
      // List<InvoiceItem> invoiceItem = [];

      Invoice invoice = Invoice(
        id: int.parse(row.colByName(COLNAME_ID) as String),
        barcode: row.colByName(COLNAME_BARCODE) as String,
        customer: await Customer.getByID(row.colByName(COLNAME_CUSTOMER) as String),
        invoiceTotal: double.parse(row.colByName(COLNAME_INVOICE_TOTAL) as String),
        discountTotal: double.parse(row.colByName(COLNAME_DISCOUNT_TOTAL) as String),
        grandTotal: double.parse(row.colByName(COLNAME_GRAND_TOTAL) as String),
        invoiceDate: DateTime.parse(row.colByName(COLNAME_INVOICE_DATE) as String),
        paidAmount: double.parse(row.colByName(COLNAME_PAID_AMOUNT) as String),
        balance: double.parse(row.colByName(COLNAME_BALANCE) as String),
        items: invoiceItem
      );
      // Customer customer= await Customer.getByID(row.colByName(COLNAME_CUSTOMER) as String);
      // Invoice invoice = Invoice(
      //     id: int.parse(row.colByName(COLNAME_ID) as String),
      //     barcode: row.colByName(COLNAME_BARCODE) as String,
      //     customer: Customer(id: 0,name: "",contact: "",address: ""),
      //     invoiceTotal: 0,
      //     discountTotal: 0,
      //     grandTotal: 0,
      //     invoiceDate: DateTime.now(),
      //     paidAmount: 100,
      //     balance: 0,
      //     items: invoiceItem
      // );
      invoices.add(invoice);

    }
  }
  
  static Future<Invoice> getByID(int id)async{
    List<Invoice> invoices = [];
    final pool = MySQLDatabase().pool;
    var results = await pool.execute("SELECT * FROM invoice WHERE ${COLNAME_ID} = '$id'");

    // List<InvoiceItem> invoiceItem = await InvoiceItem.getByInvoiceID(id.toString());
    List<InvoiceItem> invoiceItem = [];
    for(var row in results.rows){
      Invoice invoice = Invoice(
          id: int.parse(row.colByName(COLNAME_ID) as String),
          barcode: row.colByName(COLNAME_BARCODE) as String,
          customer: await Customer.getByID(row.colByName(COLNAME_CUSTOMER) as String),
          invoiceTotal: double.parse(row.colByName(COLNAME_INVOICE_TOTAL) as String),
          discountTotal: double.parse(row.colByName(COLNAME_DISCOUNT_TOTAL) as String),
          grandTotal: double.parse(row.colByName(COLNAME_GRAND_TOTAL) as String),
          invoiceDate: DateTime.parse(row.colByName(COLNAME_INVOICE_DATE) as String),
          paidAmount: double.parse(row.colByName(COLNAME_PAID_AMOUNT) as String),
          balance: double.parse(row.colByName(COLNAME_BALANCE) as String),
          items: invoiceItem
      );
      invoices.add(invoice);
    }

    return invoices.first;

  }

}