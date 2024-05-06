import 'dart:math';

class BarcodeGenerator{
  static String generateRandomProductBarcode() {
    Random random = Random();
    String characters = '0123456789';
    String result = '';
    for (int i = 0; i < 15; i++) {
      result += characters[random.nextInt(characters.length)];
    }
    return result;
  }

  static String generateRandomGRNBarcode() {
    Random random = Random();
    String characters = '0123456789';
    String result = '';
    for (int i = 0; i < 15; i++) {
      result += characters[random.nextInt(characters.length)];
    }
    return result;
  }

  static String generateRandomStockBarcode() {
    Random random = Random();
    String characters = '0123456789';
    String result = '';
    for (int i = 0; i < 15; i++) {
      result += characters[random.nextInt(characters.length)];
    }
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