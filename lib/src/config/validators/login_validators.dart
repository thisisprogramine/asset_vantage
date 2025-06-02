class LoginValidators {

  static bool validateClientSystemName(String? value) {
    if(value?.isNotEmpty ?? true) {
      return true;

    }

    return false;
  }

  static bool validateUserName(String? value) {
    if(value?.isNotEmpty ?? true) {
      return true;

    }

    return false;
  }

  static bool validatePassword(String? value) {
    if(value?.isNotEmpty ?? true) {
      return true;
    }

    return false;
  }
}