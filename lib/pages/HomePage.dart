// ignore_for_file: file_names

import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:restaurantmenu/ThemeProvider.dart';
import 'package:restaurantmenu/bloc/LanguageBloc.dart';
import 'package:restaurantmenu/helpers/enums.dart';
import 'package:restaurantmenu/helpers/localization.dart';
import 'package:restaurantmenu/models/providerModel.dart';
import 'package:restaurantmenu/models/tbl_dk_res_category.dart';
import 'package:restaurantmenu/modules/InnerPageViewDrawer.dart';
import 'package:restaurantmenu/pages/ProductsPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int langIndex = 0;
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  Device _deviceType = Device.mobile;

  @override
  Widget build(BuildContext context) {
    final trs = AppLocalizations.of(context);
    Size screenSize = MediaQuery.of(context).size;
    _deviceType = (screenSize.width < 800) ? Device.mobile : Device.tablet;
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    ProviderModel providerModel = Provider.of<ProviderModel>(context);
    return Scaffold(
      key: _key,
      endDrawer: const InnerPageViewDrawer(visible: false, isHome: true),
      appBar: AppBar(
        backgroundColor: themeProvider.appBarColor,
        elevation: 0,
        title: Text(
          trs.translate('category') ?? 'Category',
          style: TextStyle(
            color: themeProvider.labelColor,
          ),
        ),
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor:langIndex==0 ? Colors.orange: themeProvider.appBarColor,
                padding: const EdgeInsets.all(5),
                minimumSize: const Size(20, 0),
              ),
              onPressed: () {
                setState(() {
                  BlocProvider.of<LanguageBloc>(context).add(LanguageSelected("tk"));
                  langIndex = 0;
                });
              },
              child: SvgPicture.asset(
                "assets/images/TM.svg",
                  width:20,
                  height:20,
                  fit:BoxFit.cover
              ),
            ),
          ),
          VerticalDivider(
            color: themeProvider.dividerColor,
            thickness: 2,
            width: 2,
            indent: 10,
            endIndent: 10,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor:langIndex==1 ? Colors.orange: themeProvider.appBarColor,
                padding: const EdgeInsets.all(5),
                minimumSize: const Size(20, 0),
              ),
              onPressed: () {
                setState(() {
                  BlocProvider.of<LanguageBloc>(context).add(LanguageSelected("en"));
                  langIndex = 1;
                });
              },
              child: SvgPicture.asset(
                "assets/images/US.svg",
                  width:17,
                  height:17,
                fit:BoxFit.cover
              ),
            ),
          ),
          VerticalDivider(
            color: themeProvider.dividerColor,
            thickness: 2,
            width: 0,
            indent: 10,
            endIndent: 10,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(5, 10, 0, 10),
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor:langIndex==2 ? Colors.orange: themeProvider.appBarColor,
    padding: const EdgeInsets.all(5),
    minimumSize: const Size(25, 0),
    ),
              onPressed: () {
                setState(() {
                  BlocProvider.of<LanguageBloc>(context).add(LanguageSelected("ru"));
                  langIndex = 2;
                });
              },
              child: SvgPicture.asset(
                fit: BoxFit.cover,
                "assets/images/RU.svg",
                width:20,
                height:20
              ),
            ),
          ),
          (_deviceType == Device.tablet)
              ? IconButton(
                  padding: const EdgeInsets.only(right: 10),
                  iconSize: 35,
                  onPressed: () {
                    _key.currentState!.openEndDrawer();
                  },
                  icon: const Icon(Icons.settings),
                  color: themeProvider.btnColor,
                )
              : IconButton(
                  padding: const EdgeInsets.only(right: 10),
                  iconSize: 25,
                  onPressed: () {
                    _key.currentState!.openEndDrawer();
                  },
                  icon: const Icon(Icons.settings),
                  color: themeProvider.btnColor,
                ),
        ],
      ),
      body: GridViewWidget(providerModel:providerModel, deviceType: _deviceType),
    );
  }
}
class GridViewWidget extends StatelessWidget {
  final Device deviceType;
  final ProviderModel providerModel;
  const GridViewWidget({Key? key, required this.deviceType, required this.providerModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return (deviceType == Device.tablet)
        ? GridView.builder(
      padding: const EdgeInsets.all(23),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 1.57,
          mainAxisSpacing: 10,
          crossAxisCount: (MediaQuery.of(context).orientation == Orientation.portrait) ? 2 : 4),
      itemCount: providerModel.getResCategories.length,
      itemBuilder: (context, index) {
        return CategoryItem(context.watch<ProviderModel>().getResCategories[index], deviceType);
      },
    )
        : GridView.builder(
      padding: const EdgeInsets.all(23),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 1.57,
          mainAxisSpacing: 10,
          crossAxisCount: (MediaQuery.of(context).orientation == Orientation.portrait) ? 2 : 3),
      itemCount: providerModel.getResCategories.length,
      itemBuilder: (context, index) {
        return CategoryItem(context.watch<ProviderModel>().getResCategories[index], deviceType);
      },
    );
  }
}

class CategoryItem extends StatelessWidget {
  final TblDkResCategory resCat;
  final Device deviceType;

  const CategoryItem(this.resCat, this.deviceType, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final trs = AppLocalizations.of(context);
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => ProductsPage(resCat),
        ));
      },
      child: Padding(
          padding: const EdgeInsets.fromLTRB(2, 2, 4, 2),
          child: Stack(
            children: [
              Positioned.fill(
                child: Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                  child: (resCat.ResCatNameEn == 'All')
                      ? Image.asset(
                          resCat.ResCatIconFilePath,
                          fit: BoxFit.cover,
                        )
                      : (resCat.ResCatIconFilePath.isEmpty)
                          ? SvgPicture.asset('assets/images/NoImage.svg')
                          : Image.file(
                              File(resCat.ResCatIconFilePath),
                              fit: BoxFit.cover,
                            ),
                ),
              ),
              (deviceType == Device.tablet)
                  ? Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        clipBehavior: Clip.hardEdge,
                        height: 49,
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(16), bottomRight: Radius.circular(16))),
                        child: ClipRRect(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.1),
                                  borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(16), bottomRight: Radius.circular(16))),
                              alignment: Alignment.center,
                              child: Center(
                                child: Text(
                                    ((trs.locale.languageCode == 'ru')
                                                ? resCat.ResCatNameRu
                                                : (trs.locale.languageCode == 'tk')
                                                    ? resCat.ResCatNameTm
                                                    : resCat.ResCatNameEn)
                                            .isEmpty
                                        ? resCat.ResCatName
                                        : ((trs.locale.languageCode == 'ru')
                                            ? resCat.ResCatNameRu
                                            : (trs.locale.languageCode == 'tk')
                                                ? resCat.ResCatNameTm
                                                : resCat.ResCatNameEn),
                                    style: const TextStyle(
                                      fontSize: 17.5,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    )),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  : Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        clipBehavior: Clip.hardEdge,
                        height: 40,
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(16), bottomRight: Radius.circular(16))),
                        child: ClipRRect(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 1, sigmaY: 2),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.1),
                                  borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(16), bottomRight: Radius.circular(16))),
                              alignment: Alignment.center,
                              child: Center(
                                child: Text(resCat.ResCatName,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    )),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
            ],
          )),
    );
  }
}
