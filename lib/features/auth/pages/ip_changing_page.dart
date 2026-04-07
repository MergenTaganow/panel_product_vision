import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:panel_image_uploader/config/go.dart';
import 'package:panel_image_uploader/config/routes.dart';
import 'package:panel_image_uploader/features/scan/widgets/custom_snack_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../config/helpers.dart';
import '../../../config/injector.dart';
import '../../../core/api.dart';
import '../../global/bloc/date_time_check_cubit/date_time_check_cubit.dart';
import '../bloc/aut_bloc/auth_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class IpChangingPage extends StatelessWidget {
  IpChangingPage({super.key});

  final TextEditingController ipContr = TextEditingController(text: baseUrl.replaceAll('/api', ''));

  @override
  Widget build(BuildContext context) {
    AppLocalizations lg = AppLocalizations.of(context)!;

    return BlocListener<DateTimeCheckCubit, DateTimeStatus>(
      listener: (context, state) {
        if (state == DateTimeStatus.error) {
          CustomSnackBar.showSnackBar(
            context: context,
            title:
                'Please check your internet connection or note that your location may be inside restrictions to Turkmenistan servers',
            isError: true,
          );
        }
        if (state == DateTimeStatus.correct) {
          CustomSnackBar.showSnackBar(context: context, title: 'correctServer');
          Go.popGo(Routes.login);
        }
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        body: Container(
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
                padding: const EdgeInsets.all(24),
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
                    const Text("IP", style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700)),
                    const Box(h: 30),
                    TexField(
                      ctx: context,
                      cont: ipContr,
                      filCol: Colors.white,
                      border: true,
                      borderColor: const Color(0xFFEDF1F3),
                      hint: "ip",
                      borderRadius: 10,
                    ),
                    const Box(h: 16),
                    BlocBuilder<DateTimeCheckCubit, DateTimeStatus>(
                      builder: (context, state) {
                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFEF5A24),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          onPressed: () async {
                            if (ipContr.text.isNotEmpty) {
                              // context.read<AuthBloc>().add(
                              //   LogoutEvent(),
                              // ); //remove user to refresh token
                              Future<SharedPreferences> prefs = SharedPreferences.getInstance();
                              final SharedPreferences prefes = await prefs;

                              await prefes.setBool('ip_was_set', true);

                              sl<Api>().setBaseUrl(
                                "${ipContr.text.trim()}${!ipContr.text.endsWith('/api') ? '/api' : ''}",
                              );

                              context.read<DateTimeCheckCubit>().checkServer();
                            }
                          },
                          child: SizedBox(
                            height: 48,
                            width: double.infinity,
                            child: Center(
                              child:
                                  state == DateTimeStatus.checking
                                      ? const CircularProgressIndicator(color: Colors.white)
                                      : Text(
                                        lg.save,
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
