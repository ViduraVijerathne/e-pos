import 'package:fluent_ui/fluent_ui.dart';
import 'package:point_of_sale/screens/add_product_screen.dart';

import '../models/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final leftFlex = 135.0;
  final rightFlex = 150.0;
  final VoidCallback refresh;
  final Function(Product product) viewStock;
  final Function(Product product) viewProductSales;
  const ProductCard({super.key, required this.product,required this.refresh, required this.viewStock, required this.viewProductSales});

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
            padding:const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: FluentTheme.of(context).accentColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10)),
            child: Container(
              padding:const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: FluentTheme.of(context).accentColor.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(10)),
              child: Text(
                product.name,
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
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                decoration: BoxDecoration(
                  border: Border.all(color:borderColor, width: 1,),
                  borderRadius: BorderRadius.circular(2),
                  
                ),
                child: Text(
                  "Product ID",
                  style: FluentTheme.of(context)
                      .typography
                      .body!
                      .copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              Expanded(
                child: Container(
                  width: rightFlex,
                  padding:const  EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                  decoration: BoxDecoration(
                    border: Border.all(color:borderColor, width: 1,),
                    borderRadius: BorderRadius.circular(2),

                  ),
                  child: SelectableText(
                    "${product.id}",
                    style: FluentTheme.of(context)
                        .typography
                        .body!
                        .copyWith(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
         const SizedBox(height:5,),
          Row(
            children: [
              Container(
                width: leftFlex,
                padding:const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                decoration: BoxDecoration(
                  border: Border.all(color:borderColor, width: 1,),
                  borderRadius: BorderRadius.circular(2),

                ),
                child: Text(
                  "Barcode",
                  style: FluentTheme.of(context)
                      .typography
                      .body!
                      .copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              Flexible(
                child: Container(
                  width: rightFlex,
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                  decoration: BoxDecoration(
                    border: Border.all(color:borderColor, width: 1,),
                    borderRadius: BorderRadius.circular(2),

                  ),
                  child: SelectableText(
                    product.barcode,
                    style: FluentTheme.of(context)
                        .typography
                        .body!
                        .copyWith(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5,),
          Row(
            children: [
              Container(
                width: leftFlex,
                padding:const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                decoration: BoxDecoration(
                  border: Border.all(color:borderColor, width: 1,),
                  borderRadius: BorderRadius.circular(2),

                ),
                child: Text(
                  "Sinhala Name",
                  style: FluentTheme.of(context)
                      .typography
                      .body!
                      .copyWith(fontWeight: FontWeight.w700),
                ),
              ),

              Expanded(
                child: Container(
                  width: rightFlex,
                  padding:const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                  decoration: BoxDecoration(
                    border: Border.all(color:borderColor, width: 1,),
                    borderRadius: BorderRadius.circular(2),

                  ),
                  child: SelectableText(
                    "${product.siName}",
                    style: FluentTheme.of(context)
                    .typography
                    .body!
                    .copyWith(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5,),
          Row(
            children: [
              Container(
                width: leftFlex,
                padding:const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                decoration: BoxDecoration(
                  border: Border.all(color:borderColor, width: 1,),
                  borderRadius: BorderRadius.circular(2),

                ),
                child: Text(
                  "Main Category",
                  style: FluentTheme.of(context)
                      .typography
                      .body!
                      .copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              Expanded(
                  child: Container(
                    width: rightFlex,
                    padding:const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                    decoration: BoxDecoration(
                      border: Border.all(color:borderColor, width: 1,),
                      borderRadius: BorderRadius.circular(2),

                    ),
                    child: SelectableText(
                product.mainCategory.name,
                style: FluentTheme.of(context)
                      .typography
                      .body!
                      .copyWith(fontWeight: FontWeight.w700),
              ),
                  )),
            ],
          ),
          const SizedBox(height: 5,),
          Row(
            children: [
              Container(
                width: leftFlex,
                padding:const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                decoration: BoxDecoration(
                  border: Border.all(color:borderColor, width: 1,),
                  borderRadius: BorderRadius.circular(2),

                ),
                child: Text(
                  "Sub Category",
                  style: FluentTheme.of(context)
                      .typography
                      .body!
                      .copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              Expanded(
                  child: Container(
                    width: rightFlex,
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                    decoration: BoxDecoration(
                      border: Border.all(color:borderColor, width: 1,),
                      borderRadius: BorderRadius.circular(2),

                    ),
                    child: SelectableText(
                product.subCategory.name,
                style: FluentTheme.of(context)
                      .typography
                      .body!
                      .copyWith(fontWeight: FontWeight.w700),
              ),
                  )),
            ],
          ),
          const SizedBox(height: 5,),
          Row(
            children: [
              Container(
                width: leftFlex,
                padding:const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                decoration: BoxDecoration(
                  border: Border.all(color: borderColor, width: 1,),
                  borderRadius: BorderRadius.circular(2),

                ),
                child: Text(
                  "Unit",
                  style: FluentTheme.of(context)
                      .typography
                      .body!
                      .copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              Expanded(
                  child: Container(
                    width: rightFlex,
                    padding:const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                    decoration: BoxDecoration(
                      border: Border.all(color:borderColor, width: 1,),
                      borderRadius: BorderRadius.circular(2),

                    ),
                    child: SelectableText(
                product.unit.name,
                style: FluentTheme.of(context)
                      .typography
                      .body!
                      .copyWith(fontWeight: FontWeight.w700),
              ),
                  )),
            ],
          ),
          const SizedBox(height: 5,),
          Row(
            children: [
              Container(
                width: leftFlex,
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                decoration: BoxDecoration(
                  border: Border.all(color: borderColor, width: 1,),
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
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                    decoration: BoxDecoration(
                      border: Border.all(color:borderColor, width: 1,),
                      borderRadius: BorderRadius.circular(2),

                    ),
                    child: SelectableText(
                product.description,
                style: FluentTheme.of(context)
                      .typography
                      .body!
                      .copyWith(fontWeight: FontWeight.w700),
              ),
                  )),
            ],
          ),
          const SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FilledButton(child: Text("View Stocks"), onPressed: (){
                viewStock(product);
              }),
              FilledButton(child: Text("View Sales"), onPressed: (){
                viewProductSales(product);
              }),
              FilledButton(child: Text("Update"), onPressed: ()async{

                await Navigator.of(context).push(FluentDialogRoute(builder: (context) => AddProductScreen(product: product,isEditingMode: true), context: context));
                refresh();
              }),
            ],
          )
        ],
      ),
    );
  }
}
