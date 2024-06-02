import 'package:firedart/firedart.dart';

class Developer{
  static final CollectionReference _collectionReference = Firestore.instance.collection('developer');
  String name;
  String subTitle;
  String image;
  String email;
  String mobile;
  Developer({required this.name, required this.subTitle, required this.image,required this.email,required this.mobile});
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'subTitle': subTitle,
      'image': image,
      'email': email,
      'mobile':mobile,
    };
  }

  // Creates a Developer instance from a JSON map.
  factory Developer.fromJson(Map<String, dynamic> json) {
    return Developer(
      name: json['name'],
      subTitle: json['subTitle'],
      image: json['image'],
      email: json['email'],
      mobile: json['mobile'],
    );
  }

  Future<void> addDeveloper()async{
    await _collectionReference.document(email).set(toJson());
  }

  static Future<Developer>  getDev()async{
    Page<Document> docs = await _collectionReference.get();
    return Developer.fromJson(docs.first.map);
  }
}