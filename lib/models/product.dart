import 'package:mysql_client/mysql_client.dart';
import 'package:point_of_sale/models/main_category.dart';
import 'package:point_of_sale/models/sub_category.dart';
import 'package:point_of_sale/models/unit.dart';

import '../utils/app_data.dart';
import '../utils/database.dart';

class Product{
  final int id;
  final String barcode;
  final String name;
  final String siName;
  final String description;
  final MainCategory mainCategory;
  final SubCategory subCategory;
  final Unit unit;


  Product({required this.id,required this.barcode,required this.name,required this.siName,required this.description,required this.mainCategory,required this.subCategory,required this.unit});


  static const String COLNAME_ID = "product_id";
  static const String COLNAME_BARCODE = "barcode";
  static const String COLNAME_NAME = "product_name";
  static const String COLNAME_SI_NAME = "product_si_name";
  static const String COLNAME_DESCRIPTION = "description";
  static const String COLNAME_MAIN_CAT = "main_category_main_cat_id";
  static const String COLNAME_SUB_CAT = "sub_category_sub_cat_id";
  static const String COLNAME_UNIT = "units_unit_id";
  static const String TABLE_NAME = "product";
  static const String INSERTQUERY = "INSERT INTO `product` (`barcode`, `product_name`, `product_si_name`, `description`, `main_category_main_cat_id`, `sub_category_sub_cat_id`, `units_unit_id`) VALUES (?,?,?,?,?,?,?)";
  static const String SELECTQUERY = "SELECT * FROM $TABLE_NAME "
      "INNER JOIN ${MainCategory.TABLE_NAME} ON ${MainCategory.TABLE_NAME}.${MainCategory.COLNAME_ID} = $TABLE_NAME.$COLNAME_MAIN_CAT "
      "INNER JOIN ${SubCategory.TABLE_NAME} ON ${SubCategory.TABLE_NAME}.${SubCategory.COLNAME_ID} = $TABLE_NAME.$COLNAME_SUB_CAT "
      "INNER JOIN ${Unit.TABLE_NAME} ON ${Unit.TABLE_NAME}.${Unit.COLNAME_ID} = $TABLE_NAME.$COLNAME_UNIT";

  static const String SELECTBYIDQUERY = "SELECT * FROM $TABLE_NAME "
      "INNER JOIN ${MainCategory.TABLE_NAME} ON ${MainCategory.TABLE_NAME}.${MainCategory.COLNAME_ID} = $TABLE_NAME.$COLNAME_MAIN_CAT "
      "INNER JOIN ${SubCategory.TABLE_NAME} ON ${SubCategory.TABLE_NAME}.${SubCategory.COLNAME_ID} = $TABLE_NAME.$COLNAME_SUB_CAT "
      "INNER JOIN ${Unit.TABLE_NAME} ON ${Unit.TABLE_NAME}.${Unit.COLNAME_ID} = $TABLE_NAME.$COLNAME_UNIT where $TABLE_NAME.$COLNAME_ID = :productID";

  static const String UPDATEQUERY = "UPDATE $TABLE_NAME SET $COLNAME_BARCODE =?, $COLNAME_NAME=?, $COLNAME_SI_NAME=?, $COLNAME_DESCRIPTION=?, $COLNAME_MAIN_CAT=?, $COLNAME_SUB_CAT=?, $COLNAME_UNIT=? WHERE  $COLNAME_ID=? ";

  Future<void >insert()async {
    String q= "INSERT INTO `product` (`barcode`, `product_name`, `product_si_name`, `description`, `main_category_main_cat_id`, `sub_category_sub_cat_id`, `units_unit_id`) VALUES (${barcode},${name},${siName},${description},${mainCategory.id},${subCategory.id},${unit.id})";
    print(q);
    final conn = MySQLDatabase().pool;
    var stmt = await conn.prepare(INSERTQUERY);
    await stmt.execute([barcode,name,siName,description,mainCategory.id,subCategory.id,unit.id]);
    await conn.close();
  }

  static Future<List<Product>> getAll() async {
    List<Product> products = [];
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
      String id = row.colByName(COLNAME_ID)?? "0";
      String barcode = row.colByName(COLNAME_BARCODE)?? "0";
      String name = row.colByName(COLNAME_NAME)as String;
      String siName = row.colByName(COLNAME_SI_NAME)as String;
      String description = row.colByName(COLNAME_DESCRIPTION)as String;

      int mainCategoryId = int.parse(row.colByName(MainCategory.COLNAME_ID)!);
      int subCategoryId = int.parse(row.colByName(SubCategory.COLNAME_ID)!);
      int unitId = int.parse(row.colByName(Unit.COLNAME_ID)!);

      MainCategory mainCategory = MainCategory(id: mainCategoryId,name: row.colByName(MainCategory.COLNAME_NAME)!);
      SubCategory subCategory = SubCategory(id: subCategoryId,name: row.colByName(SubCategory.COLNAME_NAME)!);
      Unit unit = Unit(id: unitId,name: row.colByName(Unit.COLNAME_NAME)!);

      products.add(Product(id: int.parse(id),barcode: barcode,name: name,siName: siName,description: description,mainCategory: mainCategory,subCategory: subCategory,unit: unit));
    }
    await conn.close();
    return products;
  }
  static Future<List<Product>> getAllWithLimit({int limit = 10}) async {
    List<Product> products = [];
    final conn = MySQLDatabase().pool;
    var results = await conn.execute("$SELECTQUERY LIMIT $limit");
    for (var row in results.rows) {
      String id = row.colByName(COLNAME_ID)?? "0";
      String barcode = row.colByName(COLNAME_BARCODE)?? "0";
      String name = row.colByName(COLNAME_NAME)as String;
      String siName = row.colByName(COLNAME_SI_NAME)as String;
      String description = row.colByName(COLNAME_DESCRIPTION)as String;

      int mainCategoryId = int.parse(row.colByName(MainCategory.COLNAME_ID)!);
      int subCategoryId = int.parse(row.colByName(SubCategory.COLNAME_ID)!);
      int unitId = int.parse(row.colByName(Unit.COLNAME_ID)!);

      MainCategory mainCategory = MainCategory(id: mainCategoryId,name: row.colByName(MainCategory.COLNAME_NAME)!);
      SubCategory subCategory = SubCategory(id: subCategoryId,name: row.colByName(SubCategory.COLNAME_NAME)!);
      Unit unit = Unit(id: unitId,name: row.colByName(Unit.COLNAME_NAME)!);

      products.add(Product(id: int.parse(id),barcode: barcode,name: name,siName: siName,description: description,mainCategory: mainCategory,subCategory: subCategory,unit: unit));
    }
    await conn.close();
    return products;
  }

  Future<void > update()async{
    final conn = await MySQLConnection.createConnection(
      host: AppData.dbURL,
      port: AppData.dbPORT,
      userName: AppData.dbUser,
      password: AppData.dbPassword,
      databaseName: AppData.dbName, // optional
    );



    await conn.connect();
    var stmt = await conn.prepare(UPDATEQUERY);
    print(UPDATEQUERY);
    await stmt.execute([barcode,name,siName,description,mainCategory.id,subCategory.id,unit.id,id]);
    await conn.close();
  }

  static Future<Product> getByID(String ID)async{
    List<Product> products = [];
    final conn =MySQLDatabase().pool;


    var results=  await conn.execute(SELECTBYIDQUERY,{"productID":ID});
    for (var row in results.rows) {
      String id = row.colByName(COLNAME_ID)?? "0";
      String barcode = row.colByName(COLNAME_BARCODE)?? "0";
      String name = row.colByName(COLNAME_NAME)as String;
      String siName = row.colByName(COLNAME_SI_NAME)as String;
      String description = row.colByName(COLNAME_DESCRIPTION)as String;

      int mainCategoryId = int.parse(row.colByName(MainCategory.COLNAME_ID)!);
      int subCategoryId = int.parse(row.colByName(SubCategory.COLNAME_ID)!);
      int unitId = int.parse(row.colByName(Unit.COLNAME_ID)!);

      MainCategory mainCategory = MainCategory(id: mainCategoryId,name: row.colByName(MainCategory.COLNAME_NAME)!);
      SubCategory subCategory = SubCategory(id: subCategoryId,name: row.colByName(SubCategory.COLNAME_NAME)!);
      Unit unit = Unit(id: unitId,name: row.colByName(Unit.COLNAME_NAME)!);

      products.add(Product(id: int.parse(id),barcode: barcode,name: name,siName: siName,description: description,mainCategory: mainCategory,subCategory: subCategory,unit: unit));
    }

    return products[0];

  }

  static Future<List<Product>> search(String text) async{
    List<Product> products = [];
    final pool = MySQLDatabase().pool;
    final results = await pool.execute("SELECT * FROM product"
        " INNER JOIN ${MainCategory.TABLE_NAME} ON ${MainCategory.TABLE_NAME}.${MainCategory.COLNAME_ID} = $TABLE_NAME.$COLNAME_MAIN_CAT "
        " INNER JOIN ${SubCategory.TABLE_NAME} ON ${SubCategory.TABLE_NAME}.${SubCategory.COLNAME_ID} = $TABLE_NAME.$COLNAME_SUB_CAT "
        " INNER JOIN ${Unit.TABLE_NAME} ON ${Unit.TABLE_NAME}.${Unit.COLNAME_ID} = $TABLE_NAME.$COLNAME_UNIT "
        " WHERE product.product_id LIKE '%$text%' OR product.barcode  LIKE '%$text%' OR product.product_name LIKE '%$text%' OR product.product_si_name LIKE '%$text%' ");
    for (var row in results.rows) {
      String id = row.colByName(COLNAME_ID)?? "0";
      String barcode = row.colByName(COLNAME_BARCODE)?? "0";
      String name = row.colByName(COLNAME_NAME)as String;
      String siName = row.colByName(COLNAME_SI_NAME)as String;
      String description = row.colByName(COLNAME_DESCRIPTION)as String;

      int mainCategoryId = int.parse(row.colByName(MainCategory.COLNAME_ID)!);
      int subCategoryId = int.parse(row.colByName(SubCategory.COLNAME_ID)!);
      int unitId = int.parse(row.colByName(Unit.COLNAME_ID)!);

      MainCategory mainCategory = MainCategory(id: mainCategoryId,name: row.colByName(MainCategory.COLNAME_NAME)!);
      SubCategory subCategory = SubCategory(id: subCategoryId,name: row.colByName(SubCategory.COLNAME_NAME)!);
      Unit unit = Unit(id: unitId,name: row.colByName(Unit.COLNAME_NAME)!);

      products.add(Product(id: int.parse(id),barcode: barcode,name: name,siName: siName,description: description,mainCategory: mainCategory,subCategory: subCategory,unit: unit));
    }

    return products;
  }
  static Future<bool> barcodeExists(String barcode)async{
    var pool = MySQLDatabase().pool;
    var results = await pool.execute("SELECT * FROM product WHERE barcode = '$barcode' ");
    if(results.rows.isEmpty){
      return false;
    }

    return true;
  }
}
