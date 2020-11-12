class FullTextModel {
  String search;
  String language;
  bool caseSensitive;
  bool diacriticSensitive;

  FullTextModel(
      {this.caseSensitive,
      this.diacriticSensitive,
      this.language,
      this.search});
}
