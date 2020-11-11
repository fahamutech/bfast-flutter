import 'package:bfast/adapter/auth.dart';
import 'package:bfast/adapter/cache.dart';
import 'package:bfast/adapter/rest.dart';
import 'package:bfast/controller/rest.dart';

import '../bfast_config.dart';

class AuthController extends AuthAdapter {
  RestAdapter restAdapter;
  CacheAdapter cacheAdapter;
  String appName;

  AuthController(this.restAdapter, this.cacheAdapter, this.appName);

  @override
  Future authenticated({AuthOptions options}) async {
    return this.currentUser();
  }

  @override
  Future currentUser() async {
    var user = await this.cacheAdapter.get('_current_user_');
    if (user == '_empty_' || user == null) {
      return null;
    }
    return user;
  }

  @override
  Future<String> getEmail() async {
    var user = await this.currentUser();
    if (user != null && user['email'] != null) {
      return user['email'];
    } else {
      return null;
    }
  }

  @deprecated
  @override
  Future<String> getSessionToken() async {
    var user = await this.currentUser();
    if (user != null && user['sessionToken'] != null) {
      return user['sessionToken'];
    } else {
      return null;
    }
  }

  @override
  Future<String> getToken() async {
    var user = await this.currentUser();
    if (user != null && user['token'] != null) {
      return user['token'];
    } else {
      return null;
    }
  }

  @override
  Future<String> getUsername() async {
    var user = await this.currentUser();
    if (user != null && user['username'] != null) {
      return user['username'];
    } else {
      return null;
    }
  }

  @override
  Future logIn(String username, String password, {AuthOptions options}) async {
    RestRequestConfig config = RestRequestConfig();
    config.headers = BFastConfig.getInstance().getHeaders(this.appName);
    var authRule = {};
    authRule.addAll({
      'applicationId': BFastConfig.getInstance()
          .getAppCredential(this.appName)
          .applicationId,
      "auth": {
        "signIn": {"username": username, "password": password}
      }
    });
    RestResponse response = await this.restAdapter.post(
        BFastConfig.getInstance().databaseURL(this.appName),
        data: authRule,
        config: config);
    var data = response.data;
    if (data != null &&
        data['auth'] != null &&
        data['auth']['signIn'] != null) {
      await this.cacheAdapter.set('_current_user_', data['auth']['signIn'], dtl: 7);
      return data['auth']['signIn'];
    } else {
      throw {
        "message": data['errors'] != null &&
                data['errors']['auth'] != null &&
                data['errors']['auth']['signIn'] != null
            ? data['errors']['auth']['signIn']['message']
            : 'Fails to login'
      };
    }
  }

  @override
  Future logOut({AuthOptions options}) async {
    await this.cacheAdapter.set('_current_user_', '_empty_');
    return true;
  }

  @override
  Future requestPasswordReset(String email, {AuthOptions options}) async {
    var authRule = {};
    authRule.addAll({
      'applicationId':
          BFastConfig.getInstance().getAppCredential(this.appName).applicationId
    });
    authRule.addAll({
      "auth": {
        "reset": {"email": email}
      }
    });
    RestResponse response = await this.restAdapter.post(
        BFastConfig.getInstance().databaseURL(this.appName),
        data: authRule);
    var data = response.data;
    if (data != null && data['auth'] != null && data['auth']['reset'] != null) {
      return data['auth']['reset'];
    } else {
      throw {
        "message": data['errors'] != null &&
                data['errors']['auth'] != null &&
                data['errors']['auth']['reset'] != null
            ? data['errors']['auth']['reset']['message']
            : 'Fails to reset password'
      };
    }
  }

  @override
  Future setCurrentUser(user) async {
    await this
        .cacheAdapter
        .set('_current_user_', user == null ? '_empty_' : user, dtl: 6);
    return user;
  }

  @override
  Future signUp(String username, String password, Map<String, dynamic> attrs,
      {AuthOptions options}) async {
    var authRule = {};
    authRule.addAll({
      'applicationId':
          BFastConfig.getInstance().getAppCredential(this.appName).applicationId
    });
    attrs.addAll({"username": username, "password": password});
    attrs['email'] = attrs['email'] ? attrs['email'] : '';
    authRule.addAll({
      "auth": {"signUp": attrs}
    });
    RestResponse response = await this.restAdapter.post(
        BFastConfig.getInstance().databaseURL(this.appName),
        data: authRule);
    var data = response.data;
    if (data != null &&
        data['auth'] != null &&
        data['auth']['signUp'] != null) {
      await this.cacheAdapter.set('_current_user_', data.auth.signUp, dtl: 7);
      return data['auth']['signUp'];
    } else {
      throw {
        "message": data['errors'] != null &&
                data['errors']['auth'] != null &&
                data['errors']['auth']['signUp'] != null
            ? data['errors']['auth']['signUp']['message']
            : 'Fails to signUp'
      };
    }
  }

  @override
  Future updateUser(Map userModel, {AuthOptions options}) async {
    throw {
      "message":
          "Not supported, use _User collection in your secure env with masterKey to update user details"
    };
  }
}
