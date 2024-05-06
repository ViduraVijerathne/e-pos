import 'dart:convert';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:point_of_sale/models/supplierBankAccountDetails.dart';
import 'package:point_of_sale/screens/add_supplier.dart';
import 'package:point_of_sale/screens/grn_screen.dart';

import '../models/grn.dart';
import '../models/supplier.dart';

class SupplierCard extends StatefulWidget {
  final Supplier supplier;
  final VoidCallback changeState;
  const SupplierCard({super.key,required this.supplier, required this.changeState});

  @override
  State<SupplierCard> createState() => _SupplierCardState();
}

class _SupplierCardState extends State<SupplierCard> {
  late SupplierBankAccountDetails bankAccountDetails;
  final leftFlex = 135.0;
  final rightFlex = 150.0;

  void loadSupplierBankAccountDetails(){
    bankAccountDetails = SupplierBankAccountDetails.fromJson(jsonDecode(widget.supplier.bankDetails));

  }
  @override
  void initState() {
    loadSupplierBankAccountDetails();
    super.initState();
  }

  void viewGRNs()async{

    List<GRN> supplierGRN = await GRN.getSupplierGRN(widget.supplier.id);
     Navigator.of(context).push(FluentDialogRoute(builder: (context) => GRNScreen(viewingGRNs: supplierGRN), context: context));

  }
  void updateSupplier()async{
    Supplier? result = await Navigator.of(context).push<Supplier>(FluentDialogRoute(builder: (context) => AddSupplierScreen(supplier: widget.supplier), context: context));
    if(result != null){
      print("pk");
      widget.supplier.email = result.email;
      widget.supplier.name = result.name;
      widget.supplier.contact = result.contact;
      widget.supplier.bankDetails = result.bankDetails;
    }
    loadSupplierBankAccountDetails();
    setState(() {

    });

    widget.changeState();
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
                "${widget.supplier.name}",
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
                    "${widget.supplier.contact}",
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
                  "Email",
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
                    "${widget.supplier.email}",
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
                    "${bankAccountDetails.SupplierAddress}",
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
                  "Bank  Name",
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
                    "${bankAccountDetails.SupplierBankName}",
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
                  "Bank Account Holder  Name",
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
                    "${bankAccountDetails.SupplierBankAccountHolderName}",
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
                  "Bank Account Branch",
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
                    "${bankAccountDetails.SupplierBankAccountBranch}",
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
                  "Bank Account Number",
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
                    "${bankAccountDetails.SupplierAccountNumber}",
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
                  "GRNs",
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
                    child: Text("View GRNs"),
                    onPressed: viewGRNs,
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
                    child: Text("Update Supplier"),
                    onPressed: updateSupplier,
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
