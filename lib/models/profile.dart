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
    updated = DateTime.now();
    created = DateTime.now();
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

  void setFromMap(Map<String, dynamic> map) {
    licencedTo = map['licencedTo'] ?? '';
    name = map['name'] ?? '';
    email = map['email'];
    company = map['company'] ?? '';
    addressOne = map['addressOne'] ?? '';
    addressTwo = map['addressTwo'] ?? '';
    city = map['city'] ?? '';
    county = map['county'] ?? '';
    postcode = map['postcode'] ?? '';
    country = map['country'] ?? '';
    phone = map['phone'] ?? '';
    if (map['updated'] != null) {
      updated = map['updated'].toDate();
    } else {
      updated = DateTime.now();
    }
    if (map['created'] != null) {
      created = map['created'].toDate();
    }
  }

  setLicensedTo(String value) {
    licencedTo = value;
    updated = DateTime.now();
  }

  setName(String value) {
    name = value;
    updated = DateTime.now();
  }

  setId(String? value) {
    id = value;
    updated = DateTime.now();
  }

  setEmail(String value) {
    email = value;
    updated = DateTime.now();
  }

  setType(String value) {
    type = value;
    updated = DateTime.now();
  }

  setCompany(String value) {
    company = value;
    updated = DateTime.now();
  }

  setAddressOne(String value) {
    addressOne = value;
    updated = DateTime.now();
  }

  setAddressTwo(String value) {
    addressTwo = value;
    updated = DateTime.now();
  }

  setCity(String value) {
    city = value;
    updated = DateTime.now();
  }

  setCounty(String value) {
    county = value;
    updated = DateTime.now();
  }

  setPostcode(String value) {
    postcode = value;
    updated = DateTime.now();
  }

  setCountry(String value) {
    country = value;
    updated = DateTime.now();
  }

  setPhotoUrl(value) {
    photoUrl = value;
    updated = DateTime.now();
  }

  setPhone(String value) {
    phone = value;
    updated = DateTime.now();
  }

  setUpdated(DateTime value) {
    updated = value;
    updated = DateTime.now();
  }
}
