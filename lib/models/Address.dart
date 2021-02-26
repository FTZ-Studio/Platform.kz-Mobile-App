class Address {
  int id;
  String country;
  String city;
  String street;
  String house;
  String door;

  Address({this.id, this.country, this.city, this.street, this.house, this.door});

  factory Address.fromMap(Map<String, dynamic> map) {
    return new Address(
      id: map['id'] as int,
      country: map['country'] as String,
      city: map['city'] as String,
      street: map['street'] as String,
      house: map['house'] as String,
      door: map['door'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'id': this.id,
      'country': this.country,
      'city': this.city,
      'street': this.street,
      'house': this.house,
      'door': this.door,
    } as Map<String, dynamic>;
  }
}