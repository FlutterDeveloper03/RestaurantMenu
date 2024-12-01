// ignore_for_file: file_names

import 'package:android_id/android_id.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurantmenu/helpers/SharedPrefKeys.dart';
import 'package:shared_preferences/shared_preferences.dart';

//region States
class ServerSettingsState extends Equatable{

  @override
  List<Object> get props => [];

}

class ServerSettingsInitialState extends ServerSettingsState{}
class LoadingServerSettingsState extends ServerSettingsState{}
class ServerSettingsLoadedState extends ServerSettingsState{
  final String deviceId;
  final String serverName;
  final int serverPort;
  final String serverUName;
  final String serverUPass;
  final String dbName;


  ServerSettingsLoadedState(this.deviceId, this.serverName,this.serverPort,this.serverUName, this.serverUPass,this.dbName);

  @override
  List<Object> get props => [deviceId,serverName,serverPort,serverUName,serverUPass,dbName];
}
class SavingServerSettingsState extends ServerSettingsState{}
class ServerSettingsSavedState extends ServerSettingsState{
  final String serverName;
  final int serverPort;
  final String serverUName;
  final String serverUPass;
  final String dbName;


  ServerSettingsSavedState(this.serverName,this.serverPort, this.serverUName, this.serverUPass,this.dbName);

  @override
  List<Object> get props => [serverName,serverPort, serverUName,serverUPass,dbName];
}
class ErrorSaveServerSettingsState extends ServerSettingsState{
  final String errorText;


  ErrorSaveServerSettingsState(this.errorText);


  String get getErrorText=>errorText;

  @override
  List<Object> get props => [errorText];
}


//endregion States

//region Bloc

class ServerSettingsCubit extends Cubit<ServerSettingsState>{

  ServerSettingsCubit():super(ServerSettingsInitialState());

  String _deviceId="";
  String _serverName="";
  int _serverPort=1433;
  String _serverUName="";
  String _serverUPass="";
  String _dbName="";

  void loadServerSettings() async {
    emit(LoadingServerSettingsState());
    try{
      _deviceId = await const AndroidId().getId() ?? '';

      final sharedPref = await SharedPreferences.getInstance();
      _serverName = sharedPref.getString(SharedPrefKeys.serverAddress) ?? "";
      _serverPort = sharedPref.getInt(SharedPrefKeys.serverPort) ?? 1433;
      _serverUName = sharedPref.getString(SharedPrefKeys.dbUName) ?? "";
      _serverUPass = sharedPref.getString(SharedPrefKeys.dbUPass) ?? "";
      _dbName = sharedPref.getString(SharedPrefKeys.dbName) ?? "";

      emit(ServerSettingsLoadedState(_deviceId,_serverName, _serverPort,_serverUName,_serverUPass,_dbName));
    } catch (ex){
      emit(ServerSettingsLoadedState(_deviceId,_serverName, _serverPort,_serverUName,_serverUPass,_dbName));
    }

  }


  void saveServerSettings(String serverName, int serverPort, String serverUName, String serverUPass, String dbName) async {
    emit(SavingServerSettingsState());
    try {
      final sharedPref = await SharedPreferences.getInstance();
      _serverName = serverName;
      _serverPort = serverPort;
      _serverUName = serverUName;
      _serverUPass = serverUPass;
      _dbName = dbName;

      sharedPref.setString(SharedPrefKeys.serverAddress, _serverName);
      sharedPref.setString(SharedPrefKeys.dbUName, _serverUName);
      sharedPref.setString(SharedPrefKeys.dbUPass, _serverUPass);
      sharedPref.setString(SharedPrefKeys.dbName, _dbName);

      emit(ServerSettingsSavedState(_serverName,_serverPort,_serverUName,_serverUPass,_dbName));
    } on Exception catch (e) {
      emit(ErrorSaveServerSettingsState(e.toString()));
    }
  }
}

//endregion Bloc