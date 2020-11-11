# BFast

BFast client sdk for flutter. Always use latest version to stay up to date.


## Initiate Sdk

After install sdk navigate to your main class and add the following code

``` dart
// some codes and imports

void main(){

    BFast.init(AppCredential('your_app_id','your_project_id'));

    // rest of your codes
}

// some other codes

```

AppCredential interface is as follows

```dart
class AppCredentials {
  String applicationId; // applicationId from bfast::cloud project if you have one
  String projectId; // projectId from bfast::cloud project if you have one
  String functionsURL; // a custom bfast::function instance url of where you deploy it
  String databaseURL; // a custom bfast::database instance url of where you deploy it
  String appPassword; // materKey from bfast::cloud or from your bfast::database instance when you initialize it.
  CacheConfigOptions cache; // offline strorage configuration for your app

  AppCredentials(
    String applicationId,
    String projectId, {
    String functionsURL,
    String databaseURL,
    String appPassword,
    CacheConfigOptions cache,
  });
}

class CacheConfigOptions {
  bool enable; // global enable of cache, default is false
  String collection; // global collection/table to store data
  String ttlCollection; // global collection/table to store data time to leave information

  CacheConfigOptions(bool enable, {String collection, String ttlCollection}) {
    this.enable = enable;
    this.collection = collection;
    this.ttlCollection = ttlCollection;
  }
}


```

## Database

Manipulate your data in bfast::database instance by using `BFast.database()` API.

### Save Data


### Query


### Get a single object of a domain


### Update Domain


### Delete Domain


### Call a query from BFast project

## BFast Function
