import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pixelplayapp/common/widgets/appstyle.dart';
import 'package:pixelplayapp/common/widgets/apptext.dart';
import 'package:pixelplayapp/core/config/service_locator.dart';
import 'package:pixelplayapp/core/config/theme/appColors.dart';
import 'package:pixelplayapp/presentation/page/news/bloc/getNewsByIdCubit.dart';
import 'package:pixelplayapp/presentation/page/news/bloc/getNewsByIdState.dart';
import 'package:pixelplayapp/presentation/page/news/bloc/likeUnlikeNewsCubit.dart';
import 'package:pixelplayapp/presentation/page/news/bloc/likeUnlikeNewsState.dart';

class NewsPage extends StatefulWidget {
  final String newsId;
  const NewsPage({super.key, required this.newsId});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  late GetnewsbyIDcubit _newsCubit;
  late Likeunlikenewscubit _likeNewsCubit; // Declare the cubit

  @override
  void initState() {
    super.initState();
    _newsCubit = sl<GetnewsbyIDcubit>(); // Get the cubit from service locator
    _likeNewsCubit = sl<Likeunlikenewscubit>();
    _newsCubit.fetchNewsByID(widget.newsId);
  }

  @override
  void dispose() {
    // Don't close the cubit here if it's managed by the service locator
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color textColor = Theme.of(context).brightness == Brightness.light
        ? AppColors.darkBackgroundColor
        : AppColors.lightBackgroundColor;
    return Scaffold(
      body: MultiBlocProvider(
        providers: [
          BlocProvider.value(
            value: _newsCubit,
          ),
          BlocProvider.value(
            value: _likeNewsCubit,
          ),
        ],
        child: BlocBuilder<GetnewsbyIDcubit, GetnewsbyIdState>(
          builder: (context, state) {
            if (state is GetnewsbyIdLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is GetnewsbyIdError) {
              return Center(child: Text('Error: //${state.error}'));
            } else if (state is GetnewsbyIdLoaded) {
              final news = state.news;

              // Initialize the like status and count when news is loaded
              // We call this in the build method with a guard to avoid calling it multiple times
              if (state.news.id == widget.newsId) {
                _likeNewsCubit.initialize(news.id, news.like);
              }
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12.r),
                      child: Image.network(
                        news.newsImg,
                        width: double.infinity,
                        height: 350.h,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: double.infinity,
                            height: 200.h,
                            color: Colors.grey[300],
                            child: const Center(
                                child: Text('Image not available')),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AppTextstyle(
                        text: news.title,
                        style: appStyle(
                          size: 20.sp,
                          color: textColor,
                          fontWeight: FontWeight.bold,
                          decorationStyle: TextDecorationStyle.wavy,
                        ),
                        maxLines: 4,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      child: AppTextstyle(
                        text:
                            "Posted on: ${news.postedOn.toDate().day}-${news.postedOn.toDate().month}-${news.postedOn.toDate().year}",
                        style: appStyle(
                          size: 13.sp,
                          color: Colors.grey,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AppTextstyle(
                        text: news.body,
                        style: appStyle(
                          size: 15.sp,
                          color: textColor.withOpacity(0.8),
                          fontWeight: FontWeight.normal,
                        ),
                        maxLines: 25,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    BlocBuilder<Likeunlikenewscubit, LikeUnlikeNewsState>(
                      builder: (context, likeState) {
                        bool isLiked = false;
                        num likeCount = news.like;
                        bool isLoading =
                            likeState is LikeUnlikeNewsLoadingState;

                        if (likeState is LikeUnlikeNewsSuccessState) {
                          isLiked = likeState.isLiked;
                          likeCount = likeState.likeCount;
                        }

                        return Row(
                          children: [
                            IconButton(
                                onPressed: isLoading
                                    ? null
                                    : () => _likeNewsCubit.toggleLike(news.id),
                                icon: isLoading
                                    ? const SizedBox(
                                        width: 18,
                                        height: 18,
                                        child: CircularProgressIndicator(
                                            strokeWidth: 2),
                                      )
                                    : Icon(
                                        isLiked
                                            ? Icons.thumb_up
                                            : Icons.thumb_up_outlined,
                                        color:
                                            isLiked ? Colors.blue : Colors.grey,
                                      ),
                                iconSize: 24.sp),
                            SizedBox(width: 4.w),
                            AppTextstyle(
                              text: "${news.like} likes",
                              style: appStyle(
                                size: 14.sp,
                                color: Colors.blue,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
