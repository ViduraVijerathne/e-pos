import 'package:fluent_ui/fluent_ui.dart';
import 'package:point_of_sale/constrollers/supplier_search_controller.dart';
import 'package:point_of_sale/widget/loading_widget.dart';
import 'package:point_of_sale/widget/supplierCard.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';

import '../models/supplier.dart';
class SuppliersScreen extends StatefulWidget {
  const SuppliersScreen({super.key});

  @override
  State<SuppliersScreen> createState() => _SuppliersScreenState();
}

class _SuppliersScreenState extends State<SuppliersScreen> {
  List<Supplier> suppliers = [];
  List<Supplier> searchSupplier = [];
  bool isLoading = false;

  void loadSupplier()async{
    setState(() {
      isLoading = true;
    });
    suppliers.addAll(await Supplier.getAll());
    searchSupplier.addAll(suppliers);
    setState(() {
      isLoading = false;
    });
  }
  @override
  void initState() {
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
  void search(){
    print(suppliers.length);
    SupplierSearchController controller = SupplierSearchController(suppliers: suppliers);
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
    searchSupplier.addAll(controller.getAll());
    print(controller.getAll().length);
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
  @override
  Widget build(BuildContext context) {
    return ScaffoldPage.scrollable(
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
        isLoading ? LoadingWidget():ResponsiveGridList(
          minItemWidth: 300,
          listViewBuilderOptions: ListViewBuilderOptions(
            shrinkWrap: true,
          ),
          children:searchSupplier.map((e) => SupplierCard(supplier: e,changeState:changeState)).toList()
        ),
      ],
    );
  }
}
