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

This is a collection or table you use to save your data. If not exist in database will be created 
automatically for you.


```dart
var product = BFast.database().table('products');
product.save({
    'name': 'XPS 13',
    'price': 1000
}).then((value){
    // product added
}).catchError((reason){
    // handle errors
});
```


### Query

You can retrive domains from your bfast project as follow.

```Dart
var product = BFast().domain('products');
product.many().then((value){
    // your logics to handle data
}).catch((reason){
    // handle errors
});
```

This will return first 20 domain objects from your bfast projects as a default pagination. Or you can pass optinal params as follow

```Dart
var product = BFast().domain('products');
product.many({
    "size": 100, // data returned size [option]
    "page": 0, // starting page [option]
    "order": "name" // order results by name [option]
}).then((value){
    // your logics to handle data
}).catch((reason){
    // handle errors
});
```

When request is succesfull, response will be of the following format. Note DOMAIN_NAME mean the name of the domain you request data in this example `products`

```json
{
    [DOMAIN_NAME]: Array,
    page: Object,
    links: Object
}
```

`page` property contain information abount pagination of data, `links` contain information on how to navigate between data and propert [DOMAIN_NAME] contain array of request data

### Get a single object of a domain

To get a single object of a domain we can either use link of that object or its objectId.

* By using link

```Dart
var product = BFast().domain('products');
product.one(link: '<OBJECT_LINK>').then((value){
    // your logics to handle object data  
}).catch((reason){
    //  handle errors
});
```

* By using objectId/id

```Dart
var product = BFast().domain('products');
product.one(id: '<OBJECT_ID>').then((value){
    // your logics to handle object data  
}).catch((reason){
    //  handle errors
});
```

* When pass both link and id. link will be used instead of id

```Dart
var product = BFast().domain('products');
product.one(link: '<OBJECT_LINK>', id: '<OBJECT_ID>').then((value){
    // your logics to handle object data  
}).catch((reason){
    //  handle errors
});
```

Response will be of the following format

```json
{
    [DOMAIN_NAME]: Object
}
```

### Update Domain

To update a single object of a domain we can either use link of that object or its objectId.

* By using link

```Dart
var product = BFast().domain('products');
product.set('name', 'XPS 15');
product.set('price', 3000);
product.update(link: '<OBJECT_LINK>').then((value){
    // object updated
}).catch((reason){
    //  handle errors
});
```

* By using objectId/id

```Dart
var product = BFast().domain('products');
product.set('name', 'XPS 15');
product.set('price', 3000);
product.update(id: '<OBJECT_ID>').then((value){
    // object updated
}).catch((reason){
    //  handle errors
});
```

* When pass both link and id. link will be used instead of id

```Dart
var product = BFast().domain('products');
product.set('name', 'XPS 15');
product.set('price', 3000);
product.update(link: '<OBJECT_LINK>', id: '<OBJECT_ID>').then((value){
    // object updated  
}).catch((reason){
    //  handle errors
});
```

Response will be of the following format

```json
{
    message: <MESSAGE_FROM_SERVER>
}
```

### Delete Domain

To delete a domain we can either use link of that object or its objectId.

* By using link

```Dart
var product = BFast().domain('products');
product.delete(link: '<OBJECT_LINK>').then((value){
    // object deleted
}).catch((reason){
    //  handle errors
});
```

* By using objectId/id

```Dart
var product = BFast().domain('products');
product.delete(id: '<OBJECT_ID>').then((value){
    // object deleted  
}).catch((reason){
    //  handle errors
});
```

* When pass both link and id. link will be used instead of id

```Dart
var product = BFast().domain('products');
product.delete(link: '<OBJECT_LINK>', id: '<OBJECT_ID>').then((value){
    // object deleted
}).catch((reason){
    //  handle errors
});
```

Response will be of the following format

```json
{
    message: <MESSAGE_FROM_SERVER>
}
```

### Call a query from BFast project

You can call a query defined to your domain from BFast console/project as follow. Let say we define a query in our domain called `findAllByName`

```Dart
var product = BFast().domain('products');
product.search('findAllByName',{
    "name": "XPS 13"
}).then((value){
    // your logic to handle results
}).catch((reason){
    // handle error
})
```

When request is succesfull, response will be of the following format. Note DOMAIN_NAME mean the name of the domain you request data in this example `products`

```json
{
    [DOMAIN_NAME]: dynamic, // depend on return of query
    page: Object, // option, can be null
    links: Object // option, can be null
}
```

`page` property contain information abount pagination of data, `links` contain information on how to navigate between data and propert [DOMAIN_NAME] contain array of request data

### Pagination support

You can navigate forward and backward through your data pr jump to a specific page by as follow

```Dart
var product = BFast().domain('products');
product.navigate('<LINK_OF_NEXT_DATA>').then((value){
    // handle next data
}).catch((reason){
    // handle errors
});
```

When request is succesfull, response will be of the following format. Note DOMAIN_NAME mean the name of the domain you request data in this example `products`

```json
{
    [DOMAIN_NAME]: Array,
    page: Object,
    links: Object
}
```

`page` property contain information abount pagination of data, `links` contain information on how to navigate between data and propert [DOMAIN_NAME] contain array of request data

## BFast Function

BFast project support function as a service or cloud function which you can call it as follow

```Dart
BFast().fun('hello').run().then((value){
    // handle your function results
}).catch((reason){
    // handle erros
})
```

You can pass body to your function to as follow

```Dart
BFast().fun('hello').run({
    "name": "Joshua"
}).tne((value){
    // handle your function results
}).catch((reason){
    // handle errors
});
```

Response will be as you return from your function
