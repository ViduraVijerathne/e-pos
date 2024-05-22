import 'package:point_of_sale/models/grn.dart';
import 'package:point_of_sale/utils/database.dart';

import '../models/product.dart';
import '../models/stock.dart';

class StockSearchController{
  List<String> conditions = [];
  void clear(){
    conditions.clear();
  }

  void searchByProductBarcode(String barcode){
   conditions.add("${Product.TABLE_NAME}.${Product.COLNAME_BARCODE} = '$barcode'");
  }

  void searchByStockBarcode(String barcode){
    conditions.add("${Stock.TABLE_NAME}.${Stock.COLNAME_BARCODE} = '$barcode'");
  }
  void searchByPriceLessThan(double price){
    conditions.add("${Stock.COLNAME_RETAIL_PRICE} <= '$price'");
  }
  void searchByPriceGraterThan(double price){
    conditions.add("${Stock.COLNAME_RETAIL_PRICE} >= '$price'");
  }
  void searchByProduct(Product product){
    conditions.add("${Stock.COLNAME_PRODUCT} = '${product.id}'");
  }
  void searchByStockExpired(){
    conditions.add("${Stock.COLNAME_EXP_DATE} < '${DateTime.now().toIso8601String()}'");
  }
  void searchByStockExpiredDateFrom(DateTime expDate){
   conditions.add("${Stock.COLNAME_EXP_DATE} >= '${expDate.toIso8601String()}'");
  }
  void searchByStockExpiredDateTo(DateTime expDate){
    conditions.add("${Stock.COLNAME_EXP_DATE} <= '${expDate.toIso8601String()}'");
  }
  Future<List<Stock>> getStock()async{
    List<Stock> stocks = [];
    if(conditions.isNotEmpty){
      String q = "SELECT * FROM `stock` INNER JOIN product ON product.product_id = stock.id WHERE ${conditions.join(" AND ")}";
      print(q);
      final conn = MySQLDatabase().pool;
      final result =await conn.execute(q);
      for(var row in result.rows){
        GRN grn =await GRN.getByID(row.colByName(Stock.COLNAME_GRN)??"0");
        Product product = await Product.getByID(row.colByName(Stock.COLNAME_PRODUCT)??"0");
        Stock stock = Stock(
            id: int.parse(row.colByName(Stock.COLNAME_ID)??"0"),
            barcode: row.colByName(Stock.COLNAME_BARCODE) as String,
            availbleQty: double.parse(row.colByName(Stock.COLNAME_AVAILBLE_QTY)?? "0"),
            defaultDiscount: double.parse(row.colByName(Stock.COLNAME_DEFAULT_DISCOUNT)?? "0"),
            retailPrice: double.parse(row.colByName(Stock.COLNAME_RETAIL_PRICE)?? "0"),
            wholesalePrice: double.parse(row.colByName(Stock.COLNAME_WHOLESALE_PRICE)?? "0"),
            mnf_date: DateTime.parse(row.colByName(Stock.COLNAME_MNF_DATE) as String),
            exp_date:  DateTime.parse(row.colByName(Stock.COLNAME_EXP_DATE) as String),
            product: product,
            grn: grn);
        stocks.add(stock);
      }

    }


    return stocks;
  }

}