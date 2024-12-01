import 'dart:ui';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:restaurantmenu/helpers/SharedPrefKeys.dart';
import 'package:shared_preferences/shared_preferences.dart';

//region Events
class LanguageEvent extends Equatable{

  @override
  List<Object> get props => [];

}

class LanguageLoadStarted extends LanguageEvent {}

class LanguageSelected extends LanguageEvent {
  final String languageCode;

  LanguageSelected(this.languageCode) : assert(true);

  @override
  List<Object> get props => [languageCode];
}
//endRegion Events


//region States

class LanguageState extends Equatable {
  final Locale locale;
  const LanguageState(this.locale) : assert(true);

  @override
  List<Object> get props => [locale];
}

//endRegion


class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  String loadedLanguageCode="tk";

  LanguageBloc():super(const LanguageState(Locale('tk', 'TM'))){
    on<LanguageLoadStarted>(_mapLanguageLoadStartedToState);
    on<LanguageSelected>(_mapLanguageSelectedToState);
  }


  void _mapLanguageSelectedToState(LanguageSelected event,Emitter<LanguageState> emit) async {
    String selectedLanguage=event.languageCode;
    final sharedPref = await SharedPreferences.getInstance();
    loadedLanguageCode = sharedPref.getString(SharedPrefKeys.languageCode) ?? "tk";

    if (selectedLanguage == 'en' &&
        loadedLanguageCode != 'en') {
        const locale = Locale('en', 'US');
        await sharedPref.setString(SharedPrefKeys.languageCode,locale.languageCode);
        emit(const LanguageState(locale));
    } else if (selectedLanguage == 'ru' &&
        loadedLanguageCode != 'ru') {
        const locale = Locale('ru', 'RU');
        await sharedPref.setString(SharedPrefKeys.languageCode,locale.languageCode);
        emit(const LanguageState(locale));
    } else if (selectedLanguage == 'tk' &&
        loadedLanguageCode != 'tk') {
        const locale = Locale('tk', 'TM');
        await sharedPref.setString(SharedPrefKeys.languageCode,locale.languageCode);
        emit(const LanguageState(locale));
    }
  }


  void _mapLanguageLoadStartedToState(LanguageLoadStarted event, Emitter<LanguageState> emit) async {
    final sharedPref = await SharedPreferences.getInstance();
    loadedLanguageCode = sharedPref.getString(SharedPrefKeys.languageCode) ?? "tk";

    Locale locale;
    locale = Locale(loadedLanguageCode);

    emit(LanguageState(locale));
  }


}