class CmsContent {
  final String _contentName;
  final String _textContent;
  final String _mediaContent;

  String get contentName => _contentName;
  String get textContent => _textContent;
  String get mediaContent => _mediaContent;

  CmsContent(this._contentName, this._textContent, this._mediaContent);
}
