class FileQueryModel {
  String keyword = '';
  int size;
  int skip;
  String after;

  FileQueryModel({this.size, this.skip, this.after, this.keyword});
}
