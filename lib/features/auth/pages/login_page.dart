import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../config/colors.dart';
import '../../../config/go.dart';
import '../../../config/helpers.dart';
import '../../../config/routes.dart';
import '../../../my_app.dart';
import '../../global/bloc/date_time_check_cubit/date_time_check_cubit.dart';
import '../../scan/widgets/custom_snack_bar.dart';
import '../bloc/aut_bloc/auth_bloc.dart';
import '../widgets/change_lang.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool obs = true;
  bool rememberMe = false;

  @override
  void initState() {
    context.read<DateTimeCheckCubit>().checkDateTime();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations lg = AppLocalizations.of(context)!;
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccess) {
              Go.too(Routes.itemsPage);
            }
            if (state is AuthFailed) {
              CustomSnackBar.showSnackBar(
                context: context,
                title:
                    state.failure.statusCode == 400
                        ? lg.usernameAndPasswordWrong
                        : state.failure.message ?? lg.smthWentWrong,
                isError: true,
              );
            }
          },
        ),
        BlocListener<DateTimeCheckCubit, DateTimeStatus>(
          listener: (context, state) {
            if (state == DateTimeStatus.incorrect) {
              showTimeErrorPopup(context);
            }
          },
        ),
      ],
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        extendBodyBehindAppBar: true,
        body: Stack(
          children: [
            Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFFF7EBDE).withOpacity(0.6),
                    const Color(0xFFF59D7D).withOpacity(0.8),
                  ],
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFFFF).withOpacity(0.6),
                      border: Border.all(color: Colors.white, width: 1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          lg.login,
                          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
                        ),
                        const Box(h: 12),
                        Text(
                          lg.loginDescr,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF6C7278),
                          ),
                        ),
                        const Box(h: 24),
                        TexField(
                          ctx: context,
                          cont: usernameController,
                          filCol: Colors.white,
                          border: true,
                          borderColor: const Color(0xFFEDF1F3),
                          hint: lg.username,
                          borderRadius: 10,
                        ),
                        const Box(h: 6),
                        TexField(
                          ctx: context,
                          cont: passwordController,
                          filCol: Colors.white,
                          border: true,
                          obsc: obs,
                          suffix: true,
                          suffixColor: const Color(0xFFACB5BB),
                          onSuffix: () {
                            setState(() {
                              obs = !obs;
                            });
                          },
                          borderColor: const Color(0xFFEDF1F3),
                          hintCol: Col.gray50,
                          hint: lg.password,
                          borderRadius: 10,
                        ),
                        // const Box(h: 16),
                        Row(
                          children: [
                            Checkbox(
                              value: rememberMe,
                              onChanged: (v) {
                                setState(() {
                                  if (v != null) {
                                    rememberMe = v;
                                  }
                                });
                              },
                            ),
                            Text(
                              lg.rememberMe,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF6C7278),
                              ),
                            ),
                          ],
                        ),
                        const Box(h: 8),
                        BlocBuilder<AuthBloc, AuthState>(
                          builder: (context, state) {
                            return ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFEF5A24),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () async {
                                if (state is! AuthLoading) {
                                  context.read<AuthBloc>().add(
                                    Login(
                                      passwordController.text.trim(),
                                      usernameController.text.trim(),
                                      rememberMe,
                                    ),
                                  );
                                }
                              },
                              child: SizedBox(
                                height: 48,
                                width: double.infinity,
                                child: Center(
                                  child:
                                      state is AuthLoading
                                          ? const SizedBox(
                                            height: 30,
                                            width: 30,
                                            child: CircularProgressIndicator(color: Colors.white),
                                          )
                                          : Text(
                                            lg.login,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                ),
                              ),
                            );
                          },
                        ),
                        const Box(h: 12),
                        Text(
                          "v$version",
                          style: const TextStyle(color: Color(0xFFA1A1A1), fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Positioned(top: 40, right: 16, child: EditLang()),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padd(
                bot: 40,
                child: GestureDetector(
                  onTap: () {
                    Go.to(Routes.ipChanging);
                  },
                  child: Container(
                    // width: MediaQuery.of(context).size.width * 0.5,
                    decoration: BoxDecoration(
                      // color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Color(0xFF6C7278), width: 1),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Svvg.asset('ip_change', color: Color(0xFF6C7278)),
                        const Box(w: 8),
                        Text(
                          lg.changeIp,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF6C7278),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // GestureDetector(
                //   onLongPress: () {
                //   },
                //   child: Text(
                //     lg.,
                //     style: TextStyle(
                //       color: Color(0xFF6C7278),
                //       fontSize: 16,
                //     ),
                //   ),
                // ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
