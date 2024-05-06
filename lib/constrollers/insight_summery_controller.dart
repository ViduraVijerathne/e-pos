import 'package:point_of_sale/models/grn.dart';
import 'package:point_of_sale/models/stock.dart';
import 'package:point_of_sale/utils/database.dart';

import '../models/main_category.dart';
import '../models/product.dart';
import '../models/sub_category.dart';
import '../models/supplier.dart';
import '../models/unit.dart';

class InsightSummery{

  Future<int> getTotalProductCount()async{
    int totalProduct = 0;
    var pool = MySQLDatabase().pool;
    var results = await pool.execute("SELECT COUNT(*) as total FROM product");
    for(var row in results.rows){
      totalProduct = int.parse(row.colByName('total') as String);
    }
    return totalProduct;
  }

  Future<double> getTotalSales()async{
    double totalSales = 0;
    // Get the current date
    DateTime now = DateTime.now();

    // Set the start of the day (00:00:00)
    DateTime startTime = DateTime(now.year, now.month, now.day, 0, 0, 0);

    // Set the end of the day (23:59:59)
    DateTime endTime = DateTime(now.year, now.month, now.day, 23, 59, 59);
    String  query = "SELECT SUM(invoice.invoice_total) AS sales  FROM invoice WHERE  invoice.invoice_date > :startTime  AND invoice.invoice_date < :endTime";
    var pool = MySQLDatabase().pool;
    var results  =await pool.execute(query,{
      "startTime": startTime.toIso8601String(),
      "endTime":endTime.toIso8601String()
    });

    for(var row in results.rows){
      totalSales = double.parse(row.colByName('sales')??'0');
    }


    return totalSales;
  }

  Future<double> getTotalRevenue()async{
    double totalRevenue = 0;
// Get the current date
    DateTime now = DateTime.now();

    // Set the start of the day (00:00:00)
    DateTime startTime = DateTime(now.year, now.month, now.day, 0, 0, 0);

    // Set the end of the day (23:59:59)
    DateTime endTime = DateTime(now.year, now.month, now.day, 23, 59, 59);
    String query = "SELECT  SUM((invoice_has_stock.invoice_unit_price - stock.wholesale_price - invoice_has_stock.discount) * invoice_has_stock.invoice_qty) as profit FROM invoice INNER JOIN invoice_has_stock ON invoice_has_stock.invoice_invoice_id = invoice.invoice_id INNER JOIN stock ON stock.id = invoice_has_stock.stock_id  WHERE  invoice.invoice_date > :startTime  AND invoice.invoice_date < :endTime ";
    var pool = MySQLDatabase().pool;
    var results  =await pool.execute(query,{
      "startTime": startTime.toIso8601String(),
      "endTime":endTime.toIso8601String()
    });

    for(var row in results.rows){
      totalRevenue = double.parse(row.colByName('profit')??'0');

    }
    return totalRevenue;
  }

  Future<int> getInvoiceCount()async{
    int invoiceCount = 0;
    double totalRevenue = 0;
// Get the current date
    DateTime now = DateTime.now();

    // Set the start of the day (00:00:00)
    DateTime startTime = DateTime(now.year, now.month, now.day, 0, 0, 0);

    // Set the end of the day (23:59:59)
    DateTime endTime = DateTime(now.year, now.month, now.day, 23, 59, 59);

    String query = "SELECT COUNT(invoice.invoice_id) FROM invoice WHERE  invoice.invoice_date > :startTime  AND invoice.invoice_date < :endTime";
    var pool = MySQLDatabase().pool;
    var results  =await pool.execute(query,{
      "startTime": startTime.toIso8601String(),
      "endTime":endTime.toIso8601String()
    });

    for(var row in results.rows){
      invoiceCount = int.parse(row.colByName('COUNT(invoice.invoice_id)')??'0');
    }


    return invoiceCount;
  }

  Future<List<GRN>> getPaymentDueGRNs()async{
    List<GRN> grns = [];
    String query = "SELECT * FROM grn INNER JOIN product ON product.product_id = grn.product_product_id INNER JOIN suppliers ON suppliers.supplier_id = grn.suppliers_supplier_id INNER JOIN main_category ON main_category.main_cat_id = product.main_category_main_cat_id INNER JOIN sub_category ON sub_category.sub_cat_id = product.sub_category_sub_cat_id INNER JOIN units ON units.unit_id = product.units_unit_id WHERE grn.doue_amount !=0";
    var pool = MySQLDatabase().pool;
    var results = await pool.execute(query);
    for (var row in results.rows) {
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
      grns.add(grn);
    }
    return grns;
  }

  Future<List<Stock>> getLowStocks()async{
    List<Stock> stocks = [];

    var pool = MySQLDatabase().pool;
    var result =await pool.execute("SELECT * FROM stock  WHERE stock.availble_qty < 10 AND (stock.exp_date > NOW() OR stock.mnf_date = stock.exp_date )");

    for(var row in result.rows){

      GRN grn =await GRN.getByID(row.colByName(Stock.COLNAME_GRN)??"0");
      Product product = await Product.getByID(row.colByName(GRN.COLNAME_PRODUCT)??"0");

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

      stocks.add(stock);
    }

    return stocks;
  }

  Future<List<Stock>> getExpiredStocks()async{
    List<Stock> stocks = [];

    var pool = MySQLDatabase().pool;
    var result =await pool.execute("SELECT * FROM stock  WHERE stock.availble_qty > 0 AND (stock.exp_date <= NOW() AND  stock.mnf_date != stock.exp_date )");

    for(var row in result.rows){

      GRN grn =await GRN.getByID(row.colByName(Stock.COLNAME_GRN)??"0");
      Product product = await Product.getByID(row.colByName(GRN.COLNAME_PRODUCT)??"0");

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

      stocks.add(stock);
    }

    return stocks;
  }


}