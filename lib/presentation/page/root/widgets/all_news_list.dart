import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:pixelplayapp/common/widgets/appstyle.dart';
import 'package:pixelplayapp/common/widgets/apptext.dart';
import 'package:pixelplayapp/core/config/src/appvectors.dart';
import 'package:pixelplayapp/domain/entities/newsEntity.dart';
import 'package:pixelplayapp/presentation/page/root/bloc/getNewsListCubit.dart';
import 'package:pixelplayapp/presentation/page/root/bloc/getNewsListState.dart';

class AllNewsList extends StatelessWidget {
  Color color;
  AllNewsList({
    super.key,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetNewsListCubit()..getNewsList(),
      child: BlocBuilder<GetNewsListCubit, GetAllNewsListState>(
        builder: (context, state) {
          if (state is GetAllNewsListStateLoading) {
            return Center(
              child: Center(
                child: Lottie.asset(
                  Appvectors.loadingAnimation,
                  width: 100.w,
                  height: 100.h,
                  fit: BoxFit.contain,
                  repeat: true,
                ),
              ),
            );
          } else if (state is GetAllNewsListStateError) {
            return Center(
              child: Text(state.error),
            );
          } else if (state is GetAllNewsListStateSuccess) {
            return SingleChildScrollView(
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppTextstyle(
                      text: "Check News ",
                      style: appStyle(
                        size: 20.sp,
                        color: color,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    getAllNewsList(state.news),
                  ],
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget getAllNewsList(List<Newsentity> newsList) {
    return ListView.separated(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      physics: BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 75.w,
                  height: 70.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    image: DecorationImage(
                      image: NetworkImage(newsList[index].newsImg),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(
                  width: 10.w,
                ),
                GestureDetector(
                  onTap: () {
                    context.push('/newspage/${newsList[index].id}');
                  },
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    height: 90.h,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppTextstyle(
                          text: newsList[index].title,
                          style: appStyle(
                              size: 15.sp,
                              color: color,
                              fontWeight: FontWeight.w500),
                          maxLines: 3,
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        AppTextstyle(
                          text:
                              "${newsList[index].postedOn.toDate().day} -- ${newsList[index].postedOn.toDate().month} - ${newsList[index].postedOn.toDate().year}",
                          style: appStyle(
                              size: 12.sp,
                              color: color.withOpacity(0.5),
                              fontWeight: FontWeight.w400),
                          maxLines: 3,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // FavBtn(songEntity: songList[index]), // Add the FavBtn widget here
          ],
        );
      },
      separatorBuilder: (context, index) {
        return SizedBox(
          height: 10.h,
        );
      },
      itemCount: newsList.length,
    );
  }
}
