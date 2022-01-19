import 'dart:convert';

import 'package:http/http.dart';
import 'package:revup/models/cms_content.dart';

class CmsService {
  final Map<String, CmsContent> _cmsContent = {};

  Future<Map<String, CmsContent>> cmsContent() async {
    if (_cmsContent.isEmpty) {
      final response = await get(
        Uri.parse(
            'https://cdn.contentful.com/spaces/vj0f9iibytzf/environments/master/entries?access_token=eb9b86cbc1e5d0a4e846eac796abbc62b21b1f740b7f2dc7e48bb03569f9b4a3&content_type=appContent&fields.appName=revup'),
      );

      if (response.statusCode == 200) {
        try {
          var jsonResponse = jsonDecode(response.body);
          for (var i = 0; i < jsonResponse['total']; i++) {
            CmsContent cmsContent = CmsContent(
                jsonResponse['items'][i]['fields']['contentName'],
                jsonResponse['items'][i]['fields']['title'],
                jsonResponse['items'][i]['fields']['textContent'],
                'https:${jsonResponse['includes']['Asset'][i]['fields']['file']['url']}',
                jsonResponse['items'][i]['fields']['test']);
            _cmsContent[cmsContent.contentName] = cmsContent;
          }
        } catch (ex) {
          print(ex.toString());
        }
      } else {
        print('Unable to get cms data');
      }
    }
    return _cmsContent;
  }
}