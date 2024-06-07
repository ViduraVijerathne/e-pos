import 'package:fluent_ui/fluent_ui.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:point_of_sale/models/stock.dart';
import 'package:point_of_sale/utils/barcodeGenerator.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:point_of_sale/utils/printer.dart';

class PrintStockBarcode extends StatefulWidget {
  final Stock stock;
  const PrintStockBarcode({super.key,required this.stock});

  @override
  State<PrintStockBarcode> createState() => _PrintStockBarcodeState();
}

class _PrintStockBarcodeState extends State<PrintStockBarcode> {
  int quantity = 1;

  @override
  void initState() {
    quantity = widget.stock.availbleQty.toInt();

    super.initState();
  }

  void print(){
    if(quantity <= 0){
      return;
    }
    Printer.printBarcode(widget.stock.barcode, quantity);
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: FluentTheme.of(context).cardColor,
      ),
      child: Column(
        children: [
          Text("Print Stock Barcode",style: FluentTheme.of(context).typography.title),
          const SizedBox(height: 10,),
          SvgPicture.string(
            BarcodeGenerator.generateBarcodeImage(widget.stock.barcode),
            width: 200,
            height: 80,
          ),
          const SizedBox(height: 10,),
          SizedBox(
            width: 300,
            child: InfoLabel(
              label: "Quantity",
              child: NumberBox(value: quantity, onChanged: (value) {
                setState(() {
                  quantity = value ?? 1 ;
                });
              },),
            ),
          ),
          const SizedBox(height: 10,),
          FilledButton(child: Text("Print"), onPressed: print)
        ],
      )
    );
  }
}
