import 'package:fluent_ui/fluent_ui.dart';
import 'package:point_of_sale/models/main_category.dart';
import 'package:point_of_sale/models/product.dart';
import 'package:point_of_sale/utils/method_response.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';

import '../models/sub_category.dart';
import '../models/unit.dart';
import '../utils/barcodeGenerator.dart';

class AddProductScreen extends StatefulWidget {
  final bool isEditingMode;
  final Product? product;

  const AddProductScreen({super.key, this.isEditingMode = false, this.product});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  List<MainCategory> mainCategories = [
    MainCategory(id: 1, name: "Fruits"),
  ];
  List<SubCategory> subCategories = [];
  List<Unit> units = [];

  final TextEditingController _idController = TextEditingController();
  final TextEditingController _barcodeController = TextEditingController();
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _productSinhalaNameController =
      TextEditingController();
  final TextEditingController _productDescriptionController =
      TextEditingController();
  final TextEditingController _mainCategoryController = TextEditingController();
  final TextEditingController _subCategoryController = TextEditingController();
  final TextEditingController _unitController = TextEditingController();

  MainCategory? selectedMainCategory;
  SubCategory? selectedSubCategory;
  Unit? selectedUnit;

  String selectedMainCategoryStr = "";
  String selectedSubCategoryStr = "";
  String selectedUnitStr = "";

  bool isLoading = false;

  Future<int> showContentBarcodeDialog(BuildContext context) async {
    int? result = await showDialog<int>(
      context: context,
      builder: (context) => ContentDialog(
        constraints: const BoxConstraints(minWidth: 500, maxWidth: 700),
        title: const Text('Warning ! '),
        content: const Text(
          'Product Barcode is empty! Do You need ,',
        ),
        actions: [
          Button(
            child: const Text('Continue Without Barcode'),
            onPressed: () {
              Navigator.pop(context, 0);
              // Delete file here
            },
          ),
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
      _barcodeController.text = BarcodeGenerator.generateRandomProductBarcode();
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

  Future<bool> showContentAddMainCatDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => ContentDialog(
        title: const Text('Warning ! '),
        content: Text(
          '${selectedMainCategoryStr} Main Category does not exist. Do You need  ,',
        ),
        actions: [
          Button(
            child: const Text('Cansel'),
            onPressed: () {
              Navigator.pop(context, false);
              // Delete file here
            },
          ),
          FilledButton(
            child: const Text('Register As New '),
            onPressed: () async {
              MainCategory mainCat =
                  MainCategory(id: 0, name: selectedMainCategoryStr);
              try {
                await mainCat.insert();
                showMessageBox(
                    "Success !",
                    "Main Category Inserted Successfully",
                    InfoBarSeverity.success);
                loadMainCat();
                Navigator.pop(context, true);
              } catch (ex) {
                print(ex);
                showMessageBox("Error !", "Error While Inserting Main Category",
                    InfoBarSeverity.error);
                Navigator.pop(context, false);
              }
            },
          ),
        ],
      ),
    );
    setState(() {});
    if (result == null) return false;
    return result;
  }

  Future<bool> showContentAddSubCatDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => ContentDialog(
        title: const Text('Warning ! '),
        content: Text(
          '${selectedSubCategoryStr} Sub category does not exist. Do You need  ,',
        ),
        actions: [
          Button(
            child: const Text('Cansel'),
            onPressed: () {
              Navigator.pop(context, false);
              // Delete file here
            },
          ),
          FilledButton(
            child: const Text('Register As New '),
            onPressed: () async {
              SubCategory subCat =
                  SubCategory(id: 0, name: selectedSubCategoryStr);
              try {
                await subCat.insert();
                showMessageBox(
                    "Success !",
                    "Sub Category Inserted Successfully",
                    InfoBarSeverity.success);
                loadSubCat();
                Navigator.pop(context, true);
              } catch (ex) {
                print(ex);
                showMessageBox("Error !", "Error While Inserting Sub Category",
                    InfoBarSeverity.error);
                Navigator.pop(context, false);
              }
            },
          ),
        ],
      ),
    );
    setState(() {});
    if (result == null) return false;
    return result;
  }

  Future<bool> showContentAddUnitDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => ContentDialog(
        title: const Text('Warning ! '),
        content: Text(
          '${selectedUnitStr} Unit does not exist. Do You need  ,',
        ),
        actions: [
          Button(
            child: const Text('Cansel'),
            onPressed: () {
              Navigator.pop(context, false);
              // Delete file here
            },
          ),
          FilledButton(
            child: const Text('Register As New '),
            onPressed: () async {
              Unit unit = Unit(id: 0, name: selectedUnitStr);
              try {
                await unit.insert();
                showMessageBox("Success !", "unit Inserted Successfully",
                    InfoBarSeverity.success);
                loadUnit();
                Navigator.pop(context, true);
              } catch (ex) {
                print(ex);
                showMessageBox("Error !", "Error While Inserting unit",
                    InfoBarSeverity.error);
                Navigator.pop(context, false);
              }
            },
          ),
        ],
      ),
    );
    setState(() {});
    if (result == null) return false;
    return result;
  }

  Future<bool> validateProduct() async {
    if (_barcodeController.text.isEmpty) {
      int result = await showContentBarcodeDialog(context);
      if (result == 2) {
        showMessageBox("Warning !", "User Cansel Process For Add Barcode ",
            InfoBarSeverity.warning);
        return false;
      }
    }
    if (_productNameController.text.isEmpty) {
      showMessageBox(
          "Error !", "Please Enter Product Name", InfoBarSeverity.error);
      return false;
    }
    if (_productSinhalaNameController.text.isEmpty) {
      showMessageBox("Error !", "Please Enter Product Sinhala Name",
          InfoBarSeverity.error);
      return false;
    }
    if (selectedMainCategory == null) {
      if (selectedMainCategoryStr.isEmpty) {
        showMessageBox(
            "Error !", "Please Select Main Category", InfoBarSeverity.error);
        return false;
      } else {
        for (MainCategory maincat in mainCategories) {
          if (maincat.name.toLowerCase() ==
              selectedMainCategoryStr.toLowerCase()) {
            selectedMainCategory = maincat;
            break;
          }
        }

        if (selectedMainCategory == null) {
          bool result = await showContentAddMainCatDialog();
          if (!result) {
            return false;
          }
        }
      }
    }
    if (selectedSubCategory == null) {
      if (selectedSubCategoryStr.isEmpty) {
        showMessageBox(
            "Error !", "Please Select Sub Category", InfoBarSeverity.error);
        return false;
      } else {
        for (SubCategory subcat in subCategories) {
          if (subcat.name.toLowerCase() ==
              selectedSubCategoryStr.toLowerCase()) {
            selectedSubCategory = subcat;
            break;
          }
        }

        if (selectedSubCategory == null) {
          bool result = await showContentAddSubCatDialog();
          if (!result) {
            return false;
          }
        }
      }
    }
    if (selectedUnit == null) {
      if (selectedUnitStr.isEmpty) {
        showMessageBox("Error !", "Please Select Unit", InfoBarSeverity.error);
        return false;
      } else {
        for (Unit unit in units) {
          if (unit.name.toLowerCase() == selectedSubCategoryStr.toLowerCase()) {
            selectedUnit = unit;
            break;
          }
        }

        if (selectedUnit == null) {
          bool result = await showContentAddUnitDialog();
          if (!result) {
            return false;
          }
        }
      }
    }
    return true;
  }

  void updateProduct()async {
    setState(() {
      isLoading = true;
    });
    bool validation = await validateProduct();
    if (validation) {
      Product product = Product(
          id: widget.product!.id,
          barcode: _barcodeController.text,
          name: _productNameController.text,
          siName: _productSinhalaNameController.text,
          description: _productDescriptionController.text,
          mainCategory: selectedMainCategory!,
          subCategory: selectedSubCategory!,
          unit: selectedUnit!);
      try {
        await product.update();
        showMessageBox("Success !", "Product Updated Successfully",
            InfoBarSeverity.success);
        refreshFields();
        Navigator.pop(context);
      } catch (ex) {
        print(ex);
        // showMessageBox("Error !", "Error While  Product",
        //     InfoBarSeverity.error);
      }
    } else {
      showMessageBox(
          "Error", "Error Inserting new Product", InfoBarSeverity.error);
    }

    setState(() {
      isLoading = false;
    });
  }

  void addProduct() async {
    setState(() {
      isLoading = true;
    });
    bool validation = await validateProduct();
    if (validation) {
      Product product = Product(
          id: 0,
          barcode: _barcodeController.text,
          name: _productNameController.text,
          siName: _productSinhalaNameController.text,
          description: _productDescriptionController.text,
          mainCategory: selectedMainCategory!,
          subCategory: selectedSubCategory!,
          unit: selectedUnit!);
      try {
        await product.insert();
        showMessageBox("Success !", "Product Inserted Successfully",
            InfoBarSeverity.success);
        refreshFields();
      } catch (ex) {
        print(ex);
        showMessageBox("Error !", "Error While Inserting new Product",
            InfoBarSeverity.error);
      }
    } else {
      showMessageBox(
          "Error", "Error Inserting new Product", InfoBarSeverity.error);
    }

    setState(() {
      isLoading = false;
    });
  }

  void loadMainCat() async {
    mainCategories = await MainCategory.getAll();
    if (mounted) {
      setState(() {});
    }
  }

  void loadSubCat() async {
    subCategories = await SubCategory.getAll();
    if (mounted) {
      setState(() {});
    }
  }

  void loadUnit() async {
    units = await Unit.getAll();
    if (mounted) {
      setState(() {});
    }
  }

  void refreshFields() {
    _barcodeController.text = "";
    _productNameController.text = "";
    _productSinhalaNameController.text = "";
    _productDescriptionController.text = "";
    selectedMainCategory = null;
    selectedSubCategory = null;
    selectedUnit = null;
    selectedMainCategoryStr = "";
    selectedSubCategoryStr = "";
    selectedUnitStr = "";
    _mainCategoryController.text = "";
    _subCategoryController.text = "";
    _unitController.text = "";
    setState(() {});
  }

  void loadProductToUpdate() {
    if (widget.product != null) {
      _idController.text = "${widget.product!.id}";
      _barcodeController.text = widget.product!.barcode;
      _productNameController.text = widget.product!.name;
      _productSinhalaNameController.text = widget.product!.siName;
      _productDescriptionController.text = widget.product!.description;
      selectedMainCategory = widget.product!.mainCategory;
      selectedSubCategory = widget.product!.subCategory;
      selectedUnit = widget.product!.unit;
      _mainCategoryController.text = widget.product!.mainCategory.name;
      _subCategoryController.text = widget.product!.subCategory.name;
      _unitController.text = widget.product!.unit.name;
      setState(() {});
    }
  }

  @override
  void initState() {
    loadUnit();
    loadMainCat();
    loadSubCat();
    if (widget.product != null) {
      loadProductToUpdate();
    }
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
            widget.product == null
                ? SizedBox()
                : IconButton(
                    icon: Icon(FluentIcons.back),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
            Text(
              widget.product == null ? "Add New Product" : "Update Product",
              style: FluentTheme.of(context).typography.title,
            ),
          ],
        ),
      ),
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ResponsiveGridList(
          minItemWidth: 300,
          children: [
            InfoLabel(
              label: "Product ID",
              labelStyle: FluentTheme.of(context).typography.bodyStrong,
              child: TextBox(

                controller: _idController,
                enabled: false,
                placeholder: "Product ID Generate Automatic",
              ),
            ),
            InfoLabel(
              label: "Barcode",
              labelStyle: FluentTheme.of(context).typography.bodyStrong,
              child: TextBox(
                controller: _barcodeController,
                placeholder: "Barcode",
              ),
            ),
            InfoLabel(
              label: "Product Name",
              labelStyle: FluentTheme.of(context).typography.bodyStrong,
              child: TextBox(
                controller: _productNameController,
                placeholder: "Product Name ",
              ),
            ),
            InfoLabel(
              label: "Product Sinhala Name",
              labelStyle: FluentTheme.of(context).typography.bodyStrong,
              child: TextBox(
                controller: _productSinhalaNameController,
                style: TextStyle(
                  fontFamily: 'NotoSansSinhala'
                ),
                placeholder: "Product Sinhala Name ",
              ),
            ),
            InfoLabel(
              label: "Product Description",
              labelStyle: FluentTheme.of(context).typography.bodyStrong,
              child: TextBox(
                controller: _productDescriptionController,
                placeholder: "Product Description",
              ),
            ),
            InfoLabel(
              label: "Main Category",
              child: SizedBox(
                height: 32,
                child: AutoSuggestBox<MainCategory>(
                  controller: _mainCategoryController,
                  onSelected: (value) {
                    selectedMainCategory = value.value;
                  },
                  onChanged: (text, reason) {
                    selectedMainCategoryStr = text;
                  },
                  items: mainCategories
                      .map((e) => AutoSuggestBoxItem<MainCategory>(
                          value: e, label: e.name))
                      .toList(),
                  placeholder: "Main Category",
                ),
              ),
            ),
            InfoLabel(
              label: "Sub Category",
              child: SizedBox(
                height: 32,
                child: AutoSuggestBox<SubCategory>(
                  controller: _subCategoryController,
                  onSelected: (value) {
                    selectedSubCategory = value.value;
                  },
                  onChanged: (text, reason) {
                    selectedSubCategoryStr = text;
                  },
                  items: subCategories
                      .map((e) => AutoSuggestBoxItem<SubCategory>(
                          value: e, label: e.name))
                      .toList(),
                  placeholder: "Sub Category",
                ),
              ),
            ),
            InfoLabel(
              label: "Unit",
              child: SizedBox(
                height: 32,
                child: AutoSuggestBox<Unit>(
                  controller: _unitController,
                  onSelected: (value) {
                    selectedUnit = value.value;
                  },
                  onChanged: (text, reason) {
                    selectedUnitStr = text;
                  },
                  items: units
                      .map((e) =>
                          AutoSuggestBoxItem<Unit>(value: e, label: e.name))
                      .toList(),
                  placeholder: "Select Product Unit",
                ),
              ),
            ),
            FilledButton(
                onPressed: isLoading ? () {} : widget.product == null? addProduct : updateProduct,
                child: isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: ProgressRing(
                          activeColor: Colors.white,
                        ))
                    : Text("Done",
                        style: FluentTheme.of(context)
                            .typography
                            .bodyStrong!
                            .copyWith(color: Colors.white)))
          ],
        ),
      ),
    );
  }
}
