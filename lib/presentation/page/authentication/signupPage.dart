import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pixelplayapp/common/widgets/appTextField.dart';
import 'package:pixelplayapp/common/widgets/appbtn.dart';
import 'package:pixelplayapp/common/widgets/appstyle.dart';
import 'package:pixelplayapp/common/widgets/apptext.dart';
import 'package:pixelplayapp/core/config/service_locator.dart';
import 'package:pixelplayapp/core/config/src/appvectors.dart';
import 'package:pixelplayapp/core/config/theme/appColors.dart';
import 'package:pixelplayapp/data/model/auth/user_req.dart';
import 'package:pixelplayapp/domain/usecase/auth/signupUseCase.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color textcolor = Theme.of(context).brightness == Brightness.light
        ? AppColors.darkBackgroundColor
        : AppColors.lightBackgroundColor;

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 5.h,
              left: 20.w,
              right: 20.w),
          child: Column(
            children: [
              Center(
                child: Image.asset(
                  Appvectors.applogoBasepath,
                  height: 100.h,
                  width: 100.w,
                ),
              ),
              AppTextstyle(
                text: "Sign Up",
                style: appStyle(
                    size: 25.sp, color: textcolor, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 20.h,
              ),
              AppTextstyle(
                text: "Create an account to continue",
                style: appStyle(
                    size: 17.sp, color: textcolor, fontWeight: FontWeight.w400),
              ),
              SizedBox(
                height: 30.h,
              ),

              // Name TextField
              Apptextfield(
                style: appStyle(
                    size: 18.sp, color: textcolor, fontWeight: FontWeight.w400),
                controller: nameController,
                borderRadius: 20.r,
                hintText: "Enter your name",
                hintStyle: appStyle(
                    size: 17.sp, color: textcolor, fontWeight: FontWeight.w200),
                height: 100.h,
                width: double.infinity,
                keyboardType: TextInputType.name,
                onChanged: (value) {},
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),

              // Email TextField
              Apptextfield(
                style: appStyle(
                    size: 18.sp, color: textcolor, fontWeight: FontWeight.w400),
                controller: emailController,
                borderRadius: 20.r,
                hintText: "Enter your email",
                hintStyle: appStyle(
                    size: 17.sp, color: textcolor, fontWeight: FontWeight.w200),
                height: 100.h,
                width: double.infinity,
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {},
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  } else if (!RegExp(r'^[a-zA-Z0-9@.]+$').hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),

              // Password TextField
              Apptextfield(
                style: appStyle(
                    size: 18.sp, color: textcolor, fontWeight: FontWeight.w400),
                controller: passwordController,
                borderRadius: 20.r,
                hintText: "Create password",
                hintStyle: appStyle(
                    size: 17.sp, color: textcolor, fontWeight: FontWeight.w200),
                height: 100.h,
                width: double.infinity,
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
                onChanged: (value) {},
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  } else if (value.length < 6) {
                    return 'Password must be at least 6 characters long';
                  }
                  return null;
                },
              ),

              // Sign Up Button
              Appbtn(
                text: "Sign Up",
                color: AppColors.primaryColor,
                textColor: AppColors.lightBackgroundColor,
                fontSize: 20.sp,
                radius: 20.r,
                onPressed: () async {
                  var result = await sl<Signupusecase>().call(
                    params: UserReq(
                      userEmail: emailController.text.toString().trim(),
                      userPassword: passwordController.text.toString().trim(),
                      userName: nameController.text.toString().trim(),
                    ),
                  );
                  result.fold(
                    (l) {
                      // Handle error
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(l.toString()),
                          backgroundColor: Colors.red,
                        ),
                      );
                    },
                    (r) {
                      // Handle success
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.green,
                          content: AppTextstyle(
                              text: r.toString(),
                              style: appStyle(
                                  size: 13.sp,
                                  color: AppColors.lightBackgroundColor,
                                  fontWeight: FontWeight.w500)),
                        ),
                      );
                      context.push('/signin');
                    },
                  );
                },
                height: 80.h,
              ),

              SizedBox(
                height: 20.h,
              ),

              // Social Sign Up Options
              SizedBox(
                height: 20.h,
              ),

              // Already have an account
              SizedBox(
                height: 20.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppTextstyle(
                    text: "Already have an account?",
                    style: appStyle(
                        size: 17.sp,
                        color: textcolor,
                        fontWeight: FontWeight.w500,
                        height: 2),
                  ),
                  SizedBox(
                    width: 5.w,
                  ),
                  GestureDetector(
                    onTap: () {
                      context.push('/signin');
                    },
                    child: AppTextstyle(
                      text: "Sign In",
                      style: appStyle(
                          size: 17.sp,
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.w700,
                          height: 2),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h)
            ],
          ),
        ),
      ),
    );
  }
}
