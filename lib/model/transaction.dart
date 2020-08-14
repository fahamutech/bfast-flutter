class TransactionModel<T extends dynamic> {
  TransactionAction action;
  String domain;
  T data;

  TransactionModel({this.data, this.action, this.domain});
}

enum TransactionAction { CREATE, UPDATE, DELETE, QUERY }
