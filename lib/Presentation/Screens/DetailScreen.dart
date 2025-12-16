import 'package:alab/Cubits/User_Data_Cubit.dart';
import 'package:alab/Cubits/User_Data_State.dart';
import 'package:alab/LocalStorage/CRUD/User_CRUD.dart';
import 'package:alab/Presentation/Screens/LoginScreen.dart';
import 'package:alab/Presentation/Widgets/CommonScaffold.dart';
import 'package:alab/Presentation/Widgets/CustomCard.dart';
import 'package:alab/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_debouncer/flutter_debouncer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Detailscreen extends StatefulWidget {
  const Detailscreen({super.key});

  @override
  State<Detailscreen> createState() => _DetailscreenState();
}

class _DetailscreenState extends State<Detailscreen> {
  bool loading = false;
  int count = 10;
  int page = 1;
  List<UserData> UserDataList = [];
  final Throttler scrollThrottler = Throttler();
  final Duration scrollThrottleDuration = const Duration(milliseconds: 300);
  final ScrollController scrollController = ScrollController();
  bool isNetworkChanged = false;
  @override
  void initState() {
    super.initState();
    UserDataList.clear();
    fetchPosts();
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 50) {
        scrollThrottler.throttle(
          duration: scrollThrottleDuration,
          onThrottle: () async {
            setState(() {
              page++;
            });
            await fetchPosts();
          },
        );
      }
    });
  }

  fetchPosts() async {
    setState(() {
      loading = true;
    });
    await context.read<UserCubit>().getUserData(count, page);
    setState(() {
      loading = false;
    });
  }

  Widget build(BuildContext context) {
    return CommonScaffoldWidget(
      appBarTitle: "Posts",
      isBackButton: true,
      body: BlocBuilder<UserCubit, userDataState>(
        builder: (context, state) {
          UserDataList = state.userDataList;
          if (loading&& UserDataList.isEmpty) {
            return Center(child: CupertinoActivityIndicator());
          }
          return UserDataList.isNotEmpty
              ? RefreshIndicator(
                  onRefresh: () async {
                    setState(() {
                      UserDataList.clear();
                      page = 1;
                    });
                    await fetchPosts();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: ListView.builder(
                      controller: scrollController,
                      physics: BouncingScrollPhysics(),
                      itemCount: UserDataList.length + (loading ? 1 : 0),
                      itemBuilder: (ctx, index) {
                        if (index == UserDataList.length && loading) {
                          return Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Center(child: CupertinoActivityIndicator()),
                          );
                        }

                        final userData = UserDataList[index];
                        return Customcard(
                          title: userData.title.toString(),
                          subtitle: userData.body.toString(),
                        );
                      },
                    ),
                  ),
                )
              : Center(
                  child: Text(
                    "No Posts Available",
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
        },
      ),
    );
  }
}
