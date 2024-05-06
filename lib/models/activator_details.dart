class ActivatorDetails{
  final String activationCode;
  final DateTime activationDate;
  final DateTime expiredDate;
  final String deviceID;
  final String email;
  ActivatorDetails({
    required this.activationCode,
    required this.activationDate,
    required this.expiredDate,
    required this.deviceID,
    required this.email
  });

  Map<String, dynamic> toJson() {
    return {
      'activationCode': activationCode,
      'activationDate': activationDate,
      'expiredDate': expiredDate,
      'deviceID': deviceID,
      'email': email
    };
  }
  static ActivatorDetails fromJson(Map<String, dynamic> json) {
    return ActivatorDetails(
      activationCode: json['activationCode'],
      activationDate: json['activationDate'],
      expiredDate: json['expiredDate'],
      deviceID: json['deviceID'],
      email: json['email']
    );
  }
}