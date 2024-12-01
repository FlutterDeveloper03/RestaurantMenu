import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:restaurantmenu/helpers/enums.dart';
import 'package:restaurantmenu/helpers/localization.dart';
import 'package:restaurantmenu/widgets/ChangeThemeButtonWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:restaurantmenu/bloc/LanguageBloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../ThemeProvider.dart';
class SettingsDrawer extends StatefulWidget {
  final bool visible;
  final  VoidCallback? goBack;
  final  VoidCallback? synch;
  final  VoidCallback? profile;
  final  VoidCallback? server;
  const SettingsDrawer({Key? key,  this.goBack, required this.visible, this.synch, this.profile, this.server}) : super(key: key);

  @override
  State<SettingsDrawer> createState() => _SettingsDrawerState();
}

class _SettingsDrawerState extends State<SettingsDrawer> {
  late int i;
  String? appVersion;
  String? buildNumber;
  Device _deviceType = Device.mobile;
  Future<void> initPackageInfo() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
       appVersion = packageInfo.version;
       buildNumber = packageInfo.buildNumber;
    });
  }
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmController = TextEditingController();
  late String passWord;
  late String confirm;
  @override
  void initState() {
    super.initState();
    initPackageInfo();
  }
  bool isVisible=false;
 Widget lockIcon=const Icon(Icons.lock_open_outlined);
  Future<void> change() async{
    final prefs = await SharedPreferences.getInstance();
    if(prefs.containsKey("password") && prefs.containsKey("confirm")){
      lockIcon=const Icon(Icons.lock_outline_sharp);
      setState(() {});
      i=0;
    }
    else{
      lockIcon=const Icon(Icons.lock_open_outlined);
      setState(() {});
      i=1;
    }
  }

  @override
  Widget build(BuildContext context) {
    change();
    final trs = AppLocalizations.of(context);
    final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    _deviceType = (MediaQuery.of(context).size.width < 800) ? Device.mobile : Device.tablet;
    Size size = MediaQuery.of(context).size;
    Orientation orientation=MediaQuery.of(context).orientation;
    var items = [
      trs.translate('tk')??'Turkmen',
      trs.translate('ru')??'Russian',
      trs.translate('en')??'English',
    ];
    String dropdownvalue = trs.translate('tk')??'Turkmen';
    return Container(
      width: (size.width<800) ? (orientation==Orientation.portrait)?size.width/1.3:size.width/2 : size.width/3,
      clipBehavior: Clip.hardEdge,
      decoration:  const BoxDecoration(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(25),bottomLeft:Radius.circular(25)
        ),
      ),
      child: Drawer(
        backgroundColor: themeProvider.appBarColor,
        child: Padding(
          padding: const EdgeInsets.only(right:30,left:30),
          child: (_deviceType==Device.tablet)? Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30,bottom: 5),
                child: Row(
                  children: [
                    Visibility(visible:widget.visible,child: TextButton(
                        onPressed: widget.goBack,
                        child: Icon(Icons.arrow_back,color: themeProvider.iconColor,size: 30,))),
                    Text(trs.translate('settings')??"Settings",style: TextStyle(fontSize:24,color: themeProvider.textColor),),
                     const Spacer(),
                     IconButton(onPressed: () async{
                       i++;
                         if(i==1){
                           final prefs = await SharedPreferences.getInstance();
                           if(prefs.containsKey("password") && prefs.containsKey("confirm")) {
                             clearData();
                           }
                         }
                         else if(i==2){
                           setState(() {
                             _displayTextInputDialog(context,themeProvider.textColor,themeProvider.borderColor,themeProvider.fillColor,themeProvider.focusColor);
                           });
                         }
                     }, icon: lockIcon,color: themeProvider.iconColor,iconSize: 30,),
                     Icon(Icons.settings,color: themeProvider.iconColor,size: 30,)
                  ],
                ),
              ),
              Divider(height: 2,color: themeProvider.dividerColor,),
              Expanded(
                child: ListView(
                  children: [
                    ListTile(onTap:widget.profile,title: Text(trs.translate('profile')??"My profile",style: TextStyle(color: themeProvider.textColor),), leading: Icon(Icons.person_outline_sharp,color: themeProvider.iconColor),trailing:IconButton(onPressed: widget.profile,
                      icon: const Icon(Icons.arrow_forward_ios_sharp),color: themeProvider.iconColor),
                    ),
                    ListTile(title: Text(trs.translate('theme')??"Theme of the program",style: TextStyle(color: themeProvider.textColor),),leading: Icon(Icons.mode,color: themeProvider.iconColor,),trailing: const ChangeThemeButtonWidget(),),
                    ListTile(title: Text(trs.translate('language')??"Interface language",style: TextStyle(color: themeProvider.textColor),),leading:Icon(Icons.language,color: themeProvider.iconColor,),onTap: (){
                      setState(() {
                        isVisible=!isVisible;
                      });
                    }),
                    Visibility(
                      visible: isVisible,
                      child: DropdownButton(
                        dropdownColor: themeProvider.fillColor,
                        padding: const EdgeInsets.only(left:20,right:30),
                        value: dropdownvalue,
                        isExpanded: true,
                        iconSize: 35,
                        icon:  Icon(Icons.keyboard_arrow_down,color: themeProvider.iconColor,),
                        items: items.map((String items) {
                          return DropdownMenuItem(
                            value: items,
                            child: Text(items,style: TextStyle(color: themeProvider.textColor),),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownvalue = newValue!;
                            BlocProvider.of<LanguageBloc>(context).add(
                                LanguageSelected(newValue));
                          });
                        },
                      ),
                    ),
                    ListTile(title: Text(trs.translate('version')??"Program version",style: TextStyle(color: themeProvider.textColor),),leading:Icon(Icons.phone_android,color: themeProvider.iconColor,),trailing: Text("$appVersion+$buildNumber",style: TextStyle(color: themeProvider.textColor),),),
                    ListTile(onTap:widget.server,title: Text(trs.translate('server_settings')??"Server settings",style: TextStyle(color: themeProvider.textColor),),leading:Icon(Icons.network_locked_outlined,color: themeProvider.iconColor,),trailing:IconButton(onPressed: widget.server,icon: Icon(Icons.arrow_forward_ios_sharp,color: themeProvider.iconColor,),),
                    ),
                    ListTile(onTap:widget.synch,title: Text(trs.translate('sync')??"Synchronization",style: TextStyle(color: themeProvider.textColor),),leading:Icon(Icons.cached_outlined,color: themeProvider.iconColor,),trailing:TextButton(
                      onPressed: widget.synch
                    ,child: Icon(Icons.arrow_forward_ios_sharp,color: themeProvider.iconColor,),),
                    ),
                  ],
                ),
              ),
            ],
          )
          :(orientation==Orientation.portrait)? Column(
            children: [
              Container(
                padding: const EdgeInsets.only(top: 30,bottom: 5),
                child: Row(
                  children: [
                    Visibility(visible:widget.visible,child: Transform.translate(
                      offset: const Offset(-22, 0),
                      child: TextButton(
                          onPressed: widget.goBack,
                          child: Icon(Icons.arrow_back,color: themeProvider.iconColor,size: 30,)),
                    )),
                    widget.visible?Transform.translate(offset: const Offset(-22, 0),child: Text(trs.translate('settings')??"Settings",style: TextStyle(fontSize:19,color: themeProvider.textColor),)):Text(trs.translate('settings')??"Settings",style: TextStyle(fontSize:19,color: themeProvider.textColor),),
                    SizedBox(width: widget.visible? 0 : 40,),
                    IconButton(onPressed: () async{
                      i++;
                      if(i==1){
                        final prefs = await SharedPreferences.getInstance();
                        if(prefs.containsKey("password") && prefs.containsKey("confirm")) {
                          clearData();
                        }
                      }
                      else if(i==2){
                        setState(() {
                          _displayTextInputDialog(context,themeProvider.textColor,themeProvider.borderColor,themeProvider.fillColor,themeProvider.focusColor);
                        });
                      }
                    }, icon: lockIcon,color: themeProvider.iconColor,iconSize: 25,),
                  const SizedBox(width:5),
                    Icon(Icons.settings,color: themeProvider.iconColor,size: 25,)
                  ],
                ),
              ),
              Divider(height: 2,color: themeProvider.dividerColor,),
              SizedBox(
                height: 600,
                child: ListView(
                  children: [
                    ListTile(onTap:widget.profile,title: Text(trs.translate('profile')??"My profile",style: TextStyle(color: themeProvider.textColor),), leading: Icon(Icons.person_outline_sharp,color: themeProvider.iconColor),trailing:IconButton(onPressed: widget.profile,
                        icon: const Icon(Icons.arrow_forward_ios_sharp),color: themeProvider.iconColor),
                    ),
                    ListTile(title: Text(trs.translate('theme')??"Theme of the program",style: TextStyle(color: themeProvider.textColor),),leading: Icon(Icons.mode,color: themeProvider.iconColor,),trailing: const ChangeThemeButtonWidget(),),
                    ListTile(title: Text(trs.translate('language')??"Interface language",style: TextStyle(color: themeProvider.textColor),),leading:Icon(Icons.language,color: themeProvider.iconColor,),onTap: (){
                      setState(() {
                        isVisible=!isVisible;
                      });
                    }),
                    Visibility(
                      visible: isVisible,
                      child: DropdownButton(
                        dropdownColor: themeProvider.fillColor,
                        padding: const EdgeInsets.only(left:20,right:30),
                        value: dropdownvalue,
                        isExpanded: true,
                        iconSize: 35,
                        icon:  Icon(Icons.keyboard_arrow_down,color: themeProvider.iconColor,),
                        items: items.map((String items) {
                          return DropdownMenuItem(
                            value: items,
                            child: Text(items,style: TextStyle(color: themeProvider.textColor),),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownvalue = newValue!;
                            BlocProvider.of<LanguageBloc>(context).add(
                                LanguageSelected(newValue));
                          });
                        },
                      ),
                    ),
                    ListTile(title: Text(trs.translate('version')??"Program version",style: TextStyle(color: themeProvider.textColor),),leading:Icon(Icons.phone_android,color: themeProvider.iconColor,),trailing: Text("$appVersion+$buildNumber",style: TextStyle(color: themeProvider.textColor),),),
                    ListTile(onTap:widget.server,title: Text(trs.translate('server_settings')??"Server settings",style: TextStyle(color: themeProvider.textColor),),leading:Icon(Icons.network_locked_outlined,color: themeProvider.iconColor,),trailing:IconButton(onPressed: widget.server,icon: Icon(Icons.arrow_forward_ios_sharp,color: themeProvider.iconColor,),),
                    ),
                    ListTile(onTap:widget.synch,title: Text(trs.translate('sync')??"Synchronization",style: TextStyle(color: themeProvider.textColor),),leading:Icon(Icons.cached_outlined,color: themeProvider.iconColor,),trailing:TextButton(
                      onPressed: widget.synch
                      ,child: Icon(Icons.arrow_forward_ios_sharp,color: themeProvider.iconColor,),),
                    ),
                  ],
                ),
              ),
            ],
          )
          :SingleChildScrollView(
            scrollDirection:Axis.vertical,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 30,bottom: 5),
                  child: Row(
                    children: [
                      Visibility(visible:widget.visible,child: Transform.translate(
                        offset: const Offset(-22, 0),
                        child: TextButton(
                            onPressed: widget.goBack,
                            child: Icon(Icons.arrow_back,color: themeProvider.iconColor,size: 30,)),
                      )),
                      widget.visible?Transform.translate(offset: const Offset(-22, 0),child: Text(trs.translate('settings')??"Settings",style: TextStyle(fontSize:19,color: themeProvider.textColor),)):Text(trs.translate('settings')??"Settings",style: TextStyle(fontSize:19,color: themeProvider.textColor),),
                      SizedBox(width: widget.visible? 85 : 140,),
                      IconButton(onPressed: () async{
                        i++;
                        if(i==1){
                          final prefs = await SharedPreferences.getInstance();
                          if(prefs.containsKey("password") && prefs.containsKey("confirm")) {
                            clearData();
                          }
                        }
                        else if(i==2){
                          setState(() {
                            _displayTextInputDialog(context,themeProvider.textColor,themeProvider.borderColor,themeProvider.fillColor,themeProvider.focusColor);
                          });
                        }
                      }, icon: lockIcon,color: themeProvider.iconColor,iconSize: 25,),
                      const Spacer(),
                      Icon(Icons.settings,color: themeProvider.iconColor,size: 25,)
                    ],
                  ),
                ),
                Divider(height: 2,color: themeProvider.dividerColor,),
                SizedBox(
                  height: 280,
                  child: ListView(
                    scrollDirection: Axis.vertical,
                    children: [
                      ListTile(onTap:widget.profile,title: Text(trs.translate('profile')??"My profile",style: TextStyle(color: themeProvider.textColor),), leading: Icon(Icons.person_outline_sharp,color: themeProvider.iconColor),trailing:IconButton(onPressed: widget.profile,
                          icon: const Icon(Icons.arrow_forward_ios_sharp),color: themeProvider.iconColor),
                      ),
                      ListTile(title: Text(trs.translate('theme')??"Theme of the program",style: TextStyle(color: themeProvider.textColor),),leading: Icon(Icons.mode,color: themeProvider.iconColor,),trailing: const ChangeThemeButtonWidget(),),
                      ListTile(title: Text(trs.translate('language')??"Interface language",style: TextStyle(color: themeProvider.textColor),),leading:Icon(Icons.language,color: themeProvider.iconColor,),onTap: (){
                        setState(() {
                          isVisible=!isVisible;
                        });
                      }),
                      Visibility(
                        visible: isVisible,
                        child: DropdownButton(
                          dropdownColor: themeProvider.fillColor,
                          padding: const EdgeInsets.only(left:20,right:30),
                          value: dropdownvalue,
                          isExpanded: true,
                          iconSize: 35,
                          icon:  Icon(Icons.keyboard_arrow_down,color: themeProvider.iconColor,),
                          items: items.map((String items) {
                            return DropdownMenuItem(
                              value: items,
                              child: Text(items,style: TextStyle(color: themeProvider.textColor),),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              dropdownvalue = newValue!;
                              BlocProvider.of<LanguageBloc>(context).add(
                                  LanguageSelected(newValue));
                            });

                          },
                        ),
                      ),
                      ListTile(title: Text(trs.translate('version')??"Program version",style: TextStyle(color: themeProvider.textColor),),leading:Icon(Icons.phone_android,color: themeProvider.iconColor,),trailing: Text("$appVersion+$buildNumber",style: TextStyle(color: themeProvider.textColor),),),
                      ListTile(onTap:widget.server,title: Text(trs.translate('server_settings')??"Server settings",style: TextStyle(color: themeProvider.textColor),),leading:Icon(Icons.network_locked_outlined,color: themeProvider.iconColor,),trailing:IconButton(onPressed: widget.server,icon: Icon(Icons.arrow_forward_ios_sharp,color: themeProvider.iconColor,),),
                      ),
                      ListTile(onTap:widget.synch,title: Text(trs.translate('sync')??"Synchronization",style: TextStyle(color: themeProvider.textColor),),leading:Icon(Icons.cached_outlined,color: themeProvider.iconColor,),trailing:TextButton(
                        onPressed: widget.synch
                        ,child: Icon(Icons.arrow_forward_ios_sharp,color: themeProvider.iconColor,),),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Future<void> _displayTextInputDialog(BuildContext context,Color textColor,Color borderColor,Color fillColor,Color focusColor) async {
    final trs = AppLocalizations.of(context);
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: fillColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
          ),
          title: Text(trs.translate('user_pass')??"User's password",style:TextStyle(color: textColor)),
          content: SizedBox(
            height:140,
            child: Column(
              children: [
                TextField(
                  controller: passwordController,
                  style: TextStyle(color: textColor),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: fillColor,
                    focusColor: focusColor,
                    border: UnderlineInputBorder(
                      borderSide:  BorderSide(color: borderColor, width: 2.0),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide:  BorderSide(color: borderColor, width: 2.0),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: borderColor, width: 2.0),
                    ),
                    labelText:trs.translate('password')??'Password',labelStyle:  TextStyle(color: borderColor),
                    hintText: primaryFocus!.hasFocus? '':trs.translate('password')??'Password',
                    hintStyle:  TextStyle(color: borderColor),
                  ),
                    keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                ),
                Padding(
                  padding: const EdgeInsets.only(top:8),
                  child: TextField(
                    controller: confirmController,
                    style: TextStyle(color: textColor),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: fillColor,
                      focusColor: focusColor,
                      border: UnderlineInputBorder(
                        borderSide:  BorderSide(color: borderColor, width: 2.0),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide:  BorderSide(color: borderColor, width: 2.0),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: borderColor, width: 2.0),
                      ),
                      labelText:trs.translate('confirm')??'Confirmation',labelStyle:  TextStyle(color: borderColor),
                      hintText: primaryFocus!.hasFocus? '':trs.translate('confirm')??'Confirmation',
                      hintStyle:  TextStyle(color: borderColor),
                    ),
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(trs.translate('back')??'BACK',style: TextStyle(color:textColor),),
              onPressed: () {
                i=1;
                setState(() {});
                Navigator.pop(context);
              },
            ),
           TextButton(
              child: Text('OK',style: TextStyle(color:textColor),),
              onPressed: () {
        SharedPreferences.getInstance().then((prefs) async {
          if(passwordController.text=="" || confirmController.text==""){
            null;
          }
          else if((passwordController.text==confirmController.text)){
                 i=0;
                 String? pass=prefs.getString("password");
                 String? conf=prefs.getString("confirm");
                  if (kDebugMode) {
                    print("Password:$pass, confirm:$conf");
                  }
                 Navigator.pop(context);
                 await saveInputs(passwordController.text, confirmController.text);
                 lockIcon=const Icon(Icons.lock_outline_sharp);
                 setState(() {});
                  }
               else{
                  null;
                }
              },
        );
              }
            ),
          ],
        );
      },
    );
  }
  Future<void> saveInputs(String password,String confirm) async{
    SharedPreferences.getInstance().then((prefs){
      prefs.setString("password",password);
      prefs.setString("confirm",confirm);

    });
  }
  Future<void> clearData()  async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}

