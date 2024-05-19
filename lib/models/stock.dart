import 'package:mysql_client/mysql_client.dart';
import 'package:point_of_sale/models/grn.dart';
import 'package:point_of_sale/models/product.dart';

import '../utils/app_data.dart';
import '../utils/database.dart';

class Stock{

  final int id;
  final String barcode;
   int availbleQty;
  final double retailPrice;
  final double wholesalePrice;
  final DateTime mnf_date;
  final DateTime exp_date;
  final Product product;
   double defaultDiscount;
  final GRN grn;


  Stock({required this.id,required this.barcode,required this.availbleQty,required this.defaultDiscount,required this.retailPrice,required this.wholesalePrice,required this.mnf_date,
  required this.exp_date,required this.product,required this.grn});


  static const String COLNAME_ID = "id";
  static const String COLNAME_BARCODE = "barcode";
  static const String COLNAME_AVAILBLE_QTY = "availble_qty";
  static const String COLNAME_RETAIL_PRICE = "retail_price";
  static const String COLNAME_WHOLESALE_PRICE = "wholesale_price";
  static const String COLNAME_MNF_DATE = "mnf_date";
  static const String COLNAME_EXP_DATE = "exp_date";
  static const String COLNAME_PRODUCT = "product_product_id";
  static const String COLNAME_GRN = "grn_grn_id";
  static const String COLNAME_DEFAULT_DISCOUNT = "default_discount";
  static const String TABLE_NAME = "stock";
  static const String INSERTQUERY = "INSERT INTO `stock` (`barcode`, `availble_qty`, `retail_price`, `wholesale_price`, `mnf_date`, `exp_date`, `product_product_id`, `grn_grn_id`, `default_discount`) VALUES (?,?,?,?,?,?,?,?,?)";
  static const String SELECTQUERY = "SELECT * FROM `stock`";
  static const String UPDATEDEFAULTDISCOUNTQUARY = "UPDATE `stock` SET `default_discount`=:discount WHERE  `grn_grn_id`=:GRNID";
  static const String SUBQTYQUARY  = "UPDATE `stock` SET `availble_qty`=`availble_qty`- :QTY WHERE  `id`=:ID ";
  static const String GETSTOCKBYID = "SELECT * FROM `stock` WHERE  id = :ID";

  Future<void> insert() async{
    final conn = await MySQLConnection.createConnection(
      host: AppData.dbURL,
      port: AppData.dbPORT,
      userName: AppData.dbUser,
      password: AppData.dbPassword,
      databaseName: AppData.dbName, // optional
    );

    await conn.connect();
    var stmt = await conn.prepare(INSERTQUERY);
    IResultSet result = await stmt.execute([barcode,availbleQty,retailPrice,wholesalePrice,mnf_date,exp_date,product.id,grn.id,defaultDiscount]);
    print("STOCK ID : ${result.lastInsertID} : ${result.lastInsertID.toInt()}");
    await conn.close();
  }
  static Future<List<Stock>> getAll()async{
    List<Stock> stocks = [];
    final conn = await MySQLConnection.createConnection(
      host: AppData.dbURL,
      port: AppData.dbPORT,
      userName: AppData.dbUser,
      password: AppData.dbPassword,
      databaseName: AppData.dbName, // optional
    );

    await conn.connect();
    var results = await conn.execute(SELECTQUERY);

    for (var row in results.rows) {
      GRN grn =await GRN.getByID(row.colByName(COLNAME_GRN)??"0");
      Product product = await Product.getByID(row.colByName(COLNAME_PRODUCT)??"0");

      Stock stock = Stock(
          id: int.parse(row.colByName(COLNAME_ID)??"0"),
          barcode: row.colByName(COLNAME_BARCODE) as String,
          availbleQty: int.parse(row.colByName(COLNAME_AVAILBLE_QTY)?? "0"),
          defaultDiscount: double.parse(row.colByName(COLNAME_DEFAULT_DISCOUNT)?? "0"),
          retailPrice: double.parse(row.colByName(COLNAME_RETAIL_PRICE)?? "0"),
          wholesalePrice: double.parse(row.colByName(COLNAME_WHOLESALE_PRICE)?? "0"),
          mnf_date: DateTime.parse(row.colByName(COLNAME_MNF_DATE) as String),
          exp_date:  DateTime.parse(row.colByName(COLNAME_EXP_DATE) as String),
          product: product,
          grn: grn);

      stocks.add(stock);
    }

    return stocks;
  }
  static Future<List<Stock>> getForSell({int limit = 6})async{
    List<Stock> stocks = [];
    final conn = MySQLDatabase().pool;
    var results = await conn.execute("$SELECTQUERY WHERE stock.exp_date >= CURDATE() AND  stock.availble_qty > 0 LIMIT $limit");

    for (var row in results.rows) {
      GRN grn =await GRN.getByID(row.colByName(COLNAME_GRN)??"0");
      Product product = await Product.getByID(row.colByName(COLNAME_PRODUCT)??"0");

      Stock stock = Stock(
          id: int.parse(row.colByName(COLNAME_ID)??"0"),
          barcode: row.colByName(COLNAME_BARCODE) as String,
          availbleQty: int.parse(row.colByName(COLNAME_AVAILBLE_QTY)?? "0"),
          defaultDiscount: double.parse(row.colByName(COLNAME_DEFAULT_DISCOUNT)?? "0"),
          retailPrice: double.parse(row.colByName(COLNAME_RETAIL_PRICE)?? "0"),
          wholesalePrice: double.parse(row.colByName(COLNAME_WHOLESALE_PRICE)?? "0"),
          mnf_date: DateTime.parse(row.colByName(COLNAME_MNF_DATE) as String),
          exp_date:  DateTime.parse(row.colByName(COLNAME_EXP_DATE) as String),
          product: product,
          grn: grn);

      stocks.add(stock);
    }

    return stocks;
  }

  Future<void> updateDefaultDiscount()async{
    final conn = await MySQLConnection.createConnection(
      host: AppData.dbURL,
      port: AppData.dbPORT,
      userName: AppData.dbUser,
      password: AppData.dbPassword,
      databaseName: AppData.dbName, // optional
    );

    await conn.connect();
    await conn.execute(UPDATEDEFAULTDISCOUNTQUARY, {"discount":defaultDiscount,"GRNID":grn.id});
    conn.close();
  }
  Future<void> subQty(int qty)async{
    availbleQty = availbleQty - qty;
    final conn = await MySQLConnection.createConnection(
      host: AppData.dbURL,
      port: AppData.dbPORT,
      userName: AppData.dbUser,
      password: AppData.dbPassword,
      databaseName: AppData.dbName, // optional
    );
    await conn.connect();
    await conn.execute(SUBQTYQUARY, {"QTY":qty,"ID":grn.id});
    conn.close();


  }
  static Future<Stock> getByID(String ID)async{
    List<Stock> stocks = [];
    final conn = MySQLDatabase().pool;

    var results = await conn.execute(GETSTOCKBYID,{"ID":ID});

    for (var row in results.rows) {
      GRN grn =await GRN.getByID(row.colByName(COLNAME_GRN)??"0");
      Product product = await Product.getByID(row.colByName(COLNAME_PRODUCT)??"0");

      Stock stock = Stock(
          id: int.parse(row.colByName(COLNAME_ID)??"0"),
          barcode: row.colByName(COLNAME_BARCODE) as String,
          availbleQty: int.parse(row.colByName(COLNAME_AVAILBLE_QTY)?? "0"),
          defaultDiscount: double.parse(row.colByName(COLNAME_DEFAULT_DISCOUNT)?? "0"),
          retailPrice: double.parse(row.colByName(COLNAME_RETAIL_PRICE)?? "0"),
          wholesalePrice: double.parse(row.colByName(COLNAME_WHOLESALE_PRICE)?? "0"),
          mnf_date: DateTime.parse(row.colByName(COLNAME_MNF_DATE) as String),
          exp_date:  DateTime.parse(row.colByName(COLNAME_EXP_DATE) as String),
          product: product,
          grn: grn);

      stocks.add(stock);
  }
    conn.close();
    print("STOCK ID : ${stocks[0].id}");
    return stocks[0];
  }

  Future<void> deactivate()async{
    final conn = MySQLDatabase().pool;
    String query = "UPDATE `stock` SET `isActive`= 0 WHERE  `id`=$id";
    await conn.execute(query);
    conn.close();

  }

 static Future<List<Stock>>  searchByBarcode({required String value , limit = 6 })async{
     List<Stock> stocks =[];
     String query = "SELECT * FROM `stock` WHERE stock.barcode LIKE '$value%' LIMIT $limit";
     print(query);
     var pool = MySQLDatabase().pool;
     var results = await pool.execute(query);
     for (var row in results.rows) {
       GRN grn =await GRN.getByID(row.colByName(COLNAME_GRN)??"0");
       Product product = await Product.getByID(row.colByName(COLNAME_PRODUCT)??"0");

       Stock stock = Stock(
           id: int.parse(row.colByName(COLNAME_ID)??"0"),
           barcode: row.colByName(COLNAME_BARCODE) as String,
           availbleQty: int.parse(row.colByName(COLNAME_AVAILBLE_QTY)?? "0"),
           defaultDiscount: double.parse(row.colByName(COLNAME_DEFAULT_DISCOUNT)?? "0"),
           retailPrice: double.parse(row.colByName(COLNAME_RETAIL_PRICE)?? "0"),
           wholesalePrice: double.parse(row.colByName(COLNAME_WHOLESALE_PRICE)?? "0"),
           mnf_date: DateTime.parse(row.colByName(COLNAME_MNF_DATE) as String),
           exp_date:  DateTime.parse(row.colByName(COLNAME_EXP_DATE) as String),
           product: product,
           grn: grn);

       stocks.add(stock);
     }
    return stocks;
  }
  static Future<List<Stock>>  searchByName({required String value , limit = 6 })async{
    List<Stock> stocks =[];
    String query = "SELECT * FROM `stock` INNER JOIN product ON product.product_id = stock.product_product_id WHERE product.product_name  LIKE '$value%' OR product.product_si_name LIKE '$value%' LIMIT $limit";
    print(query);
    var pool = MySQLDatabase().pool;
    var results = await pool.execute(query);
    for (var row in results.rows) {
      GRN grn =await GRN.getByID(row.colByName(COLNAME_GRN)??"0");
      Product product = await Product.getByID(row.colByName(COLNAME_PRODUCT)??"0");
      Stock stock = Stock(
          id: int.parse(row.colByName(COLNAME_ID)??"0"),
          barcode: row.colByName(COLNAME_BARCODE) as String,
          availbleQty: int.parse(row.colByName(COLNAME_AVAILBLE_QTY)?? "0"),
          defaultDiscount: double.parse(row.colByName(COLNAME_DEFAULT_DISCOUNT)?? "0"),
          retailPrice: double.parse(row.colByName(COLNAME_RETAIL_PRICE)?? "0"),
          wholesalePrice: double.parse(row.colByName(COLNAME_WHOLESALE_PRICE)?? "0"),
          mnf_date: DateTime.parse(row.colByName(COLNAME_MNF_DATE) as String),
          exp_date:  DateTime.parse(row.colByName(COLNAME_EXP_DATE) as String),
          product: product,
          grn: grn);
      stocks.add(stock);
    }
    return stocks;
  }

}