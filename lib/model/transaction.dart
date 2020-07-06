class TransactionModel<T> {
  String method;
  String path;
  T body;

  TransactionModel({String path, String method,  T body}) {
    this.method = method;
    this.path = path;
    this.body = body;
  }
}

enum TransactionHttpMethod { POST, PUT, DELETE }
