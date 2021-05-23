
import 'package:kz/models/Put.dart';

class User extends Put {

  final String name;
  final int id;
  final String address;
  final String email;
  final String phone;
  final int status;
  String photo;
  final String vk;

  User({this.name, this.id, this.address, this.email, this.phone, this.status, String mess, int code, this.photo, this.vk}) : super(error: code, mess: mess, localError: false);

  factory User.fromMap(Map<String, dynamic> map) {
    return new User(
      name: map['name'] as String,
      id: int.parse(map['id']),
      address: map['address'] as String,
      email: map['email'] as String,
      phone: map['phone'] as String,
      status: int.parse(map['status']),
      code: map['code']??200,
      photo: map['photo'] as String,
      vk: map['vk'] as String
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'name': this.name,
      'id': this.id,
      'address': this.address,
      'email': this.email,
      'phone': this.phone,
      'status': this.status,
      'photo': this.photo,
      'vk':this.vk
    } as Map<String, dynamic>;
  }
}