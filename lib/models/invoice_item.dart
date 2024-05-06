import 'package:flutter/foundation.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:point_of_sale/models/grn.dart';
import 'package:point_of_sale/models/main_category.dart';
import 'package:point_of_sale/models/product.dart';
import 'package:point_of_sale/models/stock.dart';
import 'package:point_of_sale/models/sub_category.dart';
import 'package:point_of_sale/models/supplier.dart';
import 'package:point_of_sale/models/unit.dart';

import '../utils/app_data.dart';
import '../utils/database.dart';

class InvoiceItem{

   int invoiceID;
  final Stock stock;
  final Product product;
  final GRN grn;
   int quantity;
  final double unitPrice;
  final double discount;


  InvoiceItem({required this.invoiceID,required this.stock,required this.product,required this.grn,required this.quantity,required this.unitPrice,required this.discount});


  static const String COLNAME_INVOICE_ID = "invoice_invoice_id";
  static const String COLNAME_STOCK = "stock_id";
  static const String COLNAME_PRODUCT = "stock_product_product_id";
  static const String COLNAME_GRN = "stock_grn_grn_id";
  static const String COLNAME_QUANTITY = "invoice_qty";
  static const String COLNAME_UNIT_PRICE = "invoice_unit_price";
  static const String COLNAME_DISCOUNT = "discount";
  static const String TABLE_NAME = "invoice_has_stock";
  static const String INSERTQUERY = "INSERT INTO `invoice_has_stock` (`invoice_invoice_id`, `stock_id`, `stock_product_product_id`, `stock_grn_grn_id`, `invoice_qty`, `invoice_unit_price`, `discount`) VALUES (?,?,?,?,?,?,?);";
  static const String GETBYINVOICEIDQUERY = "SELECT * FROM invoice "
   " INNER JOIN invoice_has_stock ON invoice.invoice_id = invoice_has_stock.invoice_invoice_id "

   " INNER JOIN product ON product.product_id = invoice_has_stock.stock_product_product_id "
   " INNER JOIN main_category ON product.main_category_main_cat_id = main_category.main_cat_id "
   " INNER JOIN sub_category ON product.sub_category_sub_cat_id = sub_category.sub_cat_id "
   " INNER JOIN units ON units.unit_id = product.units_unit_id "
      " INNER JOIN stock ON stock.id = invoice_has_stock.stock_id "
   " INNER JOIN grn ON grn.grn_id = invoice_has_stock.stock_grn_grn_id "
   " INNER JOIN suppliers ON suppliers.supplier_id= grn.suppliers_supplier_id "

   " WHERE invoice.invoice_id = :invoiceID";
  Future<void> insert()async{
   await stock.subQty(quantity);
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
      invoiceID,
      stock.id,
      product.id,
      grn.id,
      quantity,
      unitPrice,
      discount,
    ]);
    conn.close();
  }

  static Future<List<InvoiceItem>> getByInvoiceID(String invoiceID)async{
    List<InvoiceItem> invoiceItems = [];
    final conn = MySQLDatabase().pool;

    var results = await conn.execute(GETBYINVOICEIDQUERY,{
      "invoiceID":invoiceID
    });
    print("INVOICE ITEM  INVOICE ID : ${invoiceID}");


    late Stock stock;
    late GRN grn;

    for(var row in results.rows){
      // PRODUCT
      String id = row.colByName(Product.COLNAME_ID)?? "0";
      String barcode = row.colByName(Product.COLNAME_BARCODE)?? "0";
      String name = row.colByName(Product.COLNAME_NAME)as String;
      String siName = row.colByName(Product.COLNAME_SI_NAME)as String;
      String description = row.colByName(Product.COLNAME_DESCRIPTION)as String;

      int mainCategoryId = int.parse(row.colByName(MainCategory.COLNAME_ID)!);
      int subCategoryId = int.parse(row.colByName(SubCategory.COLNAME_ID)!);
      int unitId = int.parse(row.colByName(Unit.COLNAME_ID)!);

      MainCategory mainCategory = MainCategory(id: mainCategoryId,name: row.colByName(MainCategory.COLNAME_NAME)!);
      SubCategory subCategory = SubCategory(id: subCategoryId,name: row.colByName(SubCategory.COLNAME_NAME)!);
      Unit unit = Unit(id: unitId,name: row.colByName(Unit.COLNAME_NAME)!);

      Product product = Product(id: int.parse(id),barcode: barcode,name: name,siName: siName,description: description,mainCategory: mainCategory,subCategory: subCategory,unit: unit);

      GRN grn = GRN(
        id:int.parse(row.colByName(GRN.COLNAME_ID) as String),
        barcode: row.colByName(GRN.COLNAME_BARCODE)as String,
        grnDate: DateTime.parse(row.colByName(GRN.COLNAME_GRN_DATE)as String),
        quantity: int.parse(row.colByName(GRN.COLNAME_QUANTITY)as String),
        description: row.colByName(GRN.COLNAME_DESCRIPTION)as String,
        mnfDate: DateTime.parse(row.colByName(GRN.COLNAME_MNF_DATE)as String),
        expDate: DateTime.parse(row.colByName(GRN.COLNAME_EXP_DATE)as String),
        wholesalePrice: double.parse(row.colByName(GRN.COLNAME_WHOLESALE_PRICE)as String),
        retailPrice: double.parse(row.colByName(GRN.COLNAME_RETAIL_PRICE)as  String),
        value: double.parse(row.colByName(GRN.COLNAME_VALUE)as  String),
        paidAmount: double.parse(row.colByName(GRN.COLNAME_PAID_AMOUNT)as String),
        douedAmount: double.parse(row.colByName(GRN.COLNAME_DOUED_AMOUNT)as String),
        product: Product(
          id: int.parse(row.colByName(Product.COLNAME_ID)as String),
          barcode: row.colByName(Product.COLNAME_BARCODE)as String,
          name: row.colByName(Product.COLNAME_NAME)as String,
          siName: row.colByName(Product.COLNAME_SI_NAME)as String,
          description: row.colByName(Product.COLNAME_DESCRIPTION)as String,
          mainCategory: MainCategory(
            id: int.parse(row.colByName(MainCategory.COLNAME_ID)as String),
            name: row.colByName(MainCategory.COLNAME_NAME)as String,
          ),
          subCategory: SubCategory(
            id: int.parse(row.colByName(SubCategory.COLNAME_ID)as  String),
            name: row.colByName(SubCategory.COLNAME_NAME)as String,
          ),
          unit: Unit(
            id: int.parse(row.colByName(Unit.COLNAME_ID)as String),
            name: row.colByName(Unit.COLNAME_NAME)as String,

          ),
        ),
        supplier: Supplier(
          id:  int.parse(row.colByName(Supplier.COLNAME_ID)as String),
          name: row.colByName(Supplier.COLNAME_NAME)as String,
          contact: row.colByName(Supplier.COLNAME_CONTACT)as String,
          bankDetails: row.colByName(Supplier.COLNAME_BANK_DETAILS)as String,
          email: row.colByName(Supplier.COLNAME_EMAIL)as String,
        ),
      );
      Stock stock = Stock(
          id: int.parse(row.colByName(Stock.COLNAME_ID)??"0"),
          barcode: row.colByName(Stock.COLNAME_BARCODE) as String,
          availbleQty: int.parse(row.colByName(Stock.COLNAME_AVAILBLE_QTY)?? "0"),
          defaultDiscount: double.parse(row.colByName(Stock.COLNAME_DEFAULT_DISCOUNT)?? "0"),
          retailPrice: double.parse(row.colByName(Stock.COLNAME_RETAIL_PRICE)?? "0"),
          wholesalePrice: double.parse(row.colByName(Stock.COLNAME_WHOLESALE_PRICE)?? "0"),
          mnf_date: DateTime.parse(row.colByName(Stock.COLNAME_MNF_DATE) as String),
          exp_date:  DateTime.parse(row.colByName(Stock.COLNAME_EXP_DATE) as String),
          product: product,
          grn: grn);



      InvoiceItem invoiceItem = InvoiceItem(
        invoiceID: int.parse(row.colByName(COLNAME_INVOICE_ID) as String),
        quantity: int.parse(row.colByName(COLNAME_QUANTITY) as String),
        unitPrice: double.parse(row.colByName(COLNAME_UNIT_PRICE) as String),
        product: product,
        stock: stock,
        discount: double.parse(row.colByName(COLNAME_DISCOUNT) as String),
        grn: grn,
      );

      invoiceItems.add(invoiceItem);

    }
    print("INVOICE ITEM Count  ${invoiceItems.length}");
    return invoiceItems;
  }
}