import 'package:fluent_ui/fluent_ui.dart';
import 'package:point_of_sale/models/customer.dart';
import 'package:point_of_sale/screens/add_customer.dart';

class CustomerCard extends StatefulWidget {
  final Customer customer;
  const CustomerCard({super.key,required this.customer});

  @override
  State<CustomerCard> createState() => _CustomerCardState();
}

class _CustomerCardState extends State<CustomerCard> {
  final leftFlex = 135.0;
  final rightFlex = 150.0;

  void viewInvoices(){

  }
  void updateCustomer()async{
    var result  = await Navigator.of(context).push<Customer>(FluentDialogRoute(builder: (context) => AddCustomerScreen(customer: widget.customer), context: context));

    if(result != null){
      widget.customer.address = result.address;
      widget.customer.name = result.name;
      widget.customer.contact= result.name;
      setState(() {

      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Color borderColor = FluentTheme.of(context).accentColor.withOpacity(0.2);
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: FluentTheme.of(context).cardColor,
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: FluentTheme.of(context).accentColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10)),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: FluentTheme.of(context).accentColor.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(10)),
              child: Text(
                "${widget.customer.name}",
                textAlign: TextAlign.center,
                style: FluentTheme.of(context)
                    .typography
                    .bodyLarge!
                    .copyWith(color: Colors.white, fontWeight: FontWeight.w700),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Container(
                width: leftFlex,
                padding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: borderColor,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: Text(
                  "Contact",
                  style: FluentTheme.of(context)
                      .typography
                      .body!
                      .copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              Expanded(
                child: Container(
                  width: rightFlex,
                  padding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: borderColor,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: SelectableText(
                    "${widget.customer.contact}",
                    style: FluentTheme.of(context)
                        .typography
                        .body!
                        .copyWith(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            children: [
              Container(
                width: leftFlex,
                padding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: borderColor,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: Text(
                  "Address",
                  style: FluentTheme.of(context)
                      .typography
                      .body!
                      .copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              Expanded(
                child: Container(
                  width: rightFlex,
                  padding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: borderColor,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: SelectableText(
                    "${widget.customer.address}",
                    style: FluentTheme.of(context)
                        .typography
                        .body!
                        .copyWith(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),


          Row(
            children: [

              Expanded(
                child: Container(
                  width: rightFlex,
                  padding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: borderColor,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: Button(
                    child: Text("Update Customer"),
                    onPressed: updateCustomer,
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [

              Expanded(
                child: Container(
                  width: rightFlex,
                  padding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: borderColor,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: Button(
                    child: Text("View Invoices"),
                    onPressed: viewInvoices,
                  ),
                ),
              ),
            ],
          ),

        ],
      ),
    );
  }
}
