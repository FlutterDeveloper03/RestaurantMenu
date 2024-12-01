// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:restaurantmenu/ThemeProvider.dart';
import 'package:restaurantmenu/bloc/ServerSettingsCubit.dart';
import 'package:restaurantmenu/helpers/localization.dart';
import 'package:restaurantmenu/pages/SplashScreenPage.dart';

class ServerSettingsPage extends StatelessWidget {
  const ServerSettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final trs = AppLocalizations.of(context);
    final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    TextEditingController tcHost = TextEditingController();
    TextEditingController tcPort = TextEditingController();
    TextEditingController tcUName = TextEditingController();
    TextEditingController tcUPass = TextEditingController();
    TextEditingController tcDbName = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: themeProvider.appBarColor,
        title: Text(trs.translate('server_settings')??"Server settings", style: TextStyle(color: themeProvider.textColor)),
        actions: [
          // BlocBuilder<DeviceRegistrationBloc, DeviceRegistrationState>(
          //   builder: (context, state) {
          //     if (state is SendingRegisterRequestState) {
          //       return Center(
          //         child: CircularProgressIndicator(color: Colors.white),
          //       );
          //     } else
          //       return IconButton(
          //           icon: Icon(Icons.phone_android),
          //           tooltip: trs.translate('register_phone_hint') ??
          //               'Click to send register request',
          //           onPressed: () {
          //             BlocProvider.of<DeviceRegistrationBloc>(context)
          //                 .add(RegisterPhoneEvent());
          //           });
          //   },
          // ),
          // VerticalDivider(),
          IconButton(
              icon: const Icon(Icons.save),
              tooltip: trs.translate('save') ?? 'Save',
              onPressed: () {
                context
                    .read<ServerSettingsCubit>()
                    .saveServerSettings(tcHost.text, int.parse(tcPort.text), tcUName.text, tcUPass.text, tcDbName.text);

                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const SplashScreenPage()));
              })
        ],
      ),
      body: BlocListener<ServerSettingsCubit, ServerSettingsState>(
        listener: (context, state) {
          if (state is ServerSettingsInitialState || state is ErrorSaveServerSettingsState || state is ServerSettingsSavedState){
            context.read<ServerSettingsCubit>().loadServerSettings();
          } else if (state is ServerSettingsLoadedState){
            tcHost.text = state.serverName;
            tcPort.text = state.serverPort.toString();
            tcUName.text = state.serverUName;
            tcUPass.text = state.serverUPass;
            tcDbName.text = state.dbName;
          }
        },
        child: ListView(
          padding: const EdgeInsets.all(8),
          children: [

            Divider(
              color: themeProvider.dividerColor,
              thickness: 2,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 25, bottom: 15),
              child: Text(
                trs.translate('local')??"Local:",
                style: TextStyle(color: themeProvider.textColor, fontWeight: FontWeight.bold, fontSize: 25),
              ),
            ),
            TextField(
              controller: tcHost,
              style: TextStyle(color: themeProvider.textColor),
              decoration: InputDecoration(
                filled: true,
                fillColor: themeProvider.fillColor,
                focusColor: themeProvider.focusColor,
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: themeProvider.borderColor, width: 2.0),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: themeProvider.borderColor, width: 2.0),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: themeProvider.borderColor, width: 2.0),
                ),
                labelText: trs.translate('lbl_server_name')??'Server name',
                labelStyle: TextStyle(color: themeProvider.borderColor),
                hintText: primaryFocus!.hasFocus ? '' : trs.translate('lbl_server_name')??'Server name',
                hintStyle: TextStyle(color: themeProvider.borderColor),
              ),
            ),
            TextField(
              controller: tcPort,
              keyboardType: TextInputType.number,
              style: TextStyle(color: themeProvider.textColor),
              decoration: InputDecoration(
                filled: true,
                fillColor: themeProvider.fillColor,
                focusColor: themeProvider.focusColor,
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: themeProvider.borderColor, width: 2.0),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: themeProvider.borderColor, width: 2.0),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: themeProvider.borderColor, width: 2.0),
                ),
                labelText: trs.translate('lbl_port') ?? "Port",
                labelStyle: TextStyle(color: themeProvider.borderColor),
                hintText: primaryFocus!.hasFocus ? '' : trs.translate('lbl_port') ?? "Port",
                hintStyle: TextStyle(color: themeProvider.borderColor),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: TextField(
                controller: tcUName,
                style: TextStyle(color: themeProvider.textColor),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: themeProvider.fillColor,
                  focusColor: themeProvider.focusColor,
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: themeProvider.borderColor, width: 2.0),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: themeProvider.borderColor, width: 2.0),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: themeProvider.borderColor, width: 2.0),
                  ),
                  labelStyle: TextStyle(color: themeProvider.borderColor),
                  labelText: trs.translate('username')??'Username',
                  hintText: primaryFocus!.hasFocus ? '' : trs.translate('username')??'Username',
                  hintStyle: TextStyle(color: themeProvider.borderColor),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15, bottom: 15),
              child: TextField(
                controller: tcUPass,
                style: TextStyle(color: themeProvider.textColor),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: themeProvider.fillColor,
                  focusColor: themeProvider.focusColor,
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: themeProvider.borderColor, width: 2.0),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: themeProvider.borderColor, width: 2.0),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: themeProvider.borderColor, width: 2.0),
                  ),
                  labelText: trs.translate('password')??'Password',
                  labelStyle: TextStyle(color: themeProvider.borderColor),
                  hintText: primaryFocus!.hasFocus ? '' : trs.translate('password')??'Password',
                  hintStyle: TextStyle(color: themeProvider.borderColor),
                ),
              ),
            ),
            TextField(
              controller: tcDbName,
              style: TextStyle(color: themeProvider.textColor),
              decoration: InputDecoration(
                filled: true,
                fillColor: themeProvider.fillColor,
                focusColor: themeProvider.focusColor,
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: themeProvider.borderColor, width: 2.0),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: themeProvider.borderColor, width: 2.0),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: themeProvider.borderColor, width: 2.0),
                ),
                labelText: trs.translate('lbl_db_name')??'Database name',
                labelStyle: TextStyle(color: themeProvider.borderColor),
                hintText: primaryFocus!.hasFocus ? '' : trs.translate('lbl_db_name')??'Database name',
                hintStyle: TextStyle(color: themeProvider.borderColor),
              ),
            ),
          ],
        ),
      )
    );
  }
}
