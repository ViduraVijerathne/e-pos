import '../models/product.dart';
import '../models/stock.dart';

class StockSearchController{
  List<Stock> stock = [];
  StockSearchController({required List<Stock> stock}){
    this.stock.addAll(stock);
  }
  void clear(){
    stock.clear();
  }

  void searchByProductBarcode(String barcode){
    List<Stock> searchStock = [];
    for(Stock st in stock){
      if(st.product.barcode == barcode){
        searchStock.add(st);
      }
    }
    clear();
    stock.addAll(searchStock);
  }
  void searchByStockBarcode(String barcode){
    List<Stock> searchStock = [];
    for(Stock st in stock){
      if(st.barcode == barcode){
        searchStock.add(st);
      }
    }
    clear();
    stock.addAll(searchStock);
  }
  void searchByPriceLessThan(double price){
    List<Stock> searchStock = [];
    for(Stock st in stock){
      if(st.retailPrice < price){
        searchStock.add(st);
      }
    }
    clear();
    stock.addAll(searchStock);
  }
  void searchByPriceGraterThan(double price){
    List<Stock> searchStock = [];
    for(Stock st in stock){
      if(st.retailPrice > price){
        searchStock.add(st);
      }
    }
    clear();
    stock.addAll(searchStock);
  }
  void searchByProduct(Product product){
    List<Stock> searchStock = [];
    for(Stock st in stock){
      if(st.product.id == product.id){
        searchStock.add(st);
      }
    }
    clear();
    stock.addAll(searchStock);
  }
  void searchByStockExpired(){
    List<Stock> searchStock = [];
    for(Stock st in stock){
      if(st.exp_date.isBefore(DateTime.now())){
        searchStock.add(st);
      }
    }
    clear();
    stock.addAll(searchStock);
  }
  void searchByStockExpiredDateFrom(DateTime expDate){
    List<Stock> searchStock = [];
    for(Stock st in stock){
      if(st.exp_date.isAfter(expDate)){
        searchStock.add(st);
      }
    }
    clear();
    stock.addAll(searchStock);
  }
  void searchByStockExpiredDateTo(DateTime expDate){
    List<Stock> searchStock = [];
    for(Stock st in stock){
      if(st.exp_date.isBefore(expDate)){
        searchStock.add(st);
      }
    }
    clear();
    stock.addAll(searchStock);
  }
  List<Stock> getStock(){
    return stock;
  }

}