import 'package:alab/Concepts/RefreshToken/ApiService/SecureStorage.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'LoginState.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginState());
  Dio dio = Dio();
  LoginUser(Map<String, dynamic> Logindata) async {
    final response = await dio.post(
      'https://dummyjson.com/auth/login',
      data: Logindata,
      options: Options(contentType: 'application/json'),
    );
    final LoginState logindata = LoginState.fromJson(response.data);
    CustomSecureStorage().writeSecureData(
      "accessToken",
      logindata.accessToken!,
    );
    CustomSecureStorage().writeSecureData(
      "refreshToken",
      logindata.refreshToken!,
    );
    emit(logindata);
  }
}
