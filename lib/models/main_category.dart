import 'package:mysql_client/mysql_client.dart';
import 'package:point_of_sale/utils/app_data.dart';
import 'package:point_of_sale/utils/database.dart';

class MainCategory{
   int id;
  final String name;
  MainCategory({required this.id,required this.name});

  static const String COLNAME_ID = "main_cat_id";
  static const String COLNAME_NAME = "main_cat";
  static const String TABLE_NAME = "main_category";
  static const String INSERTQUERY = "INSERT INTO main_category (main_cat) VALUES (?)";

  Future<void>insert() async {

    final conn = MySQLDatabase().pool;

// actually connect to database
    var stmt = await conn.prepare(INSERTQUERY);
    var result = await stmt.execute([name]);
     id = result.lastInsertID.toInt();
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