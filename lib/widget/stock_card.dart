import 'package:fluent_ui/fluent_ui.dart';
import 'package:point_of_sale/models/product.dart';
import 'package:point_of_sale/models/supplier.dart';
import 'package:point_of_sale/widget/grn_card.dart';
import 'package:point_of_sale/widget/product_card.dart';
import 'package:point_of_sale/widget/supplierCard.dart';
import 'package:point_of_sale/widget/update_default_discount_stock.dart';

import '../models/stock.dart';
import '../utils/other_utils.dart';

class StockCardWidget extends StatefulWidget {
  final Stock stock;
  const StockCardWidget({super.key, required this.stock});

  @override
  State<StockCardWidget> createState() => _StockCardWidgetState();
}

class _StockCardWidgetState extends State<StockCardWidget> {
  final leftFlex = 135.0;

  final rightFlex = 150.0;

  void viewGRN(){
    Navigator.of(context).push(FluentDialogRoute(builder: (context) =>GRNCard(grn: widget.stock.grn, refresh: (){}, supplierOtherGRNs: (Supplier supplier){}, productOtherGRNs: (p0){},) , context: context));
  }
  void viewProduct(){
    Navigator.of(context).push(FluentDialogRoute(builder: (context) => ProductCard(product: widget.stock.product, refresh: (){}, viewStock: (Product product) {  }, viewProductSales: (Product product) {  },), context: context));
  }

  void viewSupplier(){
    Navigator.of(context).push(FluentDialogRoute(builder: (context) => SupplierCard(supplier: widget.stock.grn.supplier, changeState: (){}), context: context));
  }
  void updateDefaultDiscount()async{
   await  Navigator.of(context).push(FluentDialogRoute(builder:(context) => UpdateDefaultDiscountStock(stock: widget.stock) , context: context));
   showMessageBox("Success", "Discount Updated Successfully", InfoBarSeverity.success);

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
                "${widget.stock.product.name}",
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
                  "Stock Barcode",
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
                    "${widget.stock.barcode}",
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
                    "${widget.stock.product.barcode}",
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
                  "Manufacture Date",
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
                    "${OtherUtils.formatDateTime(widget.stock.mnf_date)}",
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
                  "Expire Date",
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
                    "${OtherUtils.formatDateTime(widget.stock.exp_date)}",
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
                  "Available Quantity",
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
                    "${widget.stock.availbleQty}",
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
                    "${widget.stock.wholesalePrice}",
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
                    "${widget.stock.retailPrice}",
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
                  "Default Discount",
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
                    "${widget.stock.defaultDiscount}",
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
                  "GRN",
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
                  child: Button(
                    child: Text("View GRN"),
                    onPressed: viewGRN,
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
                  "Product",
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
                  child: Button(
                    child: Text("View Product"),
                    onPressed: viewProduct,
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
                  "Supplier",
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
                  child: Button(
                    child: Text("View Supplier"),
                    onPressed:viewSupplier,
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
                    child: Text("Update Default Discount"),
                    onPressed: updateDefaultDiscount,
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
