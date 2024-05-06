import 'package:fluent_ui/fluent_ui.dart';

import '../models/stock.dart';
class UpdateDefaultDiscountStock extends StatefulWidget {
  final Stock stock;
  const UpdateDefaultDiscountStock({super.key,required this.stock});

  @override
  State<UpdateDefaultDiscountStock> createState() => _UpdateDefaultDiscountStockState();
}

class _UpdateDefaultDiscountStockState extends State<UpdateDefaultDiscountStock> {
  double defaultDiscount = 0;
  @override
  void initState() {
    defaultDiscount = widget.stock.defaultDiscount;
    if(mounted){
      setState(() {

      });
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 250,
        width: 500,
        child: Container(
          padding: EdgeInsets.all(10),
         decoration: BoxDecoration(
           color: FluentTheme.of(context).scaffoldBackgroundColor,
           borderRadius: BorderRadius.circular(10),
         ),
          child: Column(
            children: [
              Text("Update Stock Default Discount", style: FluentTheme.of(context).typography.title,),
              const SizedBox(height: 30,),
              SizedBox(
                width: 300,
                child: NumberBox<double>(
                  value: defaultDiscount,
                  onChanged: (value) {
                    defaultDiscount = value??0;
                    if(mounted){
                      setState(() {

                      });
                    }
                  },
                ),
              ),
              const SizedBox(height: 30,),
              FilledButton(
                child: const Text("Update",style: TextStyle(color: Colors.white),),
                onPressed:()async{
                  widget.stock.defaultDiscount = defaultDiscount;
                  await widget.stock.updateDefaultDiscount();
                  setState(() {

                  });

                  Navigator.of(context).pop();
                },
              )

            ],
          ),
        ),
      ),
    );
  }
}
