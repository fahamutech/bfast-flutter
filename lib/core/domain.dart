
abstract class DomainI {
  DomainI set(String name, Object value);
  DomainI setValues(Map<String, Object> model);
  Future<dynamic> save();
  Future<dynamic> many({Map options});
  Future<dynamic> one({String link, String id});
  Future<dynamic> navigate(String link);
  Future<dynamic> search(String name, Map<String, Object> options);
  Future<dynamic> update({String link, String id});
  Future<dynamic> delete({String link, String id});
}

//class DomainModel{
//  Map<String, Object> _model = Map();
//
//  DomainModel set(String name, Object value){
//    this._model[name] = value;
//    return this;
//  }
//
////  save();
//}
//
//void main(){
//  var domain = new DomainModel();
//  domain
//      .set("name", "Joshua");
//  domain.set("age", 25);
//  print(domain._model);
//}