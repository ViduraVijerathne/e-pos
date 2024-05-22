import 'package:fluent_ui/fluent_ui.dart';

import '../models/grn.dart';

class GrnDateFilterWidget extends StatefulWidget {
  final List<GRN> grns;
  const GrnDateFilterWidget({super.key,required this.grns});

  @override
  State<GrnDateFilterWidget> createState() => _GrnDateFilterWidgetState();
}

class _GrnDateFilterWidgetState extends State<GrnDateFilterWidget> {
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();
  void filter(){

    if(fromDate.isAfter(toDate)){
      print("INVALID");
      Navigator.of(context).pop(false);
      return;
    }

    if(fromDate == toDate){
      List<GRN> searchGrns = [];
      for(GRN grn in widget.grns){
        if(grn.grnDate == fromDate){
          searchGrns.add(grn);
        }
      }
      widget.grns.clear();
      widget.grns.addAll(searchGrns);
      Navigator.of(context).pop(true);
    }else{

      List<GRN> searchGrns = [];
      for(GRN grn in widget.grns){
        if(grn.grnDate.isAfter(fromDate) && grn.grnDate.isBefore(toDate)){
          searchGrns.add(grn);
        }
      }
      widget.grns.clear();
      widget.grns.addAll(searchGrns);
      Navigator.of(context).pop(true);

    }


  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Container(
          height: 300,
          width: 500,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: FluentTheme.of(context).scaffoldBackgroundColor,
          ),
          child: Column(
            children: [
              Text("Date Filter",style: FluentTheme.of(context).typography.title,),
              const SizedBox(height: 30,),
              InfoLabel(
                  label: "Date From",
                  child: DatePicker(
                    selected: fromDate,
                    onChanged: (value) {
                      fromDate = value;
                      setState(() {

                      });
                    },

                  ),
              ),
              const SizedBox(height: 10,),
              InfoLabel(
                label: "Date To",
                child: DatePicker(
                  selected: toDate,
                  onChanged: (value) {
                    toDate = value;
                    setState(() {

                    });

                  },
                ),
              ),
              const SizedBox(height: 30,),
              SizedBox(
                width: 300,
                child: Row(
                  children: [
                    Expanded(
                      child: Button(
                        onPressed: (){
                          Navigator.of(context).pop(false);
                        },
                        child: Text("Cancel"),
                      ),
                    ),
                    const SizedBox(width: 10,),
                    Expanded(
                      child: FilledButton(
                        onPressed:filter,
                        child: Text("Filter",style: FluentTheme.of(context).typography.bodyStrong!.copyWith(color: Colors.white),),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
