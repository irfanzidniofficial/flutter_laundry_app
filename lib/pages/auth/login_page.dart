import 'package:d_button/d_button.dart';
import 'package:d_info/d_info.dart';
import 'package:d_input/d_input.dart';
import 'package:d_view/d_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_laundry_app/config/app_assets.dart';
import 'package:flutter_laundry_app/config/app_colors.dart';
import 'package:flutter_laundry_app/config/app_constants.dart';
import 'package:flutter_laundry_app/config/app_session.dart';
import 'package:flutter_laundry_app/config/nav.dart';
import 'package:flutter_laundry_app/pages/auth/register_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../config/app_respone.dart';
import '../../config/failure.dart';
import '../../datasource/user_datasource.dart';
import '../../providers/login_provider.dart';
import '../dashboard_page.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final edtEmail = TextEditingController();
  final edtPassword = TextEditingController();
  final formKey = GlobalKey<FormState>();

  execute() {
    bool validInput = formKey.currentState!.validate();
    if (!validInput) return;
    setLoginStatus(ref, 'Loading');
    UserDataSource.login(
      edtEmail.text,
      edtPassword.text,
    ).then((value) {
      String newStatus = '';

      value.fold(
        (failure) {
          switch (failure.runtimeType) {
            case ServerFailure:
              newStatus = 'Server Error';
              DInfo.toastError(newStatus);
              break;
            case NotFoundFailure:
              newStatus = 'Error Not Found';
              DInfo.toastError(newStatus);
              break;
            case ForbiddenFailure:
              newStatus = 'You don\'t have access';
              DInfo.toastError(newStatus);
              break;
            case BadRequestFailure:
              newStatus = 'Bad Request';
              DInfo.toastError(newStatus);
              break;
            case InvalidInputFailure:
              newStatus = 'Invalid Request';
              AppResponse.invalidInput(
                context,
                failure.message ?? '{}',
              );
              break;
            case UnauthorisedFailure:
              newStatus = 'Login Failed';
              DInfo.toastError(newStatus);
              break;
            default:
              newStatus = 'Request Error';
              DInfo.toastError(newStatus);
              newStatus = failure.message ?? '';
              break;
          }
          setLoginStatus(ref, newStatus);
        },
        (result) {
          AppSession.setUser(result['data']);
          AppSession.setBearerToken(result['token']);
          DInfo.toastSuccess("Login Success");
          setLoginStatus(ref, 'Success');
          Nav.replace(context, const DashboardPage());
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            AppAssets.bgAuth,
            fit: BoxFit.cover,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height / 2,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    Colors.black54,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 60, 30, 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 30,
                  ),
                  child: Column(
                    children: [
                      Text(
                        AppConstants.appName,
                        style: GoogleFonts.poppins(
                          fontSize: 40,
                          fontWeight: FontWeight.w500,
                          color: Colors.green[900],
                        ),
                      ),
                      Container(
                        height: 5,
                        width: 40,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ],
                  ),
                ),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      DView.spaceHeight(
                        16,
                      ),
                      IntrinsicHeight(
                        child: Row(
                          children: [
                            AspectRatio(
                              aspectRatio: 1,
                              child: Material(
                                color: Colors.white70,
                                borderRadius: BorderRadius.circular(10),
                                child: const Icon(
                                  Icons.email,
                                  color: Colors.green,
                                ),
                              ),
                            ),
                            DView.spaceWidth(10),
                            Expanded(
                              child: DInput(
                                controller: edtEmail,
                                fillColor: Colors.white70,
                                radius: BorderRadius.circular(10),
                                hint: 'Email',
                                validator: (input) {
                                  return input == '' ? "Don't empty" : null;
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      DView.spaceHeight(
                        16,
                      ),
                      IntrinsicHeight(
                        child: Row(
                          children: [
                            AspectRatio(
                              aspectRatio: 1,
                              child: Material(
                                color: Colors.white70,
                                borderRadius: BorderRadius.circular(10),
                                child: const Icon(
                                  Icons.key,
                                  color: Colors.green,
                                ),
                              ),
                            ),
                            DView.spaceWidth(10),
                            Expanded(
                              child: DInputPassword(
                                controller: edtPassword,
                                fillColor: Colors.white70,
                                radius: BorderRadius.circular(10),
                                hint: 'Password',
                                validator: (input) {
                                  return input == '' ? "Don't empty" : null;
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      DView.spaceHeight(
                        16,
                      ),
                      IntrinsicHeight(
                        child: Row(
                          children: [
                            AspectRatio(
                              aspectRatio: 1,
                              child: DButtonFlat(
                                onClick: () {
                                  Nav.push(context, const RegisterPage());
                                },
                                padding: const EdgeInsets.all(0),
                                radius: 10,
                                mainColor: Colors.white70,
                                child: const Text(
                                  'REG',
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            DView.spaceWidth(10),
                            Expanded(
                              child: Consumer(builder: (_, wiRef, ___) {
                                String status =
                                    wiRef.watch(loginStatusProvider);
                                if (status == 'Loading') {
                                  return DView.loadingCircle();
                                }

                                return ElevatedButton(
                                  onPressed: () => execute(),
                                  style: const ButtonStyle(
                                    alignment: Alignment.centerLeft,
                                  ),
                                  child: const Text(
                                    "Login",
                                  ),
                                );
                              }),
                            )
                          ],
                        ),
                      ),
                      DView.spaceHeight(
                        16,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
