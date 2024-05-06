class SupplierBankAccountDetails{
  String SupplierAddress;
  String SupplierName;
  String SupplierPhone;
  String SupplierEmail;
  String SupplierBankName;
  String SupplierAccountNumber;
  String SupplierBankAccountBranch;
  String SupplierBankAccountHolderName;
  SupplierBankAccountDetails({
    required this.SupplierAddress,
    required this.SupplierName,
    required this.SupplierPhone,
    required this.SupplierEmail,
    required this.SupplierBankName,
    required this.SupplierAccountNumber,
    required this.SupplierBankAccountBranch,
    required this.SupplierBankAccountHolderName
  });

//   toJson Method

  Map<String, dynamic> toJson() {
    return {
      'SupplierAddress': SupplierAddress,
      'SupplierName': SupplierName,
      'SupplierPhone': SupplierPhone,
      'SupplierEmail': SupplierEmail,
      'SupplierBankName': SupplierBankName,
      'SupplierAccountNumber': SupplierAccountNumber,
      'SupplierBankAccountBranch': SupplierBankAccountBranch,
      'SupplierBankAccountHolderName': SupplierBankAccountHolderName,
    };
  }

//   fromJson Method
  static fromJson(Map<String, dynamic> json) {
    return SupplierBankAccountDetails(
      SupplierAddress: json['SupplierAddress'],
      SupplierName: json['SupplierName'],
      SupplierPhone: json['SupplierPhone'],
      SupplierEmail: json['SupplierEmail'],
      SupplierBankName: json['SupplierBankName'],
      SupplierAccountNumber: json['SupplierAccountNumber'],
      SupplierBankAccountBranch: json['SupplierBankAccountBranch'],
      SupplierBankAccountHolderName: json['SupplierBankAccountHolderName'],
    );

          }
}