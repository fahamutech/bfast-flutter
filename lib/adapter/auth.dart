abstract class AuthAdapter<T> {
  Future<T> authenticated({AuthOptions options});

  Future<String> getEmail();

  Future<String> getUsername();

  Future<T> updateUser(Map user, {AuthOptions options});

  Future<String> getSessionToken();

  Future<String> getToken();

  Future<T> currentUser();

  Future<T> setCurrentUser(T user);

  Future<T> signUp(String username, String password, Map<String, dynamic> attrs,
      {AuthOptions options});

  Future<T> logIn(String username, String password, {AuthOptions options});

  Future<dynamic> logOut({AuthOptions options});

  Future<dynamic> requestPasswordReset(String email, {AuthOptions options});

}

class AuthOptions {
  bool useMasterKey;
  String sessionToken;

  AuthOptions({bool useMasterKey, String sessionToken}) {
    this.useMasterKey = useMasterKey;
    this.sessionToken = sessionToken;
  }
}
