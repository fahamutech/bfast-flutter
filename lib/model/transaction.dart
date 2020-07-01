class TransactionModel {
  String method;
  String path;
  Map<String, dynamic> body;

  TransactionModel({String path, String method, Map<String, dynamic> body}) {
    this.method = method;
    this.path = path;
    this.body = body;
  }
}

enum TransactionHttpMethod { POST, PUT, DELETE }
