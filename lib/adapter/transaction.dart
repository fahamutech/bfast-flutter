import 'package:bfast/model/transaction.dart';

abstract class TransactionAdapter {
  TransactionAdapter create<T extends Map>(String domainName, T data);

  TransactionAdapter update<T extends Map>(String domainName, UpdatePayLoad<T> payLoad);

  TransactionAdapter delete<T extends Map>(String domainName, DeletePayload<T> payload);

  TransactionAdapter deleteMany<T extends Map>(String domainName, List<DeletePayload<T>> data);

  TransactionAdapter updateMany<T extends Map>(String domainName, List<UpdatePayLoad<T>> data);

  TransactionAdapter createMany<T extends Map>(
      String domainName, List<T> data);

  Future<dynamic> commit(
      {Future<List<TransactionModel>> Function(
              List<TransactionModel> transactionsRequests)
          before,
      Future<void> Function() after,
      bool useMasterKey});
}

class UpdatePayLoad<T> {
  String objectId;
  T data;

  UpdatePayLoad(String objectId, [T data]) {
    this.objectId = objectId;
    this.data = data;
  }
}

class DeletePayload<T> {
  String objectId;
  T data;

  DeletePayload(String objectId, [T data]) {
    this.objectId = objectId;
    this.data = data;
  }
}
