import 'package:firedart/generated/google/firestore/v1/document.pb.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:point_of_sale/widget/customer_card.dart';
import 'package:point_of_sale/widget/supplierCard.dart';

import '../models/grn.dart';

class PayForGRN extends StatefulWidget {
  final GRN grn;

  const PayForGRN({super.key, required this.grn});

  @override
  State<PayForGRN> createState() => _PayForGRNState();
}

class _PayForGRNState extends State<PayForGRN> {
  double payAmount = 0;
  double afterPaymentDueAmount = 0;

  @override
  void initState() {
    afterPaymentDueAmount = widget.grn.douedAmount;
    super.initState();
  }

  void calculateDueAmount(double? value) {
    if (value != null && value > widget.grn.douedAmount) {
      payAmount = widget.grn.douedAmount;
    } else {
      payAmount = value ?? 0;
    }

    afterPaymentDueAmount = widget.grn.douedAmount - payAmount;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 450,
        width: 500,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: FluentTheme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Pay For GRN",
              style: FluentTheme.of(context).typography.title,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "${widget.grn.product.name} : ${widget.grn.barcode}",
              style: FluentTheme.of(context)
                  .typography
                  .title!
                  .copyWith(fontSize: 18),
            ),
            Button(child: Text(widget.grn.supplier.name), onPressed: () {
              Navigator.of(context).push(FluentDialogRoute(builder: (context) => Center(child: SizedBox(width:500,child: SupplierCard(supplier: widget.grn.supplier, changeState: () {  },))), context: context));
            },),
            const SizedBox(
              height: 50,
            ),
            InfoLabel(
              label: "Due Amount",
              child: Text(
                widget.grn.douedAmount.toString(),
                style: FluentTheme.of(context)
                    .typography
                    .bodyStrong!
                    .copyWith(fontSize: 20),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            InfoLabel(
              label: "Pay Amount",
              child: NumberBox<double>(
                value: payAmount,
                onChanged: calculateDueAmount,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            InfoLabel(
              label: "After Payment Due Amount",
              child: Text(
                afterPaymentDueAmount.toString(),
                style: FluentTheme.of(context)
                    .typography
                    .bodyStrong!
                    .copyWith(fontSize: 20),
              ),
            ),
            const SizedBox(height: 50,),
            Row(
              children: [
                Expanded(
                  flex: 1,
                    child: Button(
                  child: Text(
                    "Cancel",
                    style: FluentTheme.of(context)
                        .typography
                        .bodyStrong!
                        .copyWith(color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                )),
                const SizedBox(width: 20,),
                Expanded(
                    flex: 1,
                    child: FilledButton(
                      child: Text(
                        "Pay",
                        style: FluentTheme.of(context)
                            .typography
                            .bodyStrong!
                            .copyWith(color: Colors.white),
                      ),
                      onPressed:() async{
                        await widget.grn.pay(payAmount);
                        Navigator.of(context).pop(true);

                      },
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }
}
