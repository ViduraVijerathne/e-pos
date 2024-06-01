import 'dart:convert';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:point_of_sale/constrollers/supplier_search_controller.dart';
import 'package:point_of_sale/widget/loading_widget.dart';
import 'package:point_of_sale/widget/supplierCard.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';

import '../models/supplier.dart';
import '../models/supplierBankAccountDetails.dart';
class SuppliersScreen extends StatefulWidget {
  const SuppliersScreen({super.key});

  @override
  State<SuppliersScreen> createState() => _SuppliersScreenState();
}

class _SuppliersScreenState extends State<SuppliersScreen> {
  List<Supplier> suppliers = [];
  List<Supplier> searchSupplier = [];
  bool isLoading = false;
  final ScrollController _scrollController = ScrollController();


  void loadSupplier()async{
    
    int limit = suppliers.length+5;
    suppliers.clear();
    searchSupplier.clear();
    suppliers.addAll(await Supplier.getAll(limit: limit));
    searchSupplier.addAll(suppliers);
    setState(() {
    });
  }
  void _onScroll() {
    if (_scrollController.position.atEdge) {
      bool isBottom = _scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent;
      if (isBottom) {
        loadSupplier();
      }
    }
  }
  @override
  void initState() {
    _scrollController.addListener(_onScroll);
    if(mounted){
      loadSupplier();
    }
    super.initState();
  }
  void changeState(){
    setState(() {

    });
  }

  double calculateSizeBoxHeight() {
    double headerSizeBoxHeight = 100;

    print(MediaQuery.of(context).size.width);
    if(MediaQuery.of(context).size.width < 520){
      headerSizeBoxHeight = 500;
    }else if(MediaQuery.of(context).size.width < 750){
      headerSizeBoxHeight = 250;
    }else if(MediaQuery.of(context).size.width < 950){
      headerSizeBoxHeight = 200;
    }else if(MediaQuery.of(context).size.width < 1600){
      headerSizeBoxHeight = 130;
    }else if(MediaQuery.of(context).size.width < 1700){
      headerSizeBoxHeight = 110;
    }

    return headerSizeBoxHeight;
  }
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  void search()async{
    SupplierSearchController controller = SupplierSearchController();
    if(_nameController.text.isNotEmpty){
      controller.searchByName(_nameController.text);
    }
    if(_contactController.text.isNotEmpty){
      controller.searchByContact(_contactController.text);
    }
    if(_emailController.text.isNotEmpty){
      controller.searchByEmail(_emailController.text);
    }
    searchSupplier.clear();
    searchSupplier.addAll(await controller.getAll() );
    setState(() {

    });

  }
  void clear(){
    searchSupplier.clear();
    searchSupplier.addAll(suppliers);
    _emailController.clear();
    _nameController.clear();
    _contactController.clear();
    setState(() {

    });
  }

  SupplierBankAccountDetails loadSupplierBankAccountDetails(Supplier supplier){
    return SupplierBankAccountDetails.fromJson(jsonDecode(supplier.bankDetails));
  }
  @override
  Widget build(BuildContext context) {
    return ScaffoldPage.scrollable(
      scrollController: _scrollController,
      header: Align(
        alignment: Alignment.center,
        child: Text(
          "Suppliers",
          textAlign: TextAlign.center,
          style: FluentTheme.of(context).typography.title,
        ),
      ),
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.all(10),
          width: double.infinity,
          decoration: BoxDecoration(
              color: FluentTheme.of(context).cardColor,
              borderRadius: BorderRadius.circular(10)),
          child: SizedBox(
            height: calculateSizeBoxHeight(),
            child: ResponsiveGridList(
              minItemWidth: 200,
              rowMainAxisAlignment: MainAxisAlignment.center,
              children: [
                InfoLabel(
                  label: "Supplier Name",
                  child: TextBox(
                    controller: _nameController,
                    placeholder: "Supplier Name",
                    // controller: _barcodeController,
                  ),
                ),
                InfoLabel(
                  label: "Supplier Email",
                  child: TextBox(
                    controller: _emailController,
                    placeholder: "Email",
                    // controller: _barcodeController,
                  ),
                ),
                InfoLabel(
                  label: "Supplier Contact",
                  child: TextBox(
                    controller: _contactController,
                    placeholder: "Contact",
                    // controller: _barcodeController,
                  ),
                ),


                Row(
                  children: [
                    SizedBox(
                      height: 32,
                      child: FilledButton(
                          onPressed: search,
                          child: Text(
                            "Search",
                            style: FluentTheme.of(context)
                                .typography
                                .bodyStrong!
                                .copyWith(color: Colors.white),
                          )),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      height: 32,
                      child: FilledButton(
                          onPressed: clear,
                          style: ButtonStyle(
                              backgroundColor: ButtonState.all(Colors.red)),
                          child: Text(
                            "Clear",
                            style: FluentTheme.of(context)
                                .typography
                                .bodyStrong!
                                .copyWith(color: Colors.white),
                          )),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),

        Row(
          children: [
            Flexible(
              flex: 2,
              fit: FlexFit.tight,
              child: _tableHead(context,"ID"),
            ),
            Flexible(
              flex: 2,
              fit: FlexFit.tight,
              child: _tableHead(context,"Contact"),
            ),
            Flexible(
              flex: 2,
              fit: FlexFit.tight,
              child: _tableHead(context,"Email"),
            ),
            Flexible(
              flex: 2,
              fit: FlexFit.tight,
              child: _tableHead(context,"Address"),
            ),
            Flexible(
              flex: 2,
              fit: FlexFit.tight,
              child: _tableHead(context,"Bank Acc Num"),
            ),
            Flexible(
              flex: 2,
              fit: FlexFit.tight,
              child: _tableHead(context,"Bank Name"),
            ),
            Flexible(
              flex: 2,
              fit: FlexFit.tight,
              child: _tableHead(context,"Bank Branch"),
            ),
            Flexible(
              flex: 2,
              fit: FlexFit.tight,
              child: _tableHead(context,"#"),
            )
          ],
        ),
        ...searchSupplier.map((e) => Container(
          height: 100,
          margin: EdgeInsets.only(top: 10),
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
              color: FluentTheme.of(context).cardColor,
              borderRadius: BorderRadius.circular(10)
          ),
          child:  Column(
            children: [
              Row(
                children: [
                  Text(e.name,textAlign: TextAlign.start,style: FluentTheme.of(context).typography.bodyStrong!.copyWith(fontSize: 20)),
                ],
              ),
              Row(
                children: [
                  Flexible(
                    flex: 2,
                    fit: FlexFit.tight,
                    child: _tableBodyCell(context,"${e.id}"),
                  ),
                  Flexible(
                    flex: 2,
                    fit: FlexFit.tight,
                    child: _tableBodyCell(context,e.contact),
                  ),
                  Flexible(
                    flex: 2,
                    fit: FlexFit.tight,
                    child: _tableBodyCell(context,e.email),
                  ),
                  Flexible(
                    flex: 2,
                    fit: FlexFit.tight,
                    child: _tableBodyCell(context,loadSupplierBankAccountDetails(e).SupplierAddress),
                  ),
                  Flexible(
                    flex: 2,
                    fit: FlexFit.tight,
                    child: _tableBodyCell(context,loadSupplierBankAccountDetails(e).SupplierAccountNumber),
                  ),
                  Flexible(
                    flex: 2,
                    fit: FlexFit.tight,
                    child: _tableBodyCell(context,loadSupplierBankAccountDetails(e).SupplierAccountNumber),
                  ),
                  Flexible(
                    flex: 2,
                    fit: FlexFit.tight,
                    child: _tableBodyCell(context,loadSupplierBankAccountDetails(e).SupplierBankAccountBranch),
                  ),
                  Flexible(
                    flex: 2,
                    fit: FlexFit.tight,
                    child: Button(
                      child: Text("View"),
                      onPressed: (){
                        Navigator.of(context).push(FluentDialogRoute(builder: (context) =>Center(
                          child: SizedBox(
                            width: 500,
                            child:SupplierCard(supplier: e,changeState:changeState),
                          ),
                        ) , context: context));
                      },
                    ),
                  )
                ],
              ),
            ],
          ),
        ) ),
      ],
    );
  }
}


Widget _tableHead(BuildContext context,String text){
  return Container(
    padding: EdgeInsets.only(top: 10,bottom: 10,left: 10,right: 10),
    decoration: BoxDecoration(
        color: FluentTheme.of(context).accentColor.withOpacity(0.2)
    ),
    child: Text(text,textAlign: TextAlign.center,style:FluentTheme.of(context).typography.bodyStrong,),
  );
}

Widget _tableBodyCell(BuildContext context,String text) {
  return Container(
    padding: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
    child: Text(text, textAlign: TextAlign.center,),
  );
}
