import 'dart:math';

class CommonFunctions {
  String? validateMobile(String? val) {
    if (val == null || val.isEmpty) {
      return "Mobile number is required";
    }

    if (!RegExp(r'^[0-9]+$').hasMatch(val)) {
      return "Enter only digits";
    }

    if (val.length != 10) {
      return "Enter a valid 10-digit mobile number";
    }

    // Optional: Indian mobile numbers start with 6,7,8,9
    if (!RegExp(r'^[6-9]').hasMatch(val)) {
      return "Enter a valid Indian mobile number";
    }

    return null;
  }
  String? validateOtp(String? val) {
    if (val == null || val.isEmpty) {
      return "OTP is required";
    }

    if (!RegExp(r'^[0-9]+$').hasMatch(val)) {
      return "Enter only digits";
    }

    if (val.length != 6) {
      return "Enter a valid 6-digit OTP";
    }

    return null;
  }
  String generateOtp() {
    final random = Random();
    return (100000 + random.nextInt(900000)).toString(); // 6-digit OTP
  }

}
