import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pixelplayapp/common/widgets/appstyle.dart';
import 'package:pixelplayapp/common/widgets/apptext.dart';
import 'package:pixelplayapp/core/config/service_locator.dart';
import 'package:pixelplayapp/core/config/theme/appColors.dart';
import 'package:pixelplayapp/presentation/page/Search/cubit/search_song_cubit.dart';
import 'package:pixelplayapp/presentation/page/Search/widgets/search_bar.dart';
import 'package:pixelplayapp/presentation/page/Search/widgets/song_search.dart';
import 'package:pixelplayapp/presentation/page/Search/widgets/user_page.dart';

class Searchpagescreen extends StatefulWidget {
  const Searchpagescreen({super.key});

  @override
  State<Searchpagescreen> createState() => _SearchpagescreenState();
}

class _SearchpagescreenState extends State<Searchpagescreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  late SearchSongCubit _searchSongCubit;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _searchSongCubit = sl<SearchSongCubit>(); //
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {
          _currentIndex = _tabController.index;
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void performSearch(String query) {
    if (query.isEmpty) return;
    if (_currentIndex == 0) {
      _searchSongCubit.searchSongs(query);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              SizedBox(height: 40.h),
              SearchBarWidget(
                controller: _searchController,
                onSubmitted: performSearch,
              ),
              SizedBox(height: 20.h),
              _tabs(Theme.of(context).brightness == Brightness.light
                  ? AppColors.darkBackgroundColor
                  : AppColors.lightBackgroundColor),
              AnimatedContainer(
                  key: ValueKey<int>(_currentIndex),
                  height: MediaQuery.of(context).size.height * 0.7,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  child: TabBarView(
                    controller: _tabController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      BlocBuilder<SearchSongCubit, SearchSongState>(
                        bloc: _searchSongCubit,
                        builder: (context, state) {
                          return SongSearch(
                            state: _searchSongCubit.state,
                          );
                        },
                      ),
                      UserPage(),
                    ],
                  )),

              // Add your search results or other widgets here
            ],
          ),
        ),
      ),
    );
  }

  Widget _tabs(Color textColor) {
    return TabBar(
      dividerColor: Colors.transparent,
      labelColor: textColor,
      controller: _tabController,
      isScrollable: true,
      tabs: [
        AppTextstyle(
            text: "Song",
            style: appStyle(
                size: 15.sp, color: textColor, fontWeight: FontWeight.w500)),
        AppTextstyle(
            text: "User",
            style: appStyle(
                size: 15.sp, color: textColor, fontWeight: FontWeight.w500)),
      ],
    );
  }
}
