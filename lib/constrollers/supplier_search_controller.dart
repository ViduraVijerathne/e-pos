import '../models/supplier.dart';

class SupplierSearchController{
  List<Supplier> suppliers = [];
  SupplierSearchController({required List<Supplier> suppliers }){
    this.suppliers.addAll(suppliers);
  }
  void clear(){
    suppliers.clear();
  }

  void searchByName(String name){
    List<Supplier> searchSupplier = [];
    for(Supplier st in suppliers){
      if(st.name.startsWith(name)){
        searchSupplier.add(st);
      }
    }
    clear();
    suppliers.addAll(searchSupplier);
  }

  void searchByEmail(String email){
    print(email);
    List<Supplier> searchSupplier = [];
    for(Supplier st in suppliers){
      if(st.email.startsWith(email)){
        searchSupplier.add(st);
      }
    }
    clear();
    suppliers.addAll(searchSupplier);


  }

  void searchByContact(String contact) {
    List<Supplier> searchSupplier = [];
    for (Supplier st in suppliers) {
      if (st.contact.startsWith(contact)) {
        searchSupplier.add(st);
      }
    }
    clear();
    suppliers.addAll(searchSupplier);
  }


  List<Supplier> getAll(){
    return suppliers;
  }


}