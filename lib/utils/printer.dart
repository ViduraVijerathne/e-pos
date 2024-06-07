import 'dart:io';

import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart';
import 'package:point_of_sale/models/product.dart';
import 'package:point_of_sale/models/sales_profit_data_object.dart';
import 'package:point_of_sale/utils/app_data.dart';
import 'package:point_of_sale/widget/my_line_chart_widget.dart';

import '../models/invoice.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';

class Printer {
  double maxWidth = 47;

  Future<pw.Document> generateInvoice(Invoice invoice) async {
    // Load the TTF font
    Font shopNameFont = pw.Font.ttf(
        await rootBundle.load("assets/fonts/SegoeUIBoldItalic.ttf"));
    // final font = await fontFromAssetBundle('assets/fonts/NotoSansSinhala-Bold.ttf');
    const font = null;
    var myStyle = TextStyle(font: font, fontSize: 11);
    var titleStyle =
        TextStyle(font: font, fontSize: 10, fontWeight: FontWeight.bold);
    var shopAddressStyle =
        TextStyle(font: font, fontSize: 7, fontWeight: FontWeight.bold);
    var shopNameStyle = TextStyle(
        font: shopNameFont, fontSize: 15, fontWeight: FontWeight.bold);
    var invoiceDataStyle =
        TextStyle(font: font, fontSize: 7, fontWeight: FontWeight.bold);
    var tableTitleStyle =
        TextStyle(font: font, fontSize: 7, fontWeight: FontWeight.bold);
    var tableDataStyle =
        TextStyle(font: font, fontSize: 7, fontWeight: FontWeight.bold);
    var invoiceGrandTotalStyle =
        TextStyle(font: font, fontSize: 9, fontWeight: FontWeight.bold);
    final pdf = pw.Document(); // Create a new PDF document

    // Create the invoice page
    pdf.addPage(pw.Page(
      pageFormat: PdfPageFormat((maxWidth * PdfPageFormat.mm), double.infinity),
      margin: pw.EdgeInsets.only(left: 1, right: 1, top: 5, bottom: 20),
      build: (context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Container(
              height: 10,
              child: Text("-"),
            ),
            // pw.Center(child: pw.Text("INVOICE", style: titleStyle)),
            pw.SizedBox(height: 10),
            pw.Center(
                child: pw.Flexible(
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  pw.Text(AppData.shopName,
                      style: shopNameStyle, textAlign: TextAlign.center),
                  pw.SizedBox(height: 3),
                  pw.Text(AppData.shopAddress,
                      style: shopAddressStyle, textAlign: TextAlign.center),
                  pw.SizedBox(height: 1),
                  pw.Text("${AppData.shopContact1} / ${AppData.shopContact2}",
                      style: shopAddressStyle),
                ],
              ),
            )),
            pw.Divider(
              height: 1,
            ),
            pw.SizedBox(height: 2),
            pw.Text("Invoice No: ${invoice.id}", style: invoiceDataStyle),
            pw.Text("Date: ${convertDateTime(invoice.invoiceDate)}",
                style: invoiceDataStyle),
            pw.Text("Customer: ${invoice.customer.name}",
                style: invoiceDataStyle),
            pw.Text("Cashier :", style: invoiceDataStyle),
            pw.SizedBox(height: 2),
            pw.Container(
              padding: EdgeInsets.all(2),
              margin: EdgeInsets.all(1),
              decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.black, width: 0.5),
                  borderRadius: BorderRadius.circular(5)),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Flexible(
                    child: pw.Text("Qty",
                        style: tableTitleStyle, textAlign: TextAlign.center),
                    flex: 1,
                  ),
                  pw.Flexible(
                    child: pw.Text("Price",
                        style: tableTitleStyle, textAlign: TextAlign.center),
                    flex: 1,
                  ),
                  pw.Flexible(
                    child: pw.Text("Dis",
                        style: tableTitleStyle, textAlign: TextAlign.center),
                    flex: 1,
                  ),
                  pw.Flexible(
                    child: pw.Text("Val",
                        style: tableTitleStyle, textAlign: TextAlign.center),
                    flex: 1,
                  ),
                  pw.Flexible(
                    child: pw.Text("Total",
                        style: tableTitleStyle, textAlign: TextAlign.center),
                    flex: 1,
                  ),
                ],
              ),
            ),
            ...invoice.items.map((item) {
              return pw.Container(
                  padding: EdgeInsets.all(2),
                  margin: EdgeInsets.all(1),
                  decoration: pw.BoxDecoration(
                      // border: pw.Border.all( width: 0.1),
                      borderRadius: BorderRadius.circular(5)),
                  child: pw.Column(children: [
                    pw.Align(
                      alignment: pw.Alignment.centerLeft,
                      child: pw.Text("${item.product.name}",
                          style: tableDataStyle, textAlign: TextAlign.start),
                    ),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Flexible(
                          child: pw.Text("x${item.quantity}",
                              style: tableDataStyle,
                              textAlign: TextAlign.center),
                          flex: 1,
                        ),
                        pw.Flexible(
                          child: pw.Text("${item.unitPrice}",
                              style: tableDataStyle,
                              textAlign: TextAlign.center),
                          flex: 1,
                        ),
                        pw.Flexible(
                          child: pw.Text("${item.discount}",
                              style: tableDataStyle,
                              textAlign: TextAlign.center),
                          flex: 1,
                        ),
                        pw.Flexible(
                          child: pw.Text("${item.unitPrice - item.discount}",
                              style: tableDataStyle,
                              textAlign: TextAlign.center),
                          flex: 1,
                        ),
                        pw.Flexible(
                          child: pw.Text(
                              "${(item.unitPrice - item.discount) * item.quantity}",
                              style: tableTitleStyle,
                              textAlign: TextAlign.center),
                          flex: 1,
                        ),
                      ],
                    ),
                    pw.SizedBox(height: 1),
                  ]));
            }).toList(),
            pw.SizedBox(height: 2),
            pw.Divider(
                height: 1,
                thickness: 1,
                color: PdfColors.black,
                borderStyle: BorderStyle.dashed),
            pw.SizedBox(height: 5),
            pw.Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text("No. of Items:", style: invoiceDataStyle),
                  pw.Text("  ${invoice.items.length}", style: invoiceDataStyle),
                ]),
            pw.Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text("Total:", style: invoiceDataStyle),
                  pw.Text("  ${invoice.grandTotal}", style: invoiceDataStyle),
                ]),
            pw.Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text("Discounts:", style: invoiceDataStyle),
                  pw.Text("  ${invoice.discountTotal}",
                      style: invoiceDataStyle),
                ]),
            SizedBox(height: 5),
            pw.Divider(
                height: 1,
                thickness: 1,
                color: PdfColors.black,
                borderStyle: BorderStyle.dashed),
            SizedBox(height: 5),
            pw.Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text("Grand Total:", style: invoiceGrandTotalStyle),
                  pw.Text("  ${invoice.invoiceTotal}",
                      style: invoiceGrandTotalStyle),
                ]),
            SizedBox(height: 5),

            pw.Divider(
                height: 1,
                thickness: 1,
                color: PdfColors.black,
                borderStyle: BorderStyle.dashed),
            // SizedBox(height: 5),
            // pw.Divider(height: 1, thickness: 1, color: PdfColors.black),
            SizedBox(height: 10),
            pw.Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                      invoice.paidAmount > 0 ? "Cash Paid:" : "CARD PAYMENT",
                      style: invoiceDataStyle),
                  pw.Text(
                      "  ${invoice.paidAmount > 0 ? invoice.paidAmount : ""}",
                      style: invoiceDataStyle),
                ]),
            invoice.paidAmount > 0
                ? pw.Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                        pw.Text("Balance:", style: invoiceDataStyle),
                        pw.Text("  ${invoice.balance}",
                            style: invoiceDataStyle),
                      ])
                : SizedBox(),
            pw.SizedBox(height: 10),
            pw.Divider(
                height: 1,
                thickness: 1,
                color: PdfColors.black,
                borderStyle: BorderStyle.dashed),
            pw.SizedBox(height: 5),
            pw.Align(
              alignment: Alignment.center,
              child: pw.Text("Thank You Come Again ", style: tableDataStyle),
            ),
            pw.SizedBox(height: 5),
            pw.Divider(
                height: 1,
                thickness: 1,
                color: PdfColors.black,
                borderStyle: BorderStyle.dashed),
            SizedBox(height: 10),
            pw.Align(
              alignment: Alignment.center,
              child: pw.Text("Software by Andromeda ", style: tableDataStyle),
            ),
            pw.Align(
              alignment: Alignment.center,
              child: pw.Text("+94 75 264 0269 / +94 75 907 9213",
                  style: tableDataStyle),
            ),
            pw.SizedBox(height: 50),
            pw.Divider(height: 1, thickness: 1, color: PdfColors.black),
          ],
        );
      },
    ));
    return pdf;
  }

  // Function to get or create the "invoice" directory
  Future<Directory> getOrCreateInvoiceDirectory() async {
    // Get the app's documents directory
    final directory = await getApplicationDocumentsDirectory();

    // Define the path for the "invoice" directory
    final invoiceDirectoryPath =
        '${directory.path}\\${AppData().appName}\\invoices';

    // Create the directory if it doesn't exist
    final invoiceDirectory = Directory(invoiceDirectoryPath);
    if (!(await invoiceDirectory.exists())) {
      await invoiceDirectory.create(recursive: true); // Create the directory
    }

    return invoiceDirectory; // Return the created or existing directory
  }

  static Future<Directory> getOrCreateSalesProfitDirectory() async {
    // Get the app's documents directory
    final directory = await getApplicationDocumentsDirectory();

    // Define the path for the "invoice" directory
    final invoiceDirectoryPath =
        '${directory.path}\\${AppData().appName}\\reports';

    // Create the directory if it doesn't exist
    final invoiceDirectory = Directory(invoiceDirectoryPath);
    if (!(await invoiceDirectory.exists())) {
      print("CREATING PATH ${invoiceDirectoryPath}");
      await invoiceDirectory.create(recursive: true); // Create the directory
    }

    return invoiceDirectory; // Return the created or existing directory
  }

  Future<File> savePdfAndPrint(pw.Document pdf, String fileName) async {
    final directory =
        await getApplicationDocumentsDirectory(); // Get the app's documents directory
    final path = '${directory.path}\\invoices\\$fileName';
    final file = File(path); // Define the path and filename
    await file
        .writeAsBytes(await pdf.save()); // Save the PDF content to the file

    //Print file
    final command = 'print /d:default $path';
    ProcessResult result = await Process.run('cmd', ['/c', command]);
    print(command);
    print("Result: ${result.stdout}");
    print("EXISTING CODE ${result.exitCode}");
    return file; // Return the saved file
  }

  static Future<void> printInvoice(Invoice invoice) async {
    // final doc = await Printer().generateInvoice(invoice);
    // await Printing.layoutPdf(
    //     onLayout: (PdfPageFormat format) async => doc.save());

    final doc = await Printer().generateInvoice(invoice);
    final bytes = await doc.save();

    // Get the default printer
    final printers = await Printing.listPrinters();
    if (printers.isNotEmpty) {
      // Select the first available printer
      final printer = printers.first;

      await Printing.directPrintPdf(
        onLayout: (PdfPageFormat format) async => bytes,
        printer: printer,
      );
    } else {
      print('No printers available');
    }

    // await Printer().getOrCreateInvoiceDirectory();
    // String fileName = "invoice_${invoice.id}.pdf";
    // // final file = await Printer().savePdfAndPrint(pdf, fileName);
    // await Printing.layoutPdf(
    //   onLayout: (PdfPageFormat format) async => pdf.save(),
    // );
  }

  static Future<void> printProductSalesProfitReport({
    required Product product,
    required,
    required InsightModes mode,
    required List<SalesProfitSataObject> data,
    required DateTime maxDate,
    required double maxValue,
    required DateTime minDate,
    required double minValue,
    required double total,
  }) async {
// Load the TTF font
    Font font = pw.Font.ttf(await rootBundle.load("assets/fonts/OpenSans.ttf"));

    var myStyle = pw.TextStyle(font: font, fontSize: 11);
    var titleStyle =
        pw.TextStyle(font: font, fontSize: 15, fontWeight: pw.FontWeight.bold);
    var sectionTitleStyle =
        pw.TextStyle(font: font, fontSize: 13, fontWeight: pw.FontWeight.bold);
    var dataStyle = pw.TextStyle(font: font, fontSize: 11);

    final pdf = pw.Document(); // Create a new PDF document

// Create the sales and profit report page
    pdf.addPage(pw.Page(
// pageFormat: PdfPageFormat.a4,
      pageFormat: PdfPageFormat(
          (Printer().maxWidth * PdfPageFormat.mm), double.infinity),
      margin: pw.EdgeInsets.all(5),
      build: (context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Align(
              alignment: Alignment.center,
              child: pw.Text("Product ${mode.name} Report",
                  style: titleStyle, textAlign: TextAlign.center),
            ),
            pw.SizedBox(height: 10),
            pw.Text("Product: ${product.name}", style: sectionTitleStyle),
            pw.Text("Start Date: ${minDate.toIso8601String().split('T').first}",
                style: dataStyle),
            pw.Text("End Date: ${maxDate.toIso8601String().split('T').first}",
                style: dataStyle),
            pw.SizedBox(height: 20),
            pw.Text(
                "Total ${mode.name}: ${mode == InsightModes.profit ? "LKR " : ""} ${total.toStringAsFixed(2)} ${mode == InsightModes.profit ? "" : product.unit.name}",
                style: dataStyle),
            pw.SizedBox(height: 20),
            pw.Text("${mode.name} Over Time", style: sectionTitleStyle),
            pw.SizedBox(height: 10),
            pw.Table.fromTextArray(
              context: context,
              headers: [
                "Date",
                mode.name,
              ],
              data: data.map((item) {
                return [
                  convertDate(item.date),
                  "${mode == InsightModes.profit ? "LKR " : ""}${item.value.toStringAsFixed(2)} ${mode == InsightModes.profit ? "" : product.unit.name}",
                ];
              }).toList(),
              cellStyle: myStyle,
              headerStyle: sectionTitleStyle,
              headerDecoration: pw.BoxDecoration(color: PdfColors.grey300),
              cellAlignment: pw.Alignment.center,
              headerAlignment: pw.Alignment.center,
            ),
            pw.SizedBox(height: 20),
            pw.Text("PRINTED DATE : ${convertDateTime(DateTime.now())}",
                style: dataStyle)
          ],
        );
      },
    ));

    final directory = await getOrCreateSalesProfitDirectory();
    final path =
        '${directory.path}\\${DateTime.now().toIso8601String().replaceAll(":", "_")}_${mode.name}_report.pdf';
    final file = File(path); // Define the path and filename
    await file
        .writeAsBytes(await pdf.save()); // Save the PDF content to the file

// Print file
    final command = 'print /d:default $path';
    ProcessResult result = await Process.run('cmd', ['/c', command]);
    print(command);
    print("Result: ${result.stdout}");
    print("EXISTING CODE ${result.exitCode}");
  }

  static void printBarcode(String code, int qty) async {
// Create a Barcode instance
    final barcode = Barcode.code128();

// Generate the barcode SVG
    final svg = barcode.toSvg(
      code,
      width: 200,
      height: 80,
      drawText: true,
    );

// Create a new PDF document
    final pdf = pw.Document();

// Add the barcode to the PDF
    pdf.addPage(pw.Page(
      pageFormat: PdfPageFormat(( 47* PdfPageFormat.mm), double.infinity),
      build: (context) {
        return pw.Column(
          children: List.generate(qty, (index) {
            return pw.Container(
              padding: const pw.EdgeInsets.all(10),
              child: pw.Column(
                children: [
                  pw.SvgImage(svg: svg, width: 200, height: 80),
                  pw.SizedBox(height: 10),
                  pw.Text(code, style: pw.TextStyle(fontSize: 12)),
                  pw.Divider(),
                ],
              ),
            );
          }),
        );
      },
    ));

// Save and print the PDF
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/barcode_${code}_$qty.pdf';
    final file = File(path);
    await file.writeAsBytes(await pdf.save());

// Print the PDF
//     await Printing.layoutPdf(
//       onLayout: (PdfPageFormat format) async => pdf.save(),
//     );
// Get the default printer
    final printers = await Printing.listPrinters();
    if (printers.isNotEmpty) {
// Select the first available printer
      final printer = printers.first;

      await Printing.directPrintPdf(
        onLayout: (PdfPageFormat format) async => pdf.save(),
        printer: printer,
      );
    } else {
      print('No printers available');
    }
  }

  static String convertDate(DateTime date) =>
      "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  static String convertDateTime(DateTime dateTime) =>
      "${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} ${dateTime.hour == 0 ? 12 : dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour}.${dateTime.minute.toString().padLeft(2, '0')} ${dateTime.hour < 12 ? 'AM' : 'PM'}";
}
