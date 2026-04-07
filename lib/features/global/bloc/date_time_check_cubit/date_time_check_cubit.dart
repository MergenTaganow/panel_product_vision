import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../config/colors.dart';
import '../../../../config/helpers.dart';
import '../../../auth/data/auth_remote_data_source.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum DateTimeStatus { initial, correct, incorrect, checking, error, tryAgainFailed }

class DateTimeCheckCubit extends Cubit<DateTimeStatus> {
  final AuthRemoteDataSource ds;
  static const _lastCheckedDateKey = 'last_checked_date';
  DateTime? _serverDate = null;

  DateTimeCheckCubit(this.ds) : super(DateTimeStatus.initial);

  Future<void> checkDateTime({
    Duration allowedDifference = const Duration(minutes: 10),
    bool tryAgain = false,
  }) async {
    emit(DateTimeStatus.checking);

    final prefs = await SharedPreferences.getInstance();
    final todayKey = _dateKey(DateTime.now());

    // ✅ Skip if already checked today
    final lastChecked = prefs.getString(_lastCheckedDateKey);
    if (lastChecked == todayKey) {
      // We don't know the last status here, so safest is to assume 'correct'
      // or you can store status too if you want to persist result
      emit(DateTimeStatus.correct);
      return;
    }

    if (tryAgain && _serverDate != null) {
      await Future.delayed(const Duration(seconds: 2));
      final deviceTime = DateTime.now();
      final difference = _serverDate!.difference(deviceTime).abs();

      var status =
          difference > allowedDifference ? DateTimeStatus.tryAgainFailed : DateTimeStatus.correct;
      emit(status);
      return;
    }
    final failOrNot = await ds.getServerDate();
    failOrNot.fold(
      (l) {
        emit(DateTimeStatus.error);
      },
      (r) async {
        if (r == null) {
          emit(DateTimeStatus.error);
          return;
        }

        _serverDate = r;
        final deviceTime = DateTime.now();
        final difference = r.difference(deviceTime).abs();

        var status =
            difference > allowedDifference ? DateTimeStatus.incorrect : DateTimeStatus.correct;

        // Save today as last checked date
        if (status == DateTimeStatus.correct) {
          await prefs.setString(_lastCheckedDateKey, todayKey);
        }
        if (tryAgain && status == DateTimeStatus.incorrect) {
          status = DateTimeStatus.tryAgainFailed;
        }

        emit(status);
      },
    );
  }

  checkServer() async {
    emit(DateTimeStatus.checking);
    final failOrNot = await ds.getServerDate();
    failOrNot.fold(
      (l) {
        emit(DateTimeStatus.error);
      },
      (r) async {
        emit(DateTimeStatus.correct);
      },
    );
  }

  static String _dateKey(DateTime dt) => "${dt.year}-${dt.month}-${dt.day}";
}

void showTimeErrorPopup(BuildContext context) {
  AppLocalizations lg = AppLocalizations.of(context)!;
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padd(
          pad: 16,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Your SVG icon
              Svvg.asset('time_error'),
              const SizedBox(height: 10),
              Text(lg.wrongTime, textAlign: TextAlign.center, style: const TextStyle(fontSize: 17)),
              Text(
                lg.wrongTimeDesc,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 17, color: Color(0xFFA1A1A1)),
              ),
              const Box(h: 20),
              BlocBuilder<DateTimeCheckCubit, DateTimeStatus>(
                builder: (context, state) {
                  if (state == DateTimeStatus.correct) {
                    Navigator.pop(context);
                  }
                  return SizedBox(
                    height: 45,
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Col.primary),
                      onPressed: () {
                        context.read<DateTimeCheckCubit>().checkDateTime(tryAgain: true);
                      },
                      child:
                          state == DateTimeStatus.checking
                              ? Padd(
                                ver: 4,
                                child: const CircularProgressIndicator(color: Colors.white),
                              )
                              : Text(lg.check, style: const TextStyle(color: Colors.white)),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}
