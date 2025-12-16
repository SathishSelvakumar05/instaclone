import 'dart:async';

import 'package:alab/Cubits/Network_State.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class networkCubit extends Cubit<Network>{
  networkCubit({@required this.connectivity}):super(Network(true)){
    checkInternetConnection();
  }
  final Connectivity? connectivity;
  StreamSubscription? connectivityStreamSubscription;
  checkInternetConnection() {
    try {
      connectivityStreamSubscription = connectivity!.onConnectivityChanged
          .listen((List<ConnectivityResult> results)  {
        if (results.contains(ConnectivityResult.none)) {
          emit(Network(false));
        } else {
          emit(Network(true));
        }
      });
    } catch (e) {
      throw e;
    }
  }
}