
abstract class DomainI {
  Map<String, dynamic> set(String name, dynamic value);
  Map<String, dynamic> setValues(Map<String, dynamic> model);
  Future<dynamic> save();
  Future<dynamic> many({options: Map});
  Future<dynamic> one({link: String, id: String});
  Future<dynamic> navigate(String link);
  Future<dynamic> search(String name, Map<String, dynamic> options);
  Future<dynamic> update({link: String, id: String});
  Future<dynamic> delete({link: String, id: String});
}
