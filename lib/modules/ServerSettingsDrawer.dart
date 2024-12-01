// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurantmenu/ThemeProvider.dart';
import 'package:restaurantmenu/helpers/enums.dart';
import 'package:restaurantmenu/helpers/localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurantmenu/bloc/ServerSettingsCubit.dart';
import 'package:restaurantmenu/pages/SplashScreenPage.dart';

class ServerSettingsDrawer extends StatefulWidget {
  final VoidCallback? goBack;

  const ServerSettingsDrawer({Key? key, this.goBack}) : super(key: key);

  @override
  State<ServerSettingsDrawer> createState() => _ServerSettingsDrawerState();
}

class _ServerSettingsDrawerState extends State<ServerSettingsDrawer> {
  Device _deviceType = Device.mobile;
  @override
  Widget build(BuildContext context) {
    final trs = AppLocalizations.of(context);
    final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    Size size = MediaQuery.of(context).size;
    Orientation orientation=MediaQuery.of(context).orientation;
    TextEditingController tcHost = TextEditingController();
    TextEditingController tcPort = TextEditingController();
    TextEditingController tcUName = TextEditingController();
    TextEditingController tcUPass = TextEditingController();
    TextEditingController tcDbName = TextEditingController();
    _deviceType = (MediaQuery.of(context).size.width < 800) ? Device.mobile : Device.tablet;
    return BlocBuilder<ServerSettingsCubit, ServerSettingsState>(
      builder: (context, state) {
        if (state is ServerSettingsInitialState || state is ErrorSaveServerSettingsState || state is ServerSettingsSavedState){
          return Container(
              width: (size.width<800) ? (orientation==Orientation.portrait)?size.width/2:300 : size.width/3,
              clipBehavior: Clip.hardEdge,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(25), bottomLeft: Radius.circular(25)),
              ),
              child: Drawer(
                backgroundColor: themeProvider.appBarColor,
                child: Padding(
                  padding: const EdgeInsets.only(right: 30, left: 30),
                  child: (_deviceType==Device.tablet)?
                  Column(children: [
                    Container(
                        padding: const EdgeInsets.only(top: 30, bottom: 5),
                        child: Row(
                          children: [
                            TextButton(
                                onPressed: widget.goBack,
                                child: Icon(
                                  Icons.arrow_back,
                                  color: themeProvider.iconColor,
                                  size: 30,
                                )),
                            Text(
                              trs.translate('server_settings')??'Server settings',
                              style: TextStyle(fontSize: 18, color: themeProvider.textColor),
                            ),
                            const Spacer(),
                            IconButton(
                                iconSize: 30,
                                color:themeProvider.iconColor,
                                icon: const Icon(Icons.save),
                                tooltip: trs.translate('save') ?? 'Save',
                                onPressed: () {
                                  context
                                      .read<ServerSettingsCubit>()
                                      .saveServerSettings(tcHost.text, int.parse(tcPort.text), tcUName.text, tcUPass.text, tcDbName.text);

                                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const SplashScreenPage()));
                                })
                          ],
                        )
                    ),
                    Divider(
                      height: 2,
                      color: themeProvider.dividerColor,
                    ),
                    Center(
                    child: TextButton(
                        onPressed: () {
                          context.read<ServerSettingsCubit>().loadServerSettings();
                        },
                        child: Text(trs.translate("load_data")??"Load data!",style:const TextStyle(color: Colors.yellow),)
                    ),
                  ),
                  ])
                      :(orientation==Orientation.portrait)?
                  Column(children: [
                    Container(
                      padding: const EdgeInsets.only(top: 30, bottom: 5),
                      child: Row(
                        children: [
                          Transform.translate(
                            offset: const Offset(-25, 0),
                            child: TextButton(
                                onPressed:widget.goBack,
                                child: Icon(Icons.arrow_back,color: themeProvider.iconColor,size: 25,)),
                          ),
                          Transform.translate(offset: const Offset(-35, 0),child: Text(trs.translate('server_settings')??'Server settings',style: TextStyle(fontSize:17,color: themeProvider.textColor),)),
                          Expanded(
                            child: Transform.translate(
                              offset: const Offset(-20, 0),
                              child: IconButton(
                                  iconSize:20,
                                  color: themeProvider.iconColor,
                                  icon: const Icon(Icons.save),
                                  tooltip: trs.translate('save') ?? 'Save',
                                  onPressed: () {
                                    context
                                        .read<ServerSettingsCubit>()
                                        .saveServerSettings(tcHost.text, int.parse(tcPort.text), tcUName.text, tcUPass.text, tcDbName.text);

                                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const SplashScreenPage()));
                                  }),
                            ),
                          )
                        ],
                      ),
                    ),
                    Divider(
                      height: 2,
                      color: themeProvider.dividerColor,
                    ),
                    Center(
        child: TextButton(
        onPressed: () {
        context.read<ServerSettingsCubit>().loadServerSettings();
        },
        child: Text(trs.translate("load_data")??"Load data!",style:const TextStyle(color: Colors.yellow),)
        ),
        ),
                  ])
                      :SingleChildScrollView(
                    scrollDirection:Axis.vertical,
                    child: Column(children: [
                      Container(
                        padding: const EdgeInsets.only(top: 30, bottom: 5),
                        child: Row(
                          children: [
                            Transform.translate(
                              offset: const Offset(-25, 0),
                              child: TextButton(
                                  onPressed:widget.goBack,
                                  child: Icon(Icons.arrow_back,color: themeProvider.iconColor,size: 25,)),
                            ),
                            Transform.translate(offset: const Offset(-35, 0),child: Text(trs.translate('server_settings')??'Server settings',style: TextStyle(fontSize:17,color: themeProvider.textColor),)),
                            const SizedBox(width:80),
                            IconButton(
                                iconSize:20,
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
                      ),
                      Divider(
                        height: 2,
                        color: themeProvider.dividerColor,
                      ),
                      Center(
        child: TextButton(
        onPressed: () {
        context.read<ServerSettingsCubit>().loadServerSettings();
        },
        child: Text(trs.translate("load_data")??"Load data!",style:const TextStyle(color: Colors.yellow),)
        ),
        ),
                    ]),
                  ),
                ),
              ),
            );
        } else if (state is ServerSettingsLoadedState){
          tcHost.text = state.serverName;
          tcPort.text = state.serverPort.toString();
          tcUName.text = state.serverUName;
          tcUPass.text = state.serverUPass;
          tcDbName.text = state.dbName;
          return Container(
            width: (size.width<800) ? (orientation==Orientation.portrait)?size.width/2:300 : size.width/3,
            clipBehavior: Clip.hardEdge,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(25), bottomLeft: Radius.circular(25)),
            ),
            child: Drawer(
              backgroundColor: themeProvider.appBarColor,
              child: Padding(
                padding: const EdgeInsets.only(right: 30, left: 30),
                child: (_deviceType==Device.tablet)?
                Column(children: [
                  Container(
                      padding: const EdgeInsets.only(top: 30, bottom: 5),
                      child: Row(
                        children: [
                          TextButton(
                              onPressed: widget.goBack,
                              child: Icon(
                                Icons.arrow_back,
                                color: themeProvider.iconColor,
                                size: 30,
                              )),
                          Text(
                            trs.translate('server_settings')??'Server settings',
                            style: TextStyle(fontSize: 18, color: themeProvider.textColor),
                          ),
                          const Spacer(),
                          IconButton(
                              iconSize: 30,
                              color:themeProvider.iconColor,
                              icon: const Icon(Icons.save),
                              tooltip: trs.translate('save') ?? 'Save',
                              onPressed: () {
                                context
                                    .read<ServerSettingsCubit>()
                                    .saveServerSettings(tcHost.text, int.parse(tcPort.text), tcUName.text, tcUPass.text, tcDbName.text);

                                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const SplashScreenPage()));
                              })
                        ],
                      )
                  ),
                  Divider(
                    height: 2,
                    color: themeProvider.dividerColor,
                  ),
                  SizedBox(
                    height: 600,
                    child: ListView(
                      padding: const EdgeInsets.all(8),
                      children: [
                        Text(
                          trs.translate('local')??"Local:",
                          style: TextStyle(color: themeProvider.textColor, fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: TextField(
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
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top:10.0),
                          child: TextField(
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
                            labelText: trs.translate('lbl_db_name')??"Database name",
                            labelStyle: TextStyle(color: themeProvider.borderColor),
                            hintText: primaryFocus!.hasFocus ? '' : trs.translate('lbl_db_name')??"Database name",
                            hintStyle: TextStyle(color: themeProvider.borderColor),
                          ),
                        ),
                      ],
                    ),
                  )
                ])
                    :(orientation==Orientation.portrait)?
                Column(children: [
                  Container(
                    padding: const EdgeInsets.only(top: 30, bottom: 5),
                    child: Row(
                      children: [
                        Transform.translate(
                          offset: const Offset(-25, 0),
                          child: TextButton(
                              onPressed:widget.goBack,
                              child: Icon(Icons.arrow_back,color: themeProvider.iconColor,size: 25,)),
                        ),
                        Transform.translate(offset: const Offset(-35, 0),child: Text(trs.translate('server_settings')??'Server settings',style: TextStyle(fontSize:17,color: themeProvider.textColor),)),
                        Expanded(
                          child: Transform.translate(
                            offset: const Offset(-20, 0),
                            child: IconButton(
                                iconSize:20,
                                color: themeProvider.iconColor,
                                icon: const Icon(Icons.save),
                                tooltip: trs.translate('save') ?? 'Save',
                                onPressed: () {
                                  context
                                      .read<ServerSettingsCubit>()
                                      .saveServerSettings(tcHost.text, int.parse(tcPort.text), tcUName.text, tcUPass.text, tcDbName.text);

                                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const SplashScreenPage()));
                                }),
                          ),
                        )
                      ],
                    ),
                  ),
                  Divider(
                    height: 2,
                    color: themeProvider.dividerColor,
                  ),
                  SizedBox(
                    height: 600,
                    child: ListView(
                      padding: const EdgeInsets.all(8),
                      children: [
                        Text(
                          trs.translate('local')??"Local:",
                          style: TextStyle(color: themeProvider.textColor, fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: TextField(
                            controller:tcHost,
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
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top:10.0),
                          child: TextField(
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
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: TextField(
                            controller:tcUName,
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
                            controller:tcUPass,
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
                          controller:tcDbName,
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
                            labelText: trs.translate('lbl_db_name')??"Database name",
                            labelStyle: TextStyle(color: themeProvider.borderColor),
                            hintText: primaryFocus!.hasFocus ? '' : trs.translate('lbl_db_name')??"Database name",
                            hintStyle: TextStyle(color: themeProvider.borderColor),
                          ),
                        ),
                      ],
                    ),
                  )
                ])
                    :SingleChildScrollView(
                  scrollDirection:Axis.vertical,
                  child: Column(children: [
                    Container(
                      padding: const EdgeInsets.only(top: 30, bottom: 5),
                      child: Row(
                        children: [
                          Transform.translate(
                            offset: const Offset(-25, 0),
                            child: TextButton(
                                onPressed:widget.goBack,
                                child: Icon(Icons.arrow_back,color: themeProvider.iconColor,size: 25,)),
                          ),
                          Transform.translate(offset: const Offset(-35, 0),child: Text(trs.translate('server_settings')??'Server settings',style: TextStyle(fontSize:17,color: themeProvider.textColor),)),
                          const SizedBox(width:80),
                          IconButton(
                              iconSize:20,
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
                    ),
                    Divider(
                      height: 2,
                      color: themeProvider.dividerColor,
                    ),
                    SizedBox(
                      height: 280,
                      child: ListView(
                        scrollDirection:Axis.vertical,
                        padding: const EdgeInsets.all(8),
                        children: [
                          Text(
                            trs.translate('local')??"Local:",
                            style: TextStyle(color: themeProvider.textColor, fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: TextField(
                              controller:tcHost,
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
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top:10.0),
                            child: TextField(
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
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 15),
                            child: TextField(
                              controller:tcUName,
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
                            controller:tcDbName,
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
                              labelText: trs.translate('lbl_db_name')??"Database name",
                              labelStyle: TextStyle(color: themeProvider.borderColor),
                              hintText: primaryFocus!.hasFocus ? '' : trs.translate('lbl_db_name')??"Database name",
                              hintStyle: TextStyle(color: themeProvider.borderColor),
                            ),
                          ),
                        ],
                      ),
                    )
                  ]),
                ),
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },

    );
  }
}
