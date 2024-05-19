import 'package:mysql_client/mysql_client.dart';
import 'package:point_of_sale/utils/database.dart';

import '../utils/app_data.dart';

class Unit{
   int id;
  final String name;
  Unit({required this.id,required this.name});

  static const String COLNAME_ID = "unit_id";
  static const String COLNAME_NAME = "unit";
  static const String TABLE_NAME = "units";
  static const String INSERTQUERY = "INSERT INTO units (unit) VALUES (?)";

  Future<void>insert() async {

    final conn = MySQLDatabase().pool;
    var stmt = await conn.prepare(INSERTQUERY);
    var result = await stmt.execute([name]);
    id = result.lastInsertID.toInt();
    await conn.close();

  }

  static Future<List<Unit>> getAll() async {
    final conn = await MySQLConnection.createConnection(
      host: AppData.dbURL,
      port: AppData.dbPORT,
      userName: AppData.dbUser,
      password: AppData.dbPassword,
      databaseName: AppData.dbName, // optional
    );
    await conn.connect();
    var results = await conn.execute("SELECT * FROM units");
    List<Unit> units = [];
    
    for (var row in results.rows) {
      String id = row.colByName(COLNAME_ID)?? "0";
      print(row.colByName(COLNAME_NAME));
      units.add(Unit(id: int.parse(id), name: row.colByName(COLNAME_NAME)as String));
    }
    await conn.close();
    return units;

}}