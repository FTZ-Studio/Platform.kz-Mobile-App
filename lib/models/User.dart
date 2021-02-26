import 'package:kz/models/Address.dart';

class User {
  final String name;
  final int id;
  final Address address;
  final String email;
  final String phone;
  final int status;

  User({this.name, this.id, this.address, this.email, this.phone, this.status});

  factory User.fromMap(Map<String, dynamic> map) {
    return new User(
      name: map['name'] as String,
      id: map['id'] as int,
      address: Address.fromMap(map['address']),
      email: map['email'] as String,
      phone: map['phone'] as String,
      status: map['status'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'name': this.name,
      'id': this.id,
      'address': this.address.toMap(),
      'email': this.email,
      'phone': this.phone,
      'status': this.status,
    } as Map<String, dynamic>;
  }
}