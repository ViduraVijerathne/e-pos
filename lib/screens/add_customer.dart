import 'package:fluent_ui/fluent_ui.dart';
import 'package:point_of_sale/models/customer.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';

import '../models/users.dart';

class AddCustomerScreen extends StatefulWidget {
  final Customer? customer;
  const AddCustomerScreen({super.key, this.customer});
  static UserAccess access = UserAccess.ADDCUSTOMERS;
  @override
  State<AddCustomerScreen> createState() => _AddCustomerScreenState();
}

class _AddCustomerScreenState extends State<AddCustomerScreen> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  void showMessageBox(
      String title, String body, InfoBarSeverity severity) async {
    await displayInfoBar(context, builder: (context, close) {
      return InfoBar(
        title: Text(title),
        content: Text(body),
        action: IconButton(
          icon: const Icon(FluentIcons.clear),
          onPressed: close,
        ),
        severity: severity,
      );
    });
  }
  bool validate(){
    if(_nameController.text.isEmpty){
      showMessageBox("Error!", "Please Add Customer Name", InfoBarSeverity.error);
      return false;
    }
    if(_mobileController.text.isEmpty){
      showMessageBox("Error!", "Please Add Customer mobile", InfoBarSeverity.error);
      return false;
    }
    if(_addressController.text.isEmpty){
      showMessageBox("Error!", "Please Add Customer address", InfoBarSeverity.error);
      return false;
    }

    return true;
  }

  void clear(){
    _nameController.clear();
    _addressController.clear();
    _mobileController.clear();
    _idController.clear();
  }
  void loadCustomer(){
   if(widget.customer != null){
     _nameController.text = widget.customer!.name;
     _idController.text = "${widget.customer!.id}";
     _mobileController.text = widget.customer!.contact;
     _addressController.text = widget.customer!.address;
     if(mounted){
       setState(() {

       });
     }
   }
  }

  @override
  void initState() {
    loadCustomer();
    super.initState();
  }

  void addCustomer()async{
    if(validate()){
      Customer customer = Customer(id: widget.customer == null ? 0 : widget.customer!.id, name: _nameController.text, contact: _mobileController.text, address: _addressController.text);
      if(widget.customer == null){
        try{
         await customer.insert();
          showMessageBox("Success!", "Customer Successfully Added", InfoBarSeverity.success);
          clear();
        }catch(ex){
          showMessageBox("Error!", "Something went wrong!", InfoBarSeverity.error);
        }

      }else{
        try{
          await customer.update();
          showMessageBox("Error!", "Customer Successfully Update!", InfoBarSeverity.success);
          Navigator.of(context).pop(customer);
        }catch(ex){
          showMessageBox("Error!", "Something went wrong!", InfoBarSeverity.error);
        }
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      header: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.only(left: 20, bottom: 30),
        child: Row(
          children: [
            widget.customer == null
                ? SizedBox()
                : IconButton(
                icon: Icon(FluentIcons.back),
                onPressed: () {
                  Navigator.pop(context);
                }),
            Text(
              widget.customer == null ? "Add New Customer" : "Update Customer",
              style: FluentTheme.of(context).typography.title,
            ),
          ],
        ),
      ),
      content: Padding(
        padding: const EdgeInsets.all(10),
        child: ResponsiveGridList(
          minItemWidth: 250,
          children: [
            InfoLabel(
              label: "Customer ID",
              labelStyle: FluentTheme.of(context).typography.bodyStrong,
              child: TextBox(
                controller: _idController,
                enabled: false,
                placeholder: "Customer ID Generate Automatic",
              ),
            ),
            InfoLabel(
              label: "Customer Name",
              labelStyle: FluentTheme.of(context).typography.bodyStrong,
              child: TextBox(
                controller: _nameController,
                placeholder: "Customer Name",
              ),
            ),
            InfoLabel(
              label: "Customer Address",
              labelStyle: FluentTheme.of(context).typography.bodyStrong,
              child: TextBox(
                controller: _addressController,
                placeholder: "Customer",
              ),
            ),
            InfoLabel(
              label: "Customer Contact Number",
              labelStyle: FluentTheme.of(context).typography.bodyStrong,
              child: TextBox(
                controller: _mobileController,
                placeholder: "Contact",
              ),
            ),

            FilledButton(onPressed: addCustomer, child: Text(widget.customer == null? "Add":"Update",style: TextStyle(color: Colors.white),))


          ],
        ),
      ),
    );
  }
}
