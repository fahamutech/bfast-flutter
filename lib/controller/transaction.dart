import 'package:bfast/adapter/transaction.dart';
import 'package:bfast/model/transaction.dart';

class TransactionController implements TransactionAdapter{
  @override
  Future commit({Future<List<TransactionModel>> Function(List<TransactionModel> transactionsRequests) before, Future<void> Function() after, bool useMasterKey}) {
    // TODO: implement commit
    throw UnimplementedError();
  }

  @override
  TransactionAdapter create(String domainName, Map data) {
    // TODO: implement create
    throw UnimplementedError();
  }

  @override
  TransactionAdapter createMany(String domainName, List<Map> data) {
    // TODO: implement createMany
    throw UnimplementedError();
  }

  @override
  TransactionAdapter delete(String domainName, DeletePayload payload) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  TransactionAdapter deleteMany(String domainName, List<DeletePayload> data) {
    // TODO: implement deleteMany
    throw UnimplementedError();
  }

  @override
  TransactionAdapter update(String domainName, UpdatePayLoad payLoad) {
    // TODO: implement update
    throw UnimplementedError();
  }

  @override
  TransactionAdapter updateMany(String domainName, List<UpdatePayLoad> data) {
    // TODO: implement updateMany
    throw UnimplementedError();
  }

}