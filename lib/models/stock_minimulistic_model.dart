import 'package:point_of_sale/models/stock.dart';

import '../utils/database.dart';

class StockMin{
  final int id;
  final String barcode;
  final double qty;
  final double wholesalePrice;
  final double retailPrice;
  final DateTime mnf_date;
  final DateTime exp_date;
  final double discount;
  final int grn_id;
  final int product_id;
  
  StockMin(
       {required this.id,required this.barcode,required this.qty,
       required this.wholesalePrice, required this.retailPrice, required this.mnf_date, required this.exp_date, required this.discount, required this.grn_id, required this.product_id,       });
  
  
  static Future<List<StockMin>> getAllByProductID(int productID)async {
    List<StockMin> stockMins = [];
    final conn = MySQLDatabase().pool;
    final result = await conn.execute("${Stock.SELECTQUERY} WHERE ${Stock.COLNAME_PRODUCT} = '$productID' AND isActive = 1 ");
    for(var row in result.rows){
      StockMin stockMin = StockMin(
        id: int.parse(row.colByName(Stock.COLNAME_ID)!),
        barcode: row.colByName(Stock.COLNAME_BARCODE)!,
        qty: double.parse(row.colByName(Stock.COLNAME_AVAILBLE_QTY)!),
        wholesalePrice: double.parse(row.colByName(Stock.COLNAME_WHOLESALE_PRICE)!),
        retailPrice: double.parse(row.colByName(Stock.COLNAME_RETAIL_PRICE)!),
        mnf_date: DateTime.parse(row.colByName(Stock.COLNAME_MNF_DATE)!),
        exp_date: DateTime.parse(row.colByName(Stock.COLNAME_EXP_DATE)!),
        discount: double.parse(row.colByName(Stock.COLNAME_DEFAULT_DISCOUNT)!),
        grn_id: int.parse(row.colByName(Stock.COLNAME_GRN)!),
        product_id: int.parse(row.colByName(Stock.COLNAME_PRODUCT)!),
      );
      stockMins.add(stockMin);
    }
    return stockMins;
  }
}