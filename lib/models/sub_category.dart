import 'package:mysql_client/mysql_client.dart';

import '../utils/app_data.dart';

class SubCategory{
  final int id;
  final String name;
  SubCategory({required this.id,required this.name});

  static const String COLNAME_ID = "sub_cat_id";
  static const String COLNAME_NAME = "sub_cat";
  static const String TABLE_NAME = "sub_category";
  static const String INSERTQUERY = "INSERT INTO sub_category (sub_cat) VALUES (?)";

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

  static Future<List<SubCategory>>getAll() async {
    List<SubCategory> subCategories = [];

    final conn = await MySQLConnection.createConnection(
      host: AppData.dbURL,
      port: AppData.dbPORT,
      userName: AppData.dbUser,
      password: AppData.dbPassword,
      databaseName: AppData.dbName, // optional
    );
    await conn.connect();
    var results = await conn.execute("SELECT * FROM sub_category");


    for (var row in results.rows) {
      subCategories.add(SubCategory(id: int.parse(row.colByName(COLNAME_ID)!), name: row.colByName(COLNAME_NAME)!));
    }
    await conn.close();
    return subCategories;
  }
}