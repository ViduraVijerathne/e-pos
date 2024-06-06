import 'dart:math';

import 'package:point_of_sale/models/product.dart';
import 'package:point_of_sale/models/stock.dart';

class BarcodeGenerator{
  static Future<String> generateRandomProductBarcode()async{

    String result = "";

    bool p  = true;

    while (p){
       result = _generateBarcode();
      p = await Product.barcodeExists(result);
      print(p);
    }
    print(result);
    return result;



  }

  static String _generateBarcode(){
    Random random = Random();
    String characters = '0123456789';
    String result = '';
    for (int i = 0; i < 12; i++) {
      result += characters[random.nextInt(characters.length)];
    }


    return result;
  }

  static String generateRandomGRNBarcode() {
    Random random = Random();
    String characters = '0123456789';
    String result = '';
    for (int i = 0; i < 13; i++) {
      result += characters[random.nextInt(characters.length)];
    }
    return result;
  }

  static Future<String> generateRandomStockBarcode() async{
    String result = "";

    bool p  = true;

    while (p){
      result = _generateBarcode();
      p = await Stock.barcodeExists(result);
      print(p);
    }
    print(result);
    return result;


  }

  static String generateRandomInvoiceBarcode(){
    Random random = Random();
    String characters = '0123456789';
    String result = '';
    for (int i = 0; i < 15; i++) {
      result += characters[random.nextInt(characters.length)];
    }
    return result;
  }

}