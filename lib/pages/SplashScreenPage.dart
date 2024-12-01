// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurantmenu/helpers/SharedPrefKeys.dart';
import 'package:restaurantmenu/helpers/dbHelper.dart';
import 'package:restaurantmenu/helpers/enums.dart';
import 'package:restaurantmenu/helpers/localization.dart';
import 'package:restaurantmenu/models/providerModel.dart';
import 'package:restaurantmenu/models/tbl_dk_res_category.dart';
import 'package:restaurantmenu/models/v_dk_resource.dart';
import 'package:restaurantmenu/pages/HomePage.dart';
import 'package:restaurantmenu/pages/ProductDetailPage.dart';
import 'package:restaurantmenu/pages/ProductsPage.dart';
import 'package:restaurantmenu/pages/ServerSettingsPage.dart';
import 'package:restaurantmenu/widgets/GlassMorphism.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({super.key});

  @override
  SplashScreenPageState createState() => SplashScreenPageState();
}

class SplashScreenPageState extends State<SplashScreenPage> with SingleTickerProviderStateMixin {
  bool isLoaded = false;
  int tryLoadCount = 0;
  AnimationController? _controller;
  String host = '';
  int port = 1433;
  String dbName = '';
  String dbUName = '';
  String dbUPass = '';
  Status connectingToLocalDb = Status.initial, loadingFromDb = Status.initial;
  Device _deviceType = Device.mobile;
  String initialPage='HomePage';

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 1));

    loadingData().then((value) {
      isLoaded = value;
      if (!isLoaded) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const ServerSettingsPage(),
        ));
      }
        if(initialPage=="HomePage") {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => const HomePage(),
          ));
        }
        else if(initialPage=="ProductsPage"){
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) =>const ProductsPage(null),
          ));
        }
        else{
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) =>const ProductDetailPage(null,null),
          ));
        }
    });
  }

  @override
  void dispose() {
    if (_controller != null) _controller?.dispose();
    super.dispose();
  }

  Future<bool> loadingData() async {
    final providerModel = Provider.of<ProviderModel>(context, listen: false);
    int jobsRemained = 2;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    host = prefs.getString(SharedPrefKeys.serverAddress) ?? "";
    port = prefs.getInt(SharedPrefKeys.serverPort) ?? 1433;
    dbName = prefs.getString(SharedPrefKeys.dbName) ?? "";
    dbUName = prefs.getString(SharedPrefKeys.dbUName) ?? "";
    dbUPass = prefs.getString(SharedPrefKeys.dbUPass) ?? "";
    providerModel.setHost = host;
    providerModel.setPort = port;
    providerModel.setDbName = dbName;
    providerModel.setDbUName = dbUName;
    providerModel.setDbUPass = dbUPass;
    initialPage=prefs.getString(SharedPrefKeys.initialPage)?? "HomePage";

    if (host.isEmpty || dbUName.isEmpty || dbName.isEmpty || dbUPass.isEmpty) {
      return false;
    }

    while (jobsRemained > 0) {
      //region ConnectingToDb
      if (connectingToLocalDb == Status.initial) {
        try {
          setState(() {
            connectingToLocalDb = Status.onProgress;
          });
          await DbHelper.init();
          setState(() {
            connectingToLocalDb = Status.completed;
          });
          jobsRemained--;
        } catch (e) {
          setState(() {
            connectingToLocalDb = Status.failed;
          });
          jobsRemained--;
          debugPrint("PrintError - SplashScreen.LoadingData: $e");
        }
      }
      //endregion ConnectingToDb

      //region LoadResources
      if (loadingFromDb == Status.initial) {
        setState(() {
          loadingFromDb = Status.onProgress;
        });
        List<VDkResource> listVDkResource = [];
        try {
          int resPriceGroupId = 0;
          try {
            resPriceGroupId = prefs.getInt(SharedPrefKeys.resPriceGroupId) ?? 1;
          } catch (e) {
            debugPrint("PrintError SplashScreenPage.loadingData: ${e.toString()}");
          }

          await DbHelper.queryVResource(resPriceGroupId).then((v) async {
            if (v.isNotEmpty) {
              v.sort((a, b) => a.ResCatId.compareTo(b.ResCatId));
              providerModel.setResources = v;
              listVDkResource = v;
              debugPrint("Print getting Resources done");
            } else {
              debugPrint("Print Resources empty");
            }

            //region Load ResCategories

            try {
              debugPrint("Print try getting ResCategories from db");
              await DbHelper.queryAllRows("tbl_dk_res_category").then((v) async {
                if (v.isNotEmpty) {
                  List<TblDkResCategory> categoriesList = v
                      .where((e) => listVDkResource.where((element) => element.ResCatId == TblDkResCategory.fromMap(e).ResCatId).isNotEmpty)
                      .map((e) => TblDkResCategory.fromMap(e))
                      .toList();
                  categoriesList.sort((a, b) => a.ResCatId.compareTo(b.ResCatId));
                  providerModel.setResCategories = categoriesList;
                  debugPrint("Print getting ResCategories done");
                } else {
                  debugPrint("Print ResCategories empty");
                }
                jobsRemained--;
              });
            } catch (e) {
              jobsRemained--;
              debugPrint("Print error getting ResCategories (${e.toString()})");
            }
            //endregion
          });

          setState(() {
            loadingFromDb = Status.completed;
          });
        } catch (e) {
          setState(() {
            loadingFromDb = Status.failed;
          });
          debugPrint("Print error getting Resources (${e.toString()})");
        }
      }
      //endregion LoadResources

      await Future.delayed(const Duration(milliseconds: 300));
    }
    return (jobsRemained <= 0);
  }

  Widget setStatus(Status status) {
    Widget widget = const SizedBox.shrink();
    switch (status) {
      case Status.initial:
        widget = const SizedBox.shrink();
        break;
      case Status.onProgress:
        widget = const SizedBox(
          height: 18.0,
          width: 18.0,
          child: CircularProgressIndicator(),
        );
        break;
      case Status.completed:
        widget = const Icon(
          Icons.check,
          color: Colors.green,
        );
        break;
      case Status.failed:
        widget = const Icon(
          Icons.close,
          color: Colors.red,
        );
        break;
      default:
        widget = const SizedBox.shrink();
    }
    return widget;
  }

  @override
  Widget build(BuildContext context) {
    final trs = AppLocalizations.of(context);
    Orientation orientation=MediaQuery.of(context).orientation;
    _deviceType = (MediaQuery.of(context).size.width < 800) ? Device.mobile : Device.tablet;
    final double height = MediaQuery.of(context).size.height;
    final double fontSize = height >= 550 ? 16 : 14;
    if (_controller != null) _controller?.forward();
    return (!isLoaded)
        ? Scaffold(
            body: (_deviceType==Device.tablet) ?
            Stack(children: [
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/SplashScreen.JPG"),
                    fit: BoxFit.cover,
                  ),
                ),
                alignment: const Alignment(0, 0),
                child: const GlassMorphism(
                  width: 425,
                  height: 273,
                  child: Align(
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Text(
                          "RESTO",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 91,
                            color: Colors.yellow,
                          ),
                        ),
                        Text(
                          "MENU",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 96,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                  top: 15,
                  left: 15,
                  child: GlassMorphism(
                    width: 320,
                    height: 180,
                    child: ListView(
                      children: [
                        _widget(trs.translate('connecting_to_db')??'Connecting to db', connectingToLocalDb, fontSize),
                        _widget(trs.translate('loading_data_from_db')??'Loading data from DB', loadingFromDb, fontSize),
                      ],
                    ),
                  ))
            ]):
            (orientation==Orientation.landscape) ?
            Stack(children: [
              Container(
                constraints: const BoxConstraints.expand(),
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/SplashScreen.JPG"),
                    fit: BoxFit.cover,
                  ),
                ),
                alignment: const Alignment(0.3,0.2),
                child: const GlassMorphism(
                  width: 350,
                  height: 273,
                  child: Align(
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Text(
                          "SAP",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 91,
                            color: Colors.yellow,
                          ),
                        ),
                        Text(
                          "MENU",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 96,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                  top: 15,
                  left: 15,
                  child: GlassMorphism(
                    width: 240,
                    height: 180,
                    child: ListView(
                      children: [
                        _widget(trs.translate('connecting_to_db')??'Connecting to db', connectingToLocalDb, fontSize),
                        _widget(trs.translate('loading_data_from_db')??'Loading data from DB', loadingFromDb, fontSize),
                      ],
                    ),
                  ))
            ])
            :Stack(children: [
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/SplashScreen.JPG"),
                    fit: BoxFit.cover,
                  ),
                ),
                alignment: const Alignment(0, 0),
                child: GlassMorphism(
                  width: 425,
                  height: 273,
                  child: Align(
                    alignment: Alignment.center,
                    child: Image.asset(
                        "assets/images/sap_menu.png",
                        // fit:BoxFit.cover
                    ),
                  ),
                ),
              ),
              Positioned(
                  top: 15,
                  left: 15,
                  child: GlassMorphism(
                    width: 320,
                    height: 180,
                    child: ListView(
                      children: [
                        _widget(trs.translate('connecting_to_db')??'Connecting to db', connectingToLocalDb, fontSize),
                        _widget(trs.translate('loading_data_from_db')??'Loading data from DB', loadingFromDb, fontSize),
                      ],
                    ),
                  ))
            ]),
          )
        : const SizedBox.shrink();
  }

  Widget _widget(String text, Status status, double fontSize) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                text,
                style: TextStyle(fontSize: fontSize, color: Colors.yellow, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          setStatus(status),
        ],
      ),
    );
  }
}
