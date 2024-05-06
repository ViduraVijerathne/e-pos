import 'package:mysql_client/mysql_client.dart';
import 'package:point_of_sale/utils/app_data.dart';

class MySQLDatabase {
  // Singleton instance
  static final MySQLDatabase _instance = MySQLDatabase._internal();

  // Connection pool
  late MySQLConnectionPool _pool;

  // Private constructor for singleton pattern
  MySQLDatabase._internal() {
    _pool = MySQLConnectionPool(
      host: AppData.dbURL,
      port: AppData.dbPORT,
      userName: AppData.dbUser,
      password: AppData.dbPassword,
      maxConnections: 10,
      databaseName: AppData.dbName, // optional
    );
  }

  // Factory constructor for accessing the singleton instance
  factory MySQLDatabase() {
    return _instance;
  }

  // Getter for the connection pool
  MySQLConnectionPool get pool => _pool;

  // Method to close all connections
  Future<void> closePool() async {
    await _pool.close();
  }
}
