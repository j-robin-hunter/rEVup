class CmsContent {
  final String _contentName;
  final String _title;
  final String _textContent;
  final String _mediaContent;
  final Map<String, dynamic> _test;

  String get contentName => _contentName;
  String get title => _title;
  String get textContent => _textContent;
  String get mediaContent => _mediaContent;
  Map<String, dynamic> get test => _test;

  CmsContent(this._contentName, this._title, this._textContent, this._mediaContent, this._test);
}
