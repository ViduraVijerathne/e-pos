import 'package:fluent_ui/fluent_ui.dart';
import 'package:point_of_sale/widget/loading_widget.dart';

import '../models/customer.dart';

class SelectCustomer extends StatefulWidget {
  const SelectCustomer({super.key});

  @override
  State<SelectCustomer> createState() => _SelectCustomerState();
}

class _SelectCustomerState extends State<SelectCustomer> {
  List<Customer> customers = [];
  bool isLoading = true;
  Customer? selectedCustomer;

  final TextEditingController mobileController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  void loadCustomers() async {
    customers = await Customer.getAll(limit: 10);
    setState(() {
      isLoading = false;
    });
  }
  @override
  void initState() {
    loadCustomers();
    super.initState();
  }

  void loadCustomer(Customer customer){
    mobileController.text = customer.contact;
    nameController.text = customer.name;
    addressController.text = customer.address;
    setState(() {

    });
  }

  void showMessage(String title,String body ,InfoBarSeverity severity)async{
    await displayInfoBar(context, builder: (context, close) {
      return InfoBar(
        title:  Text(title),
        content: Text(body),
        action: IconButton(
          icon: const Icon(FluentIcons.clear),
          onPressed: close,
        ),
        severity: severity,
      );
    });
  }

  void clear(){
    selectedCustomer = null;
    mobileController.text = "";
    nameController.text = "";
    addressController.text = "";
    loadCustomers();
    setState(() {});
  }

  void register()async{
    if(mobileController.text.isEmpty || mobileController.text.length <10){
      showMessage("Error","Invalid Mobile Number",InfoBarSeverity.error);
      return;
    }
    if(nameController.text.isEmpty){
      showMessage("Error","Invalid Name",InfoBarSeverity.error);
      return;
    }
    if(addressController.text.isEmpty){
      showMessage("Error","Invalid Address",InfoBarSeverity.error);
      return;
    }
    if(await Customer.getByMobile(mobileController.text) != null){
      showMessage("Error","Customer Already Exists",InfoBarSeverity.error);
      return;
    }
    Customer customer = Customer(id:1,name: nameController.text,contact: mobileController.text,address: addressController.text);
    Customer newCustomer = await customer.insertAndGetCustomer();
    Navigator.pop(context,newCustomer);
  }

  void search(String text)async{
    if(text.isEmpty){
      loadCustomers();
    }else{
      customers.clear();
      customers.addAll(await Customer.search(text));
    }
    setState(() {

    });
  }


  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 500,
        width: 900,
        decoration: BoxDecoration(
          color: FluentTheme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(10)
        ),
        child: ListView(
          children: [
            SizedBox(height: 10,),
            Text("Select Customer ",style: FluentTheme.of(context).typography.subtitle,textAlign: TextAlign.center),
            SizedBox(height: 10,),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Flexible(
                    flex: 1,
                    child: TextBox(placeholder: "Customer Mobile Number",controller: mobileController,onChanged: (value) {
                      search(value);
                    },),
                  ),
                  SizedBox(width: 10,),
                  Flexible(
                    flex: 1,
                    child: TextBox(placeholder: "Customer Name",controller: nameController,onChanged: (value) {
                      search(value);
                    },),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Flexible(
                    flex: 1,
                    child: TextBox(placeholder: "Customer Address",controller: addressController,onChanged: (value) {
                      search(value);
                    }),
                  ),
                  SizedBox(width: 10,),
                  Flexible(
                    flex: 1,
                    child:Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Flexible(
                        //   child: FilledButton(
                        //     child: Text("Search"),
                        //     onPressed: (){},
                        //   ),
                        // ),
                        Flexible(
                          child: FilledButton(
                            child: Text("Register"),
                            onPressed: register,
                          ),
                        ),
                        Flexible(
                          child: FilledButton(
                            style: ButtonStyle(backgroundColor: ButtonState.all(Colors.red)),
                            child: Text("Clear",style: FluentTheme.of(context).typography.bodyStrong!.copyWith(color: Colors.white)),
                            onPressed: clear,
                          ),
                        ),

                      ],
                    ),
                  ),
                  Flexible(
                    child: FilledButton(
                      style: ButtonStyle(backgroundColor: ButtonState.all(Colors.green)),
                      child: Text(selectedCustomer == null ? "Continue As Unknown Customer" : "Continue As ${selectedCustomer!.name}",style: FluentTheme.of(context).typography.bodyStrong!.copyWith(color: Colors.white)),
                      onPressed: (){
                        Navigator.pop(context,selectedCustomer);
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10,),

            isLoading? LoadingWidget(): customers.isEmpty ? Text("no Customer to show",style: FluentTheme.of(context).typography.bodyStrong!.copyWith(color: Colors.red,fontWeight: FontWeight.w700,fontSize: 20),textAlign: TextAlign.center,):SizedBox(),

            Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: FluentTheme.of(context).accentColor
              ),
              child: Row(
                children: [
                  Flexible(
                    flex: 1,
                    fit: FlexFit.tight,
                    child: Text("ID",style: FluentTheme.of(context).typography.bodyStrong),
                  ),
                  Flexible(
                    flex: 1,
                    fit: FlexFit.tight,
                    child: Text("Name",style: FluentTheme.of(context).typography.bodyStrong),
                  ),
                  Flexible(
                    flex: 1,
                    fit: FlexFit.tight,
                    child: Text("Mobile",style: FluentTheme.of(context).typography.bodyStrong),
                  ),
                  Flexible(
                    flex: 1,
                    fit: FlexFit.tight,
                    child: Text("Address",style: FluentTheme.of(context).typography.bodyStrong),
                  ),
                  Flexible(
                    flex: 1,
                    fit: FlexFit.tight,
                    child: Center(child: Text("#",style: FluentTheme.of(context).typography.bodyStrong)),
                  ),

                ],
              ),
            ),
            ...customers.map((e) => Container(
              padding: EdgeInsets.all(5),
              margin: EdgeInsets.only(top: 5),
              decoration: BoxDecoration(
                  color: FluentTheme.of(context).cardColor
              ),
              child: Row(
                children: [
                  Flexible(
                    flex: 1,
                    fit: FlexFit.tight,
                    child: Text("${e.id}",style: FluentTheme.of(context).typography.bodyStrong),
                  ),
                  Flexible(
                    flex: 1,
                    fit: FlexFit.tight,
                    child: Text(e.name,style: FluentTheme.of(context).typography.bodyStrong),
                  ),
                  Flexible(
                    flex: 1,
                    fit: FlexFit.tight,
                    child: Text(e.contact,style: FluentTheme.of(context).typography.bodyStrong),
                  ),
                  Flexible(
                    flex: 1,
                    fit: FlexFit.tight,
                    child: Text(e.address,style: FluentTheme.of(context).typography.bodyStrong),
                  ),
                  Flexible(
                    flex: 1,
                    fit: FlexFit.tight,
                    child: Center(
                      child: Checkbox(
                        onChanged: (value) {
                          if(value == true){
                            selectedCustomer = e;
                            loadCustomer(e);
                            setState(() {});
                          }else{
                            if(selectedCustomer == e){
                              selectedCustomer = null;
                              setState(() {});
                            }
                          }
                        },
                        checked: selectedCustomer == e,

                      ),
                    ),
                  ),

                ],
              ),
            ))

          ],
        ),
      ),
    );
  }
}
