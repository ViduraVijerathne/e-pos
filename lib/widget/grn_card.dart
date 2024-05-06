import 'package:fluent_ui/fluent_ui.dart';
import 'package:point_of_sale/models/grn.dart';
import 'package:point_of_sale/widget/pay_for_grn_widget.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';

import '../models/product.dart';
import '../models/supplier.dart';
import '../utils/other_utils.dart';

class GRNCard extends StatefulWidget {
  final GRN grn;
  final VoidCallback refresh;
  final Function(Supplier) supplierOtherGRNs;
  final Function(Product) productOtherGRNs;
  const GRNCard({super.key, required this.grn, required this.refresh,required this.supplierOtherGRNs,required this.productOtherGRNs});

  @override
  State<GRNCard> createState() => _GRNCardState();
}

class _GRNCardState extends State<GRNCard> {
  final leftFlex = 135.0;

  final rightFlex = 150.0;

  double payAmount = 0;
  double dueAmount  = 0;

  @override
  void initState() {
    // TODO: implement initState
    dueAmount =  widget.grn.douedAmount;
    super.initState();
  }

  void calculateDueAmount(double? value){
    payAmount = value ?? 0;
    dueAmount = widget.grn.douedAmount - payAmount;
    setState(() {
      
    });
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

  void pay()async{
    bool? result = await Navigator.of(context).push<bool>(FluentDialogRoute(builder: (context) => PayForGRN(grn: widget.grn), context: context));

    if(result == null){
      showMessageBox("GRN payment Failed!", "Something went Wrong", InfoBarSeverity.error);
    }else{
      if(result){
        showMessageBox("GRN payment Success!", "GRN Successfully paid", InfoBarSeverity.success);
        widget.refresh();
      }else{
        showMessageBox("GRN payment Failed!", "Payment Cancel by user", InfoBarSeverity.error);
      }
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
                "${widget.grn.supplier.name} - ${widget.grn.product.name}",
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
                  "GRN Barcode",
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
                    "${widget.grn.barcode}",
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
                  "Product Barcode",
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
                    "${widget.grn.product.barcode}",
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
                  "GRN Date",
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
                    "${OtherUtils.formatDateTime(widget.grn.grnDate)}",
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
                  "GRN Quantity",
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
                    "${widget.grn.quantity}",
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
                  "WholeSale Price",
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
                    "${widget.grn.wholesalePrice}",
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
                  "Retail Price",
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
                    "${widget.grn.retailPrice}",
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
                  "Value",
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
                    "${widget.grn.value}",
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
                  "Paid Amount",
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
                    "${widget.grn.paidAmount}",
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
                  "Due Amount",
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
                    "${widget.grn.douedAmount}",
                    style: FluentTheme.of(context).typography.body!.copyWith(
                        fontWeight: FontWeight.w700,
                        color:
                            widget.grn.douedAmount == 0 ? Colors.green : Colors.red),
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
                  "Description",
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
                  child: SelectableText("${widget.grn.description}",
                      style: FluentTheme.of(context).typography.body!),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          SizedBox(
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                widget.grn.douedAmount == 0
                    ? const SizedBox()
                    : Expanded(
                        flex: 2,
                        child: FilledButton(
                            style: ButtonStyle(
                                backgroundColor: ButtonState.all(Colors.green)),
                            child: const Text(
                              "Pay",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            onPressed: pay)),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                    flex: 1,
                    child: FilledButton(
                        child: const Text("View Stock",
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.white)),
                        onPressed: () {})),
              ],
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          SizedBox(
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  flex: 1,
                  child: FilledButton(
                    child: const Text(
                      "Product Other GRNs",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    onPressed: () {
                      widget.productOtherGRNs(widget.grn.product);
                    },
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  flex: 1,
                  child: FilledButton(
                      child: const Text(
                        "Supplier Other GRNs",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      onPressed: () {
                        widget.supplierOtherGRNs(widget.grn.supplier);
                      }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
