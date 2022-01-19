import 'dart:convert';

class Profile {
  String email;
  String? id;
  String? type;
  String? company;
  String? addressOne;
  String? addressTwo;
  String? city;
  String? county;
  String? postcode;
  String? country;
  String? phone;

  Profile({
    required this.email,
    this.type,
    this.company,
    this.addressOne,
    this.addressTwo,
    this.city,
    this.county,
    this.postcode,
    this.country,
    this.phone
  });

  factory Profile.fromJson(dynamic jsonData) {
    return Profile(
      email: jsonData['email'],
      type: jsonData['type'],
      company: jsonData['company'],
      addressOne: jsonData['addressOne'],
      addressTwo: jsonData['addressTwo'],
      city: jsonData['city'],
      county: jsonData['county'],
      postcode: jsonData['postcode'],
      country: jsonData['country'],
      phone: jsonData['phone'],
    );
  }

  setId(String? value) => id = value;
  setEmail(String value) => email = value;
  setType(String? value) => type = value;
  setCompany(String? value) => company = value;
  setAddressOne(String? value) => addressOne = value;
  setAddressTwo(String? value) => addressTwo = value;
  setCity(String? value) => city = value;
  setCounty(String? value) => county = value;
  setPostcode(String? value) => postcode = value;
  setCountry(String? value) => country = value;
  setPhone(String? value) => phone = value;

  Map<String, dynamic> get map {
    return {
      'email': email,
      'type': type,
      'company': company,
      'addressOne': addressOne,
      'addressTwo': addressTwo,
      'city': city,
      'county': county,
      'postcode': postcode,
      'country': country,
      'phone': phone,
    };
  }

  String get jsonData => json.encode(map);
}
