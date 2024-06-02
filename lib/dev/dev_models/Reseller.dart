import 'package:firedart/firedart.dart';

class Reseller{
  static final CollectionReference _collectionReference = Firestore.instance.collection('resellers');
  String image;
  String email;
  String password;
  String name;
  String mobile;
  bool isActivated;
  Reseller({required this.email,required this.password,required this.name,required this.mobile,required this.isActivated,required this.image});

  // Converts a Reseller instance to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'name': name,
      'mobile': mobile,
      'isActivated': isActivated,
      'image':image,
    };
  }

  // Creates a Reseller instance from a JSON map.
  factory Reseller.fromJson(Map<String, dynamic> json) {
    return Reseller(
      email: json['email'],
      password: json['password'],
      name: json['name'],
      mobile: json['mobile'],
      isActivated: json['isActivated'],
      image: json['image']
    );
  }

  // Adds a Reseller instance to Firestore.
  Future<void> addReseller() async {
    await _collectionReference.document(email).set(toJson());
  }

  // Updates a Reseller instance in Firestore.
  Future<void> updateReseller() async {
    await _collectionReference.document(email).update(toJson());
  }

  // Retrieves a Reseller instance by email from Firestore.
  static Future<Reseller?> getByEmail(String email) async {
    try {
      Document document = await _collectionReference.document(email).get();
      return Reseller.fromJson(document.map);
    } catch (e) {
      print('Error getting reseller by email: $e');
      return null;
    }
  }

  // Retrieves all Reseller instances from Firestore.
  static Future<List<Reseller>> getAllResellers() async {
    try {
      List<Document> documents = await _collectionReference.get();
      return documents.map((doc) => Reseller.fromJson(doc.map)).toList();
    } catch (e) {
      print('Error getting all resellers: $e');
      return [];
    }
  }



}