
class SignUpValidators {

  static Validation validateFirstName(String? value) {
    if(value?.isEmpty ?? true) {
      return const Validation(
        isValid: false,
        message: 'Please, Enter First Name'
      );
    }
    return const Validation(
      isValid: true,
      message: ''
    );
  }

  static Validation validateLastName(String? value) {
    if(value?.isEmpty ?? true) {
      return const Validation(
          isValid: false,
          message: 'Please, Enter Last Name'
      );
    }

    return const Validation(
        isValid: true,
        message: ''
    );
  }

  static Validation validateMobileNumber(String? value) {
    RegExp exp = RegExp("^(?:[+0]9)?[0-9]{10}\$");
    if(value?.isEmpty ?? true) {
      return const Validation(
          isValid: false,
          message: 'Please, Enter mobile number'
      );

    }else if(value?.length != 10) {
      return const Validation(
          isValid: false,
          message: 'Please, enter valid mobile number'
      );

    }else if(!exp.hasMatch(value ?? '') && int.parse(value![0]) >= 6) {
      return const Validation(
          isValid: false,
          message: 'Mobile number not starts with '
      );

    }else if(int.parse(value?[0] ?? '0') < 6) {
      return Validation(
          isValid: false,
          message: 'Mobile number not starts with ${value?[0] ?? '0'}'
      );

    }

    return const Validation(
        isValid: true,
        message: ''
    );
  }

  static Validation validateEmail(String? value) {
    if((value?.isNotEmpty ?? false) && !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value ?? '')) {
      return const Validation(
          isValid: false,
          message: 'Invalid Email'
      );
    }
    return const Validation(
        isValid: true,
        message: ''
    );
  }

  static Validation validateCity(String? value) {
    if (value?.isEmpty ?? true) {
      return const Validation(
          isValid: false,
          message: 'Please, Enter city'
      );
    }
    return const Validation(
        isValid: true,
        message: ''
    );
  }

  static Validation validatePincode(String? value) {
    if (value?.isEmpty ?? true) {
      return const Validation(
          isValid: false,
          message: 'Please, Enter pincode'
      );
    } else if(value?.length != 6) {
      return const Validation(
          isValid: false,
          message: 'Invalid pincode'
      );
    }
    return const Validation(
        isValid: true,
        message: ''
    );
  }

}

class Validation {
  final bool isValid;
  final String message;

  const Validation({
    this.isValid = false,
    this.message = ''
  });
}