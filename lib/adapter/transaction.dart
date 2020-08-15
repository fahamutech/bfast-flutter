

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
