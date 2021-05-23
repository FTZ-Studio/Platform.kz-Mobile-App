class Address {
  int id;
  double latitude;
  double longitude;

  Address({this.id, this.latitude, this.longitude});

  factory Address.fromMap(Map<String, dynamic> map) {
    return new Address(
      id: int.parse(map['id']),
      latitude: double.parse(map['latitude']),
      longitude: double.parse(map['longitude']),
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'id': this.id,
      'lng': this.longitude,
      'lat': this.latitude,
    } as Map<String, dynamic>;
  }
}