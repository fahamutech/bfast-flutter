# BFast

BFast client sdk for flutter. Always use latest version to stay up to date. Refer to [BFastProject](http://bfast.fahamutech.com/docs) for more documentation and learn more.

## Get Started

Make sure you have your BFast project up and running. Login to your BFast project and create a client apiKey to be used with SDK.

## Initiate Sdk

After install sdk navigate to your main class and add the following code

``` Dart
// some codes and imports

void main(){
    runapp(MyApp());

    BFast().init(serverUrl: '<YOUR_BFAST_SERVER_URL>', apiKey: '<API_KEY>' ); // add this codes
}

// some other codes

```

NOTE

* `<YOUR_BFAST_SERVER_URL>` This is a full hostname with port on which your BFast application is running for example `https://demo.bfast:8000`. Don't include `/` at the end f your serverUrl

* `<API_KEY>` Api key as you define it to your project

## Save data to your domain

Domain is a schema or model you define to your BFast project, once build and deploy you can save data through various ways as follow

```Dart
var product = BFast().domain('products');
product
    .set('name', 'XPS 13')
    .set('price', 1000)
    .save()
    .then((value){
        // product added
    }).catch((reason){
        // handle errors
    });
```

Or you can do this way

```Dart
var product = BFast().domain('products');
product.set('name', 'XPS 13');
product.set('price', 1000);
product.save().then((value){
    // product added
}).catch((reason){
    // handle errors
});
```

Or you can do like this

```Dart
var product = BFast().domain('products');
product.setValues({
    'name': 'XPS 13',
    'price': 1000
}).save().then((value){
    // product added
}).catch((reason){
    // handle errors
});
```

Response of a save method will be an object like

```json
{message: "<RESPONSE_MESSAGE>"}
```

## Get many domain in pagination

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

## Get a single object of a domain

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


// Example

```
