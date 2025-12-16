import 'package:alab/CommonFunctions/PushNotification.dart';
import 'package:alab/Cubits/Network_Cubit.dart';
import 'package:alab/Cubits/Network_State.dart';
import 'package:alab/Cubits/User_Data_Cubit.dart';
import 'package:alab/Presentation/Screens/AutoLoginScreen.dart';
import 'package:alab/Presentation/Screens/DetailScreen.dart';
import 'package:alab/Presentation/Screens/HomeScreen.dart';
import 'package:alab/firebase_options.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sqflite/sqflite.dart';
import 'CommonFunctions/LocalNotification.dart';
import 'LocalStorage/LocalDB.dart';
import 'Presentation/Screens/LoginScreen.dart';

late final Database localDB;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  localDB = await DBHelper().database;
  await LocalNotification.localInit();
  await PushNotificationService.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<UserCubit>(create: (context) => UserCubit(Connectivity())),
        BlocProvider<networkCubit>(
          create: (context) => networkCubit(connectivity: Connectivity()),
        ),
      ],
      child: ScreenUtilInit(
        designSize: Size(360, 690),
        minTextAdapt: true,
        builder: (context, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            builder: (context, widget) {
              return BlocListener<networkCubit, Network>(
                listener: (context, state) {
                  if (state.isConnected!) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.greenAccent,
                        content: Text(
                          context.read<UserCubit>().state.errorMessage!,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.redAccent,
                        content: Text(
                          context.read<UserCubit>().state.errorMessage!,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  }
                },
                child: widget!,
              );
            },
            home: AutoLoginScreen(),
          );
        },
      ),
    );
  }
}
