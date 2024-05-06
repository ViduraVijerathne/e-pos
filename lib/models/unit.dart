import 'package:mysql_client/mysql_client.dart';

import '../utils/app_data.dart';

class Unit{
  final int id;
  final String name;
  Unit({required this.id,required this.name});

  static const String COLNAME_ID = "unit_id";
  static const String COLNAME_NAME = "unit";
  static const String TABLE_NAME = "units";
  static const String INSERTQUERY = "INSERT INTO units (unit) VALUES (?)";

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