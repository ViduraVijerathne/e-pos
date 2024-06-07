import 'dart:convert';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:point_of_sale/models/supplier.dart';
import 'package:point_of_sale/models/supplierBankAccountDetails.dart';
import 'package:point_of_sale/models/users.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';

class AddSupplierScreen extends StatefulWidget {
   final Supplier? supplier;
   const AddSupplierScreen({super.key, this.supplier});
   static UserAccess access = UserAccess.ADDSUPPLIER;
  @override
  State<AddSupplierScreen> createState() => _AddSupplierScreenState();
}

class _AddSupplierScreenState extends State<AddSupplierScreen> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _supplierNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _bankNameController = TextEditingController();
  final TextEditingController _accountNumberController = TextEditingController();
  final TextEditingController _bankAccountBranchController = TextEditingController();
  final TextEditingController _bankAccountHolderNameController = TextEditingController();
  bool validate(){
    if(_supplierNameController.text.isEmpty){
      showMessageBox("Error!", "Please Enter Supplier Name", InfoBarSeverity.error);
      return false;
    }
    if(_addressController.text.isEmpty){
      showMessageBox("Error!", "Please Enter Supplier Address", InfoBarSeverity.error);
      return false;
    }
    if(_phoneController.text.isEmpty){
      showMessageBox("Error!", "Please Enter Supplier Phone", InfoBarSeverity.error);
      return false;
    }
    if(_emailController.text.isEmpty){
      showMessageBox("Error!", "Please Enter Supplier Email", InfoBarSeverity.error);
      return false;
    }
    if(_bankNameController.text.isEmpty){
      showMessageBox("Error!", "Please Enter Bank Name", InfoBarSeverity.error);
      return false;
    }
    if(_accountNumberController.text.isEmpty){
      showMessageBox("Error!", "Please Enter Bank Account Number", InfoBarSeverity.error);
      return false;
    }
    if(_bankAccountBranchController.text.isEmpty){
      showMessageBox("Error!", "Please Enter Bank Account Branch", InfoBarSeverity.error);
      return false;
    }
    if(_bankAccountHolderNameController.text.isEmpty){
      showMessageBox("Error!", "Please Enter Bank Account Holder Name", InfoBarSeverity.error);
      return false;
    }
    return true;
  }
  void clear(){
    _idController.clear();
    _supplierNameController.clear();
    _addressController.clear();
    _phoneController.clear();
    _emailController.clear();
    _bankNameController.clear();
    _accountNumberController.clear();
    _bankAccountBranchController.clear();
    _bankAccountHolderNameController.clear();
  }
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
  void addSupplier()async{
    if(validate()){
      SupplierBankAccountDetails accountDetails = SupplierBankAccountDetails(
          SupplierAccountNumber: _accountNumberController.text,
          SupplierBankAccountHolderName: _bankAccountHolderNameController.text,
          SupplierBankAccountBranch: _bankAccountBranchController.text,
          SupplierBankName: _bankNameController.text,
          SupplierAddress: _addressController.text,
          SupplierEmail: _emailController.text,
          SupplierPhone: _phoneController.text,
          SupplierName: _supplierNameController.text


      );

      Supplier supplier = Supplier(
        id: widget.supplier == null ? 0 : widget.supplier!.id,
        name: _supplierNameController.text,
        contact: _phoneController.text,
        email: _emailController.text,
        bankDetails: jsonEncode(accountDetails.toJson()),
      );

      if(widget.supplier == null){

        try{
          await supplier.insert();
          showMessageBox("Success!", " Supplier Inserted Successfully", InfoBarSeverity.success);
          clear();
        }catch(ex){
          showMessageBox("Error!", " Error While Inserting Supplier", InfoBarSeverity.error);
        }
      }
      else{
        try{
          await supplier.update();
          widget.supplier!.email = supplier.email;
          widget.supplier!.contact = supplier.contact;
          widget.supplier!.name = supplier.contact;
          widget.supplier!.bankDetails = supplier.bankDetails;
          showMessageBox("Success!", " Supplier Update Successfully", InfoBarSeverity.success);
          Navigator.of(context).pop(supplier);
          clear();
        }catch(ex){
          showMessageBox("Error!", " Error While Update Supplier", InfoBarSeverity.error);
        }
      }

    }
  }

  void loadSuppler(Supplier supplier){
    SupplierBankAccountDetails bankAccountDetails = SupplierBankAccountDetails.fromJson(jsonDecode(supplier.bankDetails));
    _idController.text = "${supplier.id}";
    _supplierNameController.text = supplier.name;
    _addressController.text = bankAccountDetails.SupplierAddress ;
    _phoneController.text = supplier.contact;
    _emailController.text = supplier.email;
    _bankNameController.text = bankAccountDetails.SupplierBankName;
    _accountNumberController.text = bankAccountDetails.SupplierAccountNumber;
    _bankAccountBranchController.text = bankAccountDetails.SupplierBankAccountBranch;
    _bankAccountHolderNameController.text = bankAccountDetails.SupplierBankAccountHolderName;
  }

  @override
  void initState() {
    if(widget.supplier !=null){
      loadSuppler(widget.supplier!);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      header: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.only(left: 20, bottom: 30),
        child: Row(
          children: [
            widget.supplier == null
                ? SizedBox()
                : IconButton(
                icon: Icon(FluentIcons.back),
                onPressed: () {
                  Navigator.pop(context);
                }),
            Text(
              widget.supplier == null ? "Add New Supplier" : "Update Supplier",
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
              label: "Supplier ID",
              labelStyle: FluentTheme.of(context).typography.bodyStrong,
              child: TextBox(
                controller: _idController,
                enabled: false,
                placeholder: "Supplier ID Generate Automatic",
              ),
            ),
            InfoLabel(
              label: "Supplier Name",
              labelStyle: FluentTheme.of(context).typography.bodyStrong,
              child: TextBox(
                controller: _supplierNameController,
                placeholder: "Supplier Name",
              ),
            ),
            InfoLabel(
              label: "Supplier Address",
              labelStyle: FluentTheme.of(context).typography.bodyStrong,
              child: TextBox(
                controller: _addressController,
                placeholder: "Address",
              ),
            ),
            InfoLabel(
              label: "Supplier Contact Number",
              labelStyle: FluentTheme.of(context).typography.bodyStrong,
              child: TextBox(
                controller: _phoneController,
                placeholder: "Contact",
              ),
            ),
            InfoLabel(
              label: "Supplier Email",
              labelStyle: FluentTheme.of(context).typography.bodyStrong,
              child: TextBox(
                controller: _emailController,
                placeholder: "Email",
              ),
            ),
            InfoLabel(
              label: "Supplier Bank Name",
              labelStyle: FluentTheme.of(context).typography.bodyStrong,
              child: TextBox(
                controller: _bankNameController,
                placeholder: "Bank Name",
              ),
            ),
            InfoLabel(
              label: "Supplier Account Number",
              labelStyle: FluentTheme.of(context).typography.bodyStrong,
              child: TextBox(
                controller: _accountNumberController,
                placeholder: "Account Number",
              ),
            ),
            InfoLabel(
              label: "Supplier Bank Account Holder Name",
              labelStyle: FluentTheme.of(context).typography.bodyStrong,
              child: TextBox(
                controller: _bankAccountHolderNameController,
                placeholder: "Bank Account Holder Name",
              ),
            ),
            InfoLabel(
              label: "Supplier Bank Account Branch",
              labelStyle: FluentTheme.of(context).typography.bodyStrong,
              child: TextBox(
                controller: _bankAccountBranchController,
                placeholder: "Bank Account Branch",
              ),
            ),
            FilledButton(onPressed: addSupplier, child: Text(widget.supplier == null? "Add":"Update",style: TextStyle(color: Colors.white),))


          ],
        ),
      ),
    );
  }
}
