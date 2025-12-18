import 'dart:async';

import 'package:alab/Constants/ApiConstants.dart';
import 'package:alab/Cubits/User_Data_State.dart';
import 'package:alab/LocalStorage/CRUD/User_CRUD.dart';
import 'package:alab/main.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserCubit extends Cubit<userDataState> {
  UserCubit(this.connectivity) : super(userDataState()) {
    _initConnectivityListener();
  }

  Dio dio = Dio();
  final Connectivity? connectivity;
  bool hasNetwork = true;

  void _initConnectivityListener() {
    connectivity!.onConnectivityChanged.listen((result) {
      hasNetwork = !result.contains(ConnectivityResult.none);
      emit(
        userDataState(
          userDataList: state.userDataList,
          errorMessage: hasNetwork
              ? "Back Online"
              : "You are offline Showing cached data",
        ),
      );
    });
  }

  Future<void> getUserData(int count, int page) async {
    try {
      if (hasNetwork) {
        final response = await dio.get(ApiUrls.fetchDataURL(count, page),
          options: Options(
          headers: {"Accept": "application/json"},
          validateStatus: (status) => status! < 500,
        ),);
        final data = response.data;

        final List<UserData> dataList = data
            .map<UserData>((item) => UserData.fromJson(item))
            .toList();

        final updatedList = List<UserData>.from(state.userDataList)
          ..addAll(dataList);
        await User().deleteUser(localDB);
        await User().insertUserData(updatedList, localDB);

        emit(
          userDataState(userDataList: updatedList, errorMessage: "Network ON"),
        );
      } else {
        final List<UserData> localData = await User().getItems(localDB);
        emit(
          userDataState(userDataList: localData, errorMessage: "Network OFF"),
        );
      }
    } catch (e) {
      print("ttttttt");
      print(e);
      emit(
        userDataState(
          userDataList: state.userDataList,
          errorMessage: "Error fetching data",
        ),
      );
    }
  }
}
