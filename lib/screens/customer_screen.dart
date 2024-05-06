import 'package:fluent_ui/fluent_ui.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';

import '../models/customer.dart';
import '../widget/customer_card.dart';
import '../widget/loading_widget.dart';

class CustomerScreen extends StatefulWidget {
  const CustomerScreen({super.key});

  @override
  State<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  List<Customer> customers = [];
  List<Customer> searchCustomer = [];
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  bool isLoading = false;
  void search(){}
  void clear(){}

  void loadCustomers()async{
    setState(() {
      isLoading  = true;
    });
    customers.addAll(await Customer.getAll());
    searchCustomer.addAll(customers);
    setState(() {
      isLoading  = false;
    });
  }

  @override
  void initState() {
    if(mounted){
      loadCustomers();
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return ScaffoldPage.scrollable(
      header: Align(
        alignment: Alignment.center,
        child: Text(
          "Customers",
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
            height: 100,
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
        isLoading ? const LoadingWidget():ResponsiveGridList(
            minItemWidth: 300,
            listViewBuilderOptions: ListViewBuilderOptions(
              shrinkWrap: true,
            ),
            children:searchCustomer.map((e) => CustomerCard(customer:e)).toList()
        ),
      ],
    );
  }
}
