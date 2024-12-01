import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:restaurantmenu/TAppTheme.dart';
import 'package:restaurantmenu/ThemeProvider.dart';
import 'package:restaurantmenu/bloc/CategoriesPageCubit.dart';
import 'package:restaurantmenu/bloc/LanguageBloc.dart';
import 'package:restaurantmenu/bloc/ServerSettingsCubit.dart';
import 'package:restaurantmenu/bloc/UserProfileBloc.dart';
import 'package:restaurantmenu/helpers/localization.dart';
import 'package:restaurantmenu/models/providerModel.dart';
import 'package:restaurantmenu/pages/SplashScreenPage.dart';

void main() {
  runApp(ChangeNotifierProvider<ProviderModel>(
    key: UniqueKey(),
    create: (context) => ProviderModel(),
    child: MultiBlocProvider(
      providers: [
        BlocProvider(create: (_)=>CategoriesPageCubit()),
        BlocProvider(create: (_)=>UserProfileCubit()..loadUserProfile()),
        BlocProvider(create: (_)=>ServerSettingsCubit()..loadServerSettings()),
        BlocProvider(create: (_) => LanguageBloc()..add(LanguageLoadStarted()),),
      ],
      child: const MyApp(),
    ),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      builder: (context, _) {
        final themeProvider = Provider.of<ThemeProvider>(context);
        return BlocBuilder<LanguageBloc, LanguageState>(
            builder: (context, languageState) {
              return MaterialApp(
                title: 'Restaurant Menu',
                theme: TAppTheme.lightTheme,
                darkTheme: TAppTheme.darkTheme,
                themeMode: themeProvider.darkMode?ThemeMode.dark:ThemeMode.light,
                locale: languageState.locale,
                localizationsDelegates: const [
                  GlobalMaterialLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  TkMaterialLocalizations.delegate,
                  AppLocalizations.delegate,
                ],
                supportedLocales: const [
                  Locale('en', 'US'),
                  Locale('ru', 'RU'),
                  Locale('tk', 'TM'),
                ],
                home: const SplashScreenPage(),
              );
            });

      },
    );
  }
}
