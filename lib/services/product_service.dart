//************************************************************
//
//
// Copyright 2022 Roma Technology Limited, All rights reserved
//
//************************************************************

import 'package:revup/classes/product_service_exception.dart';
import 'concrete/zoho_inventory_product_service.dart';

abstract class ProductService {
  final String serviceName;
  final String serviceApiUrl;

  ProductService({
    required this.serviceName,
    required this.serviceApiUrl,
  });

  factory ProductService.fromMap(Map<String, dynamic> map) {
    if (map['serviceName'] != null) {
      switch (map['serviceName'].toLowerCase()) {
        case 'zoho inventory':
          return ZohoInventoryProductService.fromMap(map);
      }
    }
    throw ProductServiceException('Encountered invalid Product service definition data');
  }

  Map<String, dynamic> get map;
}
