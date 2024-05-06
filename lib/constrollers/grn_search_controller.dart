import '../models/grn.dart';
import '../models/product.dart';
import '../models/supplier.dart';

class GRNSearchController{
  List<GRN> grns = [];

  GRNSearchController({required List<GRN> grns}){
    this.grns.addAll(grns);
  }
  void clear(){
    grns.clear();
  }

  void searchByGRNBarcode(String barcode){
    List<GRN> searchGRNs = [];
    for(GRN grn in grns){
      if(grn.barcode == barcode){
        searchGRNs.add(grn);
      }
    }
    grns.clear();
    grns.addAll(searchGRNs);
  }
  void searchByProductBarcode(String barcode){
    List<GRN> searchGRNs = [];
    for(GRN grn in grns){
      if(grn.product.barcode == barcode){
        searchGRNs.add(grn);
      }
    }
    grns.clear();
    grns.addAll(searchGRNs);
  }
  void searchByDueAmountGraterThan(double amount){
    List<GRN> searchGRNs = [];
    for(GRN grn in grns){
      if(grn.douedAmount > amount){
        searchGRNs.add(grn);
      }
    }
    grns.clear();
    grns.addAll(searchGRNs);
  }
  void searchByDueAmountLessThan(double amount){
    List<GRN> searchGRNs = [];
    for(GRN grn in grns){
      if(grn.douedAmount < amount){
        searchGRNs.add(grn);
      }
    }
    grns.clear();
    grns.addAll(searchGRNs);
  }
  void searchByProduct(Product product){
    List<GRN> searchGRNs = [];
    for(GRN grn in grns){
      if(grn.product.id == product.id){
        searchGRNs.add(grn);
      }
    }
    grns.clear();
    grns.addAll(searchGRNs);
  }

  void searchByProductName(String productName){
    List<GRN> searchGRNs = [];
    for(GRN grn in grns){
      if(grn.product.name.contains(productName)){
        searchGRNs.add(grn);
      }
    }
    grns.clear();
    grns.addAll(searchGRNs);
  }
  void searchBySupplier(Supplier supplier){
    List<GRN> searchGRNs = [];
    for(GRN grn in grns){
      if(grn.supplier.id == supplier.id){
        searchGRNs.add(grn);
      }
    }
    grns.clear();
    grns.addAll(searchGRNs);
  }

  List<GRN> getGRNs(){
    return grns;
  }

  void searchBySupplierName(String text) {
    List<GRN> searchGRNs = [];
    for(GRN grn in grns){
      if(grn.supplier.name.contains(text)){
        searchGRNs.add(grn);
      }
    }
    grns.clear();
    grns.addAll(searchGRNs);
  }

}