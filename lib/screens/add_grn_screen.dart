import 'package:fluent_ui/fluent_ui.dart';
import 'package:point_of_sale/models/stock.dart';
import 'package:point_of_sale/models/supplier.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';

import '../models/grn.dart';
import '../models/product.dart';
import '../utils/barcodeGenerator.dart';

class AddGRNScreen extends StatefulWidget {
  final GRN? grn;

  const AddGRNScreen({super.key, this.grn});

  @override
  State<AddGRNScreen> createState() => _AddGRNScreenState();
}

class _AddGRNScreenState extends State<AddGRNScreen> {
  List<Product> products = [];
  List<Supplier> suppliers = [];

  final TextEditingController _idController = TextEditingController();
  final TextEditingController _barcodeController = TextEditingController();
  final TextEditingController _productController = TextEditingController();
  final TextEditingController _supplierController = TextEditingController();

  final TextEditingController _valueController = TextEditingController();
  final TextEditingController _douedController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  double _quantityController = 0;
  double _wholesaleController = 0;
  double _retailController = 0;
  double _paidController = 0;
  double _doeAmount = 0;
  double _grnValue = 0;
  double _defaultDiscount = 0;

  DateTime mnfDate = DateTime.now();
  DateTime expDate = DateTime.now();

  Supplier? selectedSupplier;
  Product? selectedProduct;

  void loadProducts() async {
    products = await Product.getAll();
    if (mounted) {
      setState(() {});
    }
  }

  void loadSuppliers() async {
    suppliers = await Supplier.getAll();
    if (mounted) {
      setState(() {});
    }
  }

  Future<int> showContentBarcodeDialog(BuildContext context) async {
    int? result = await showDialog<int>(
      context: context,
      builder: (context) => ContentDialog(
        constraints: const BoxConstraints(minWidth: 500, maxWidth: 700),
        title: const Text('Warning ! '),
        content: const Text(
          'GRN Barcode is empty! Do You need ,',
        ),
        actions: [
          FilledButton(
            child: const Text('Generate Random Barcode'),
            onPressed: () => Navigator.pop(context, 1),
          ),
          FilledButton(
            child: const Text('Cansel'),
            onPressed: () => Navigator.pop(context, 2),
          ),
        ],
      ),
    );
    if (result != null && result == 1) {
      _barcodeController.text = BarcodeGenerator.generateRandomGRNBarcode();
    }
    setState(() {});

    if (result != null) {
      return result;
    } else {
      return 2;
    }
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

  Future<bool> isValidGRN() async {
    if (_barcodeController.text.isEmpty) {
      int result = await showContentBarcodeDialog(context);
      if (result != 1) {
        showMessageBox(
            "Error", "Please Add GRN Barcode", InfoBarSeverity.error);
        return false;
      }
    }
    if (selectedProduct == null) {
      showMessageBox("Error", "Please Select Product", InfoBarSeverity.error);
      return false;
    }
    if (selectedSupplier == null) {
      showMessageBox("Error", "Please Select Supplier", InfoBarSeverity.error);
      return false;
    }

    if (_quantityController == 0) {
      showMessageBox("Error", "Please Enter Quantity", InfoBarSeverity.error);
      return false;
    }

    if (_wholesaleController == 0) {
      showMessageBox(
          "Error", "Please Enter Wholesale Price", InfoBarSeverity.error);
      return false;
    }

    if (_retailController == 0) {
      showMessageBox(
          "Error", "Please Enter Retail Price", InfoBarSeverity.error);
      return false;
    }

    return true;
  }

  void calculateGRN() {
    _grnValue = _wholesaleController * _quantityController;
    _doeAmount = _grnValue - _paidController;
    _valueController.text = _grnValue.toString();
    _douedController.text = _doeAmount.toString();
    setState(() {});
  }

  void clear() {
    _idController.clear();
    _barcodeController.clear();
    _productController.clear();
    _supplierController.clear();
    _valueController.clear();
    _douedController.clear();
    _descriptionController.clear();
    _quantityController = 0;
    _wholesaleController = 0;
    _retailController = 0;
    _paidController = 0;
    _doeAmount = 0;
    _grnValue = 0;
    selectedSupplier = null;
    selectedProduct = null;
    setState(() {});
  }

  Future<void> addStock(GRN grn) async {
    Stock stock = Stock(
        id: 0,
        barcode: await BarcodeGenerator.generateRandomStockBarcode(),
        availbleQty: grn.quantity,
        retailPrice: grn.retailPrice,
        wholesalePrice: grn.wholesalePrice,
        mnf_date: grn.mnfDate,
        exp_date: grn.expDate,
        product: grn.product,
        grn: grn,
        defaultDiscount: _defaultDiscount);

    await stock.insert();
    clear();
  }

  void addGRN() async {
    if (await isValidGRN()) {
      calculateGRN();
      GRN grn = GRN(
        id: 0,
        barcode: _barcodeController.text,
        product: selectedProduct!,
        supplier: selectedSupplier!,
        quantity: _quantityController,
        wholesalePrice: _wholesaleController,
        retailPrice: _retailController,
        paidAmount: _paidController,
        douedAmount: _doeAmount,
        description: _descriptionController.text,
        value: _grnValue,
        grnDate: DateTime.now(),
        mnfDate: mnfDate,
        expDate: expDate,
      );
      try {
        int grnID = await grn.insert();
        grn.id = grnID;
        await addStock(grn);
        showMessageBox(
            "Success", "GRN Added Successfully", InfoBarSeverity.success);
      } catch (ex) {
        showMessageBox("Opps!", "Something went wrong! \n ${ex.toString()} ",
            InfoBarSeverity.error);
      }
    }
  }

  void updateGRN() {}

  @override
  void initState() {
    loadProducts();
    loadSuppliers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      header: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.only(left: 20, bottom: 30),
        child: Row(
          children: [
            widget.grn == null
                ? SizedBox()
                : IconButton(
                    icon: Icon(FluentIcons.back),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
            Text(
              widget.grn == null ? "Add New GRN" : "Update GRN",
              style: FluentTheme.of(context).typography.title,
            ),
          ],
        ),
      ),
      content: ResponsiveGridList(
        minItemWidth: 300,
        children: [
          InfoLabel(
            label: "GRN ID",
            child: TextBox(
              controller: _idController,
              enabled: false,
              placeholder: "GRN ID Generate Automatic",
            ),
          ),
          InfoLabel(
            label: "Barcode",
            child: TextBox(
              enabled: false,
              controller: _barcodeController,
              placeholder: "Barcode",
            ),
          ),
          InfoLabel(
            label: "Product",
            child: SizedBox(
              height: 32,
              child: AutoSuggestBox<Product>(
                controller: _productController,
                onSelected: (value) {
                  selectedProduct = value.value;
                },
                items: products
                    .map((e) => AutoSuggestBoxItem<Product>(
                          value: e,
                          label: "${e.barcode} : ${e.name}",
                        ))
                    .toList(),
              ),
            ),
          ),
          InfoLabel(
            label: "Supplier",
            child: SizedBox(
              height: 32,
              child: AutoSuggestBox<Supplier>(
                controller: _supplierController,
                onSelected: (value) {
                  selectedSupplier = value.value;
                },
                items: suppliers
                    .map((e) => AutoSuggestBoxItem<Supplier>(
                          value: e,
                          label: "${e.email} : ${e.name}",
                        ))
                    .toList(),
              ),
            ),
          ),
          InfoLabel(
            label: "Quantity",
            child: NumberBox<double>(
              value: _quantityController,
              placeholder: "Quantity",
              onChanged: (double? value) {
                if (value != null) {
                  _quantityController = value;
                } else {
                  _quantityController = 0;
                }
                calculateGRN();
                setState(() {});
              },
            ),
          ),
          InfoLabel(
            label: "Wholesale Price",
            child: NumberBox<double>(
              value: _wholesaleController,
              placeholder: "WholeSale Price ",
              onChanged: (double? value) {
                if (value != null) {
                  _wholesaleController = value;
                } else {
                  _wholesaleController = 0;
                }
                calculateGRN();
                setState(() {});
              },
            ),
          ),
          InfoLabel(
            label: "Retail Price",
            child: NumberBox<double>(
              value: _retailController,
              placeholder: "Retail Price ",
              onChanged: (double? value) {
                if (value != null) {
                  _retailController = value;
                } else {
                  _retailController = 0;
                }
                calculateGRN();
                setState(() {});
              },
            ),
          ),
          InfoLabel(
            label: "Default Discount For Selling",
            child: NumberBox<double>(
              value: _defaultDiscount,
              placeholder: "Discount (LKR) ",
              onChanged: (double? value) {
                if (value != null) {
                  _defaultDiscount = value;
                } else {
                  _defaultDiscount = 0;
                }
                setState(() {});
              },
            ),
          ),
          InfoLabel(
            label: "GRN Value",
            child: TextBox(
              controller: _valueController,
              placeholder: "GRN Value",
              enabled: false,
            ),
          ),
          InfoLabel(
            label: "Paid Amount",
            child: NumberBox<double>(
              value: _paidController,
              placeholder: "Paid Amount",
              onChanged: (double? value) {
                if (value != null) {
                  _paidController = value;
                } else {
                  _paidController = 0;
                }
                calculateGRN();
                setState(() {});
              },
            ),
          ),
          InfoLabel(
            label: "Due Amount",
            child: TextBox(
              controller: _douedController,
              placeholder: "Due Amount",
              enabled: false,
            ),
          ),
          InfoLabel(
            label: "Manufacture Date",
            child: DatePicker(
              selected: mnfDate,
              onChanged: (value) {
                mnfDate = value;
                if (mounted) {
                  setState(() {});
                }
              },
            ),
          ),
          InfoLabel(
            label: "Expire Date",
            child: DatePicker(
              selected: expDate,
              onChanged: (value) {
                expDate = value;
                setState(() {});
              },
            ),
          ),
          InfoLabel(
            label: "Description",
            child: TextBox(
              controller: _descriptionController,
              placeholder: "Description",
            ),
          ),
          FilledButton(
            child: Text(widget.grn == null ? "Add GRN" : "Update GRN"),
            onPressed: () {
              if (widget.grn == null) {
                addGRN();
              } else {
                updateGRN();
              }
            },
          )
        ],
      ),
    );
  }
}
