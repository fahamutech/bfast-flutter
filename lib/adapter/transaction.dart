import 'package:bfast/model/transaction.dart';

abstract class TransactionAdapter {
  TransactionAdapter create(String domainName, Map<dynamic, dynamic> data);

  TransactionAdapter update(String domainName, UpdatePayLoad payLoad);

  TransactionAdapter delete(String domainName, DeletePayload payload);

  TransactionAdapter deleteMany(String domainName, List<DeletePayload> data);

  TransactionAdapter updateMany(String domainName, List<UpdatePayLoad> data);

  TransactionAdapter createMany(
      String domainName, List<Map<dynamic, dynamic>> data);

  Future<dynamic> commit(
      {Future<List<TransactionModel>> Function(
              List<TransactionModel> transactionsRequests)
          before,
      Future<void> Function() after,
      bool useMasterKey});
}

class UpdatePayLoad {
  String objectId;
  Map data;

  UpdatePayLoad(String objectId, [Map data]) {
    this.objectId = objectId;
    this.data = data;
  }
}

class DeletePayload {
  String objectId;
  Map data;

  DeletePayload(String objectId, [Map data]) {
    this.objectId = objectId;
    this.data = data;
  }
}
