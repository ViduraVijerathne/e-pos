import 'package:mysql_client/mysql_client.dart';
import 'package:point_of_sale/utils/app_data.dart';

class MainCategory{
  final int id;
  final String name;
  MainCategory({required this.id,required this.name});

  static const String COLNAME_ID = "main_cat_id";
  static const String COLNAME_NAME = "main_cat";
  static const String TABLE_NAME = "main_category";
  static const String INSERTQUERY = "INSERT INTO main_category (main_cat) VALUES (?)";

  Future<void>insert() async {

    final conn = await MySQLConnection.createConnection(
      host: AppData.dbURL,
      port: AppData.dbPORT,
      userName: AppData.dbUser,
      password: AppData.dbPassword,
      databaseName: AppData.dbName, // optional
    );

// actually connect to database
    await conn.connect();
    var stmt = await conn.prepare(INSERTQUERY);
    await stmt.execute([name]);
    await conn.close();

  }

  static Future<List<MainCategory>> getAll() async{
    List<MainCategory> mainCategories = [];
    final conn = await MySQLConnection.createConnection(
      host: AppData.dbURL,
      port: AppData.dbPORT,
      userName: AppData.dbUser,
      password: AppData.dbPassword,
      databaseName: AppData.dbName, // optional
    );
    await conn.connect();
    var results = await conn.execute("SELECT * FROM $TABLE_NAME");
    for (var row in results.rows) {
      String id = row.colByName(COLNAME_ID)?? "0";
      mainCategories.add(MainCategory(id: int.parse(id), name: row.colByName(COLNAME_NAME)as String));
    }
    return mainCategories;
  }
}