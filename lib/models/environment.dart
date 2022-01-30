//************************************************************
//
//
// Copyright 2022 Roma Technology Limited, All rights reserved
//
//************************************************************

class Environment {
  String? contentfulSpaceId;
  String? contentfulAccessToken;

  Environment({this.contentfulSpaceId, this.contentfulAccessToken});

  factory Environment.fromMap(Map<String, dynamic> map) {
    return Environment(
      contentfulSpaceId: map['contentfulSpaceId'],
      contentfulAccessToken: map['contentfulAccessToken'],
    );
  }
}