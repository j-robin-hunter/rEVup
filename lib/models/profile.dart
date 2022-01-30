//************************************************************
//
//
// Copyright 2022 Roma Technology Limited, All rights reserved
//
//************************************************************

class Profile {
  String licencedTo;
  String email;
  String name;
  String type;
  String company;
  String addressOne;
  String addressTwo;
  String city;
  String county;
  String postcode;
  String country;
  String phone;
  String photoUrl;
  String? id;
  DateTime? created;
  DateTime? updated;

  Profile({
    this.licencedTo = '',
    this.email = '',
    this.name = '',
    this.type = '',
    this.company = '',
    this.addressOne = '',
    this.addressTwo = '',
    this.city = '',
    this.county = '',
    this.postcode = '',
    this.country = '',
    this.phone = '',
    this.photoUrl = '',
  }) {
    created = DateTime.now();
    updated = DateTime.now();
  }

  Map<String, dynamic> get map {
    return {
      'licencedTo': licencedTo,
      'email': email,
      'name': name,
      'type': type,
      'company': company,
      'addressOne': addressOne,
      'addressTwo': addressTwo,
      'city': city,
      'county': county,
      'postcode': postcode,
      'country': country,
      'phone': phone,
      'photoUrl': photoUrl,
      'created': created,
      'updated': updated,
    };
  }

  //String get jsonData => json.encode(map);

  void setFromMap(Map<String, dynamic> map) {
    setLicensedTo(map['licencedTo']);
    setName(map['name']);
    setEmail(map['email']);
    setType(map['type']);
    setCompany(map['company']);
    setAddressOne(map['addressOne']);
    setAddressTwo(map['addressTwo']);
    setCity(map['city']);
    setCounty(map['county']);
    setPostcode(map['postcode']);
    setCountry(map['country']);
    setPhone(map['phone']);
    setUpdated(map['updated'].toDate());
    created = map['created'].toDate();
  }

  setLicensedTo(String value) => licencedTo = value;

  setName(String value) => name = value;

  setId(String? value) => id = value;

  setEmail(String value) => email = value;

  setType(String value) => type = value;

  setCompany(String value) => company = value;

  setAddressOne(String value) => addressOne = value;

  setAddressTwo(String value) => addressTwo = value;

  setCity(String value) => city = value;

  setCounty(String value) => county = value;

  setPostcode(String value) => postcode = value;

  setCountry(String value) => country = value;

  setPhotoUrl(value) => photoUrl = value;

  setPhone(String value) => phone = value;

  setUpdated(DateTime value) => updated = value;
}
