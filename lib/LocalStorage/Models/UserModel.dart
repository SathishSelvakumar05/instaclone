class userModel {
  String? mobileNumber;
  String? Otp;

  userModel({this.mobileNumber, this.Otp});

  Map<String, dynamic> toMap() {
    return {'mobileNumber': mobileNumber, 'Otp': Otp};
  }

  factory userModel.fromMap(Map<String, dynamic> map) {
    return userModel(mobileNumber: map['uid'], Otp: map['Otp']);
  }
}
