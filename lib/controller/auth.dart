import 'package:bfast/adapter/auth.dart';
import 'package:bfast/adapter/cache.dart';
import 'package:bfast/adapter/rest.dart';

import '../bfast_config.dart';

class AuthController extends AuthAdapter {
  RestAdapter restAdapter;
  CacheAdapter cacheAdapter;
  String appName;

  AuthController(
      RestAdapter restAdapter, CacheAdapter cacheAdapter, String appName) {
    this.cacheAdapter = cacheAdapter;
    this.appName = appName;
    this.restAdapter = restAdapter;
  }

  @override
  Future authenticated([AuthOptions options]) async {
    var user = await this.currentUser();
    if (user != null && user['sessionToken'] != null) {
      var getHeaders = this._geHeadersWithToken(user, options);
      var response = await this.restAdapter.get(
          BFastConfig.getInstance().databaseURL(this.appName, '/users/me'),
          RestRequestConfig(headers: getHeaders));
      return response;
    } else {
      return null;
    }
  }

  @override
  Future currentUser() async {
    return await this.cacheAdapter.get('_current_user_');
  }

  @override
  Future<String> getEmail() async {
    var user = await this.currentUser();
    if (user!=null && user['email']!=null) {
      return user['email'];
    } else {
      return null;
    }
  }

  @override
  Future<String> getSessionToken() async {
    var user = await this.currentUser();
    if (user!=null && user['sessionToken']!=null) {
      return user['sessionToken'];
    } else {
      return null;
    }
  }

  @override
  Future<String> getUsername() async {
    var user = await this.currentUser();
    if (user!=null && user['username']!=null) {
      return user['username'];
    } else {
      return null;
    }
  }

  @override
  Future logIn(String username, String password, [AuthOptions options]) async {
    var getHeader = <String, String>{};
    if (options != null && options.useMasterKey == true) {
      getHeader.addAll({
        'X-Parse-Master-Key': BFastConfig.getInstance()
            .getAppCredential(this.appName)
            .appPassword,
      });
    }
    getHeader.addAll({
      'X-Parse-Application-Id':
          BFastConfig.getInstance().getAppCredential(this.appName).applicationId
    });
    var response = await this.restAdapter.get(
        BFastConfig.getInstance().databaseURL(this.appName, '/login'),
        RestRequestConfig(
            params: {"username": username, "password": password},
            headers: getHeader));
    await this.cacheAdapter.set('_current_user_', response.data, 30);
    return response.data;
  }

  @override
  Future logOut([AuthOptions options]) async {
    var user = await this.currentUser();
    await this.cacheAdapter.set('_current_user_', null);
    if (user != null && user['sessionToken'] != null) {
      var postHeader = this._geHeadersWithToken(user, options);
      this
          .restAdapter
          .post(BFastConfig.getInstance().databaseURL(this.appName, '/logOut'),
              {}, RestRequestConfig(headers: postHeader))
          .catchError((e) {});
    }
    return true;
  }

  @override
  Future requestPasswordReset(String email, [AuthOptions options]) async {
    var user = await this.currentUser();
    if (user != null && user['sessionToken'] != null) {
      var postHeader = this._geHeadersWithToken(user, options);
      var response = await this.restAdapter.post(
          BFastConfig.getInstance()
              .databaseURL(this.appName, '/requestPasswordReset'),
          {email: user['email']!=null ? user['email'] : email},
          RestRequestConfig(headers: postHeader));
      return response.data;
    } else {
      throw 'No current user in your device';
    }
  }

  @override
  Future setCurrentUser(user) async {
    await this.cacheAdapter.set('_current_user_', user, 30);
    return user;
  }

  @override
  Future signUp(String username, String password, Map<String, dynamic> attrs,
      [AuthOptions options]) async {
    var postHeaders = <String, String>{};
    if (options != null && options.useMasterKey == true) {
      postHeaders.addAll({
        'X-Parse-Master-Key': BFastConfig.getInstance()
            .getAppCredential(this.appName)
            .appPassword,
      });
    }
    postHeaders.addAll({
      'X-Parse-Application-Id':
          BFastConfig.getInstance().getAppCredential(this.appName).applicationId
    });
    var userData = {};
    userData["username"] = username;
    userData["password"] = password;
    userData.addAll(attrs);
    var response = await this.restAdapter.post(
        BFastConfig.getInstance().databaseURL(this.appName, '/users'),
        userData,
        RestRequestConfig(headers: postHeaders));
    userData.remove('password');
    userData.addAll(response.data);
    await this.cacheAdapter.set('_current_user_', userData, 30);
    return userData;
  }

  @override
  Future updateUser(Map userModel, [AuthOptions options]) async {
    Map user = await this.currentUser();
    if (user != null && user["sessionToken"] != null) {
      var postHeaders = this._geHeadersWithToken(user, options);
      var response = await this.restAdapter.put(
          BFastConfig.getInstance()
              .databaseURL(this.appName, '/users/' + user['objectId']),
          userModel,
          RestRequestConfig(headers: postHeaders));
      user.remove('password');
      user.addAll(response.data);
      user.addAll(userModel);
      await this.cacheAdapter.set('_current_user_', user, 30);
      return user;
    } else {
      throw 'Not current user in your device';
    }
  }

  Map _geHeadersWithToken(Map user, [AuthOptions options]) {
    var postHeader = <String, String>{};
    if (options != null && options.useMasterKey == true) {
      postHeader.addAll({
        'X-Parse-Master-Key': BFastConfig.getInstance()
            .getAppCredential(this.appName)
            .appPassword,
      });
    }
    postHeader.addAll({'X-Parse-Session-Token': user["sessionToken"]});
    postHeader.addAll({
      'X-Parse-Application-Id':
          BFastConfig.getInstance().getAppCredential(this.appName).applicationId
    });
    return postHeader;
  }
}
