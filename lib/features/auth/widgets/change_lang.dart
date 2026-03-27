import 'package:flutter/material.dart';

import '../../../config/colors.dart';
import '../../../config/helpers.dart';
import '../../../my_app.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EditLang extends StatelessWidget {
  final bool col;
  const EditLang({super.key, this.col = true});

  @override
  Widget build(BuildContext context) {
    AppLocalizations lg = AppLocalizations.of(context)!;
    return PopupMenuButton<String>(
      elevation: 1.5,
      color: Col.white,
      offset: const Offset(0, 30),
      child: Padd(
        ver: 10,
        hor: 16,
        child: Row(
          children: [
            const Icon(Icons.language),
            const Box(w: 4),
            Text(
              getLocale(lg),
              style: TextStyle(
                color: col ? Col.black : Col.white,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
      onSelected: (item) {
        MyApp.setLocale(context, Locale(item));
      },
      itemBuilder: (BuildContext? contextt) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: 'tr',
          child: Text("turkmen"),
        ),
        const PopupMenuItem<String>(
          value: 'ru',
          child: Text("russian"),
        ),
      ],
    );
  }

  getLocale(AppLocalizations lg) {
    return lg.localeName == 'tr' ? 'TM' : lg.localeName.toUpperCase();
  }
}
