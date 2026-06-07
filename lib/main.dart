
import 'package:alab/InstaClone/Auth/Cubit/AuthCubit.dart';
import 'package:alab/InstaClone/Auth/Repository/AuthRepository.dart';
import 'package:alab/InstaClone/Auth/View/InstaLoginScreen.dart';
import 'package:alab/InstaClone/Reels/Cubit/ReelCubit.dart';
import 'package:alab/InstaClone/Reels/Repository/ReelRepository.dart';
import 'package:alab/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(create: (_) => AuthCubit(AuthRepository())),
        BlocProvider<ReelCubit>(create: (_) => ReelCubit(ReelRepository())),
      ],
      child: ScreenUtilInit(
        designSize: Size(360, 690),
        minTextAdapt: true,
        builder: (context, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            home: const InstaLoginScreen(),
          );
        },
      ),
    );
  }
}
