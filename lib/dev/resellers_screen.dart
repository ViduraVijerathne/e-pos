import 'package:fluent_ui/fluent_ui.dart';
import 'package:point_of_sale/dev/dev_models/Reseller.dart';
class ResellersScreen extends StatefulWidget {
  const ResellersScreen({super.key});

  @override
  State<ResellersScreen> createState() => _ResellersScreenState();
}

class _ResellersScreenState extends State<ResellersScreen> {
  List<Reseller> resellers = [];

  void loadResellers()async{
    resellers.addAll(await Reseller.getAllResellers());
    setState(() {

    });
  }

  @override
  void initState() {
    loadResellers();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      header: Container(
        width: double.infinity,
        height: 100,
        decoration: BoxDecoration(
          color: FluentTheme.of(context).cardColor,
          borderRadius: BorderRadius.circular(10)
        ),
        child: Center(child: Text("Resellers",style: FluentTheme.of(context).typography.title,)),
      ),
      content:ListView(
        children: [
          Row(
            children: [
              Flexible(
                flex: 2,
                fit: FlexFit.tight,
                child: _tableHead(context,"#"),
              ),

              Flexible(
                flex: 2,
                fit: FlexFit.tight,
                child: _tableHead(context,"Email"),
              ),
              Flexible(
                flex: 2,
                fit: FlexFit.tight,
                child: _tableHead(context,"Mobile"),
              ),
              Flexible(
                flex: 2,
                fit: FlexFit.tight,
                child: _tableHead(context,"Password"),
              ),
              Flexible(
                flex: 2,
                fit: FlexFit.tight,
                child: _tableHead(context,"Active Status"),
              ),
              Flexible(
                flex: 2,
                fit: FlexFit.tight,
                child: _tableHead(context,"#"),
              ),

            ],
          ),
          ...resellers.map((e) =>  Container(
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
                      child:  Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(200),
                            child: Image.network(e.image,width: 50,height: 50,fit: BoxFit.fill),
                          )
                      ),
                    ),

                    Flexible(
                      flex: 2,
                      fit: FlexFit.tight,
                      child: _tableBodyCell(context,e.email),
                    ),
                    Flexible(
                      flex: 2,
                      fit: FlexFit.tight,
                      child: _tableBodyCell(context,e.mobile),
                    ),
                    Flexible(
                      flex: 2,
                      fit: FlexFit.tight,
                      child: _tableBodyCell(context,e.password),
                    ),
                    Flexible(
                      flex: 2,
                      fit: FlexFit.tight,
                      child: _tableBodyCell(context,e.isActivated ? "ACTIVE":"DE-ACTIVE"),
                    ),
                    Flexible(
                      flex: 2,
                      fit: FlexFit.tight,
                      child: _tableBodyCell(context,""),
                    ),

                  ],
                ),
              ],
            ),
          ))
        ],
      )
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
