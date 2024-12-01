// ignore_for_file: file_names, use_build_context_synchronously

import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurantmenu/helpers/enums.dart';
import 'package:restaurantmenu/helpers/localization.dart';
import 'package:restaurantmenu/models/providerModel.dart';
import 'package:restaurantmenu/bloc/LanguageBloc.dart';
import 'package:restaurantmenu/models/tbl_dk_cart_item.dart';
import 'package:restaurantmenu/models/tbl_dk_res_category.dart';
import 'package:restaurantmenu/models/v_dk_resource.dart';
import 'package:restaurantmenu/modules/CartDrawer.dart';
import 'package:restaurantmenu/modules/InnerPageViewDrawer.dart';
import 'package:restaurantmenu/pages/HomePage.dart';
import 'package:restaurantmenu/pages/ProductDetailPage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../ThemeProvider.dart';

class ProductsPage extends StatefulWidget {
  final TblDkResCategory ? selectedCategory;

  const ProductsPage(this.selectedCategory, {Key? key}) : super(key: key);

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  Color enableColor = const Color(0xffFED931);
  Color disableColor = const Color(0xffFFFFFF);
  int drawerIndex = 0;
  int langIndex = 0;
  Device _deviceType = Device.mobile;
  late ProductsTabBar myHandler;
  late TabController _controller;
  late bool lockIcon;
  late List<TblDkCartItem> items;

  @override
  void initState() {
    super.initState();
    setItems();
    _controller = TabController(
        initialIndex: (widget.selectedCategory==null)?0:
            context.read<ProviderModel>().getResCategories.indexWhere((element) => element.ResCatId == widget.selectedCategory!.ResCatId),
        length: context.read<ProviderModel>().getResCategories.length,
        vsync: this);
    myHandler =
        ProductsTabBar(context.read<ProviderModel>().getResCategories[0], context.read<ProviderModel>().getResources, _deviceType, setItems);
    _controller.addListener(_handleSelected);
    lockIcon = false;
  }

  @override
  void dispose(){
    super.dispose();
    _controller.dispose();
  }

  void setItems() {
    setState(() {
      items = context.read<ProviderModel>().getCartItems;
    });
  }

  void _handleSelected() {
    setState(() {
      myHandler = ProductsTabBar(
          context.read<ProviderModel>().getResCategories[_controller.index],
          context
              .read<ProviderModel>()
              .getResources
              .where((element) => element.ResCatId == context.read<ProviderModel>().getResCategories[_controller.index].ResCatId)
              .toList(),
          _deviceType,
          setItems);
    });
  }

  final List<Widget> drawers = [
    const CartDrawer(),
    const InnerPageViewDrawer(
      visible: false,
      isHome: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final ProviderModel providerModel = Provider.of<ProviderModel>(context);
    final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    _deviceType = (MediaQuery.of(context).size.width < 800) ? Device.mobile : Device.tablet;
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const HomePage(),
        ));
      },
      child: DefaultTabController(
        length: context.read<ProviderModel>().getResCategories.length,
        child: SafeArea(
          child: Scaffold(
            onEndDrawerChanged: (isOpen) {
              if (!isOpen) {
                setState(() {
                  drawerIndex = 0;
                });
              }
            },
            key: _key,
            endDrawer: drawers[drawerIndex],
            appBar: AppBar(
              elevation: 0,
              backgroundColor: themeProvider.appBarColor,
              leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const HomePage(),
                  ));
                },
                icon: const Icon(Icons.arrow_back),
                color: themeProvider.iconColor,
                iconSize: 30,
              ),
              flexibleSpace: SizedBox(
                height: 90,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TabBar(
                      tabs: providerModel.getResCategories.map<Tab>((TblDkResCategory cat) {
                        return Tab(text: cat.ResCatName);
                      }).toList(),
                      labelColor: themeProvider.labelColor,
                      controller: _controller,
                      isScrollable: true,
                      labelPadding: const EdgeInsets.symmetric(horizontal: 20),
                      indicatorColor: Colors.yellow,
                      labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      indicator: UnderlineTabIndicator(
                        borderSide: const BorderSide(
                          width: 4.0,
                          color: Color(0xffFED931),
                        ),
                        borderRadius: BorderRadius.circular(16),
                        insets: const EdgeInsets.only(top: 50),
                      ),
                      indicatorSize: TabBarIndicatorSize.label,
                      unselectedLabelColor: themeProvider.unselectedLabelColor,
                      unselectedLabelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                    ),
                    Divider(indent: 70, endIndent: 100, color: themeProvider.dividerColor, height: 2, thickness: 2),
                  ],
                ),
              ),
              actions: [
               const SizedBox.shrink(),
                (_deviceType == Device.tablet)
                    ? Container(
                        height: double.infinity,
                        width: 87,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(topLeft: Radius.circular(32)),
                          color: themeProvider.boxColor,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 18),
                          child: IconButton(
                              onPressed: () {
                                setState(() {
                                  drawerIndex = 0;
                                });
                                _key.currentState!.openEndDrawer();
                              },
                              icon: SvgPicture.asset("assets/images/Vectorcart.svg",
                                  fit: BoxFit.cover, colorFilter: const ColorFilter.mode(Colors.yellow, BlendMode.srcIn)),
                              iconSize: 50),
                        ),
                      )
                    : Container(
                        height: double.infinity,
                        width: 70,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(topLeft: Radius.circular(32)),
                          color: themeProvider.boxColor,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 18),
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                drawerIndex = 0;
                              });
                              _key.currentState!.openEndDrawer();
                            },
                            icon: SvgPicture.asset("assets/images/Vectorcart.svg",
                                fit: BoxFit.cover, colorFilter: const ColorFilter.mode(Colors.yellow, BlendMode.srcIn), height: 20, width: 20),
                          ),
                        ),
                      ),
              ],
            ),
            body: Scaffold(
                appBar: AppBar(
                  elevation: 0,
                  automaticallyImplyLeading: false,
                  backgroundColor: themeProvider.appBarColor,
                  title: (_deviceType == Device.tablet)
                      ? Padding(
                          padding: const EdgeInsets.only(left: 60.0, top: 25),
                          child: Text(myHandler.resCategory.ResCatName, style: TextStyle(color: themeProvider.textColor, fontSize: 20)))
                      : (MediaQuery.of(context).orientation==Orientation.landscape)? Padding(
                          padding: const EdgeInsets.only(left: 60.0),
                          child: Text(myHandler.resCategory.ResCatName, style: TextStyle(color: themeProvider.textColor, fontSize: 20)))
                      : Column(
                        // mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top:30.0,left:10),
                            child: Text(myHandler.resCategory.ResCatName, style: TextStyle(color: themeProvider.textColor, fontSize: 15)),
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(5, 0, 5, 20),
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
                                padding: const EdgeInsets.fromLTRB(5, 0, 5, 20),
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
                                padding: const EdgeInsets.fromLTRB(5, 0, 0, 20),
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
                            ],
                          )
                        ],
                      ),
                  actions: [
                    (_deviceType == Device.tablet)? Row(
                      children: [
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
                         Container(
                                alignment: Alignment.topRight,
                                height: double.infinity,
                                width: 87,
                                decoration: BoxDecoration(
                                  color: themeProvider.boxColor,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: const Offset(0, 3), // changes position of shadow
                                    ),
                                  ],
                                ),
                              )
                      ],
                    )
                    :(MediaQuery.of(context).orientation==Orientation.landscape)? Row(
                      children: [
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
                         Container(
                          alignment: Alignment.topRight,
                          height: double.infinity,
                          width: 70,
                          decoration: BoxDecoration(
                            color: themeProvider.boxColor,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: const Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                        )
                      ],
                    )
                    :Container(
                      alignment: Alignment.topRight,
                      height: double.infinity,
                      width: 70,
                      decoration: BoxDecoration(
                        color: themeProvider.boxColor,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                body: Row(
                  children: [
                    Expanded(
                      child: TabBarView(
                        controller: _controller,
                        children: providerModel.getResCategories.map<Widget>((TblDkResCategory category) {
                          return ProductsTabBar(
                              category,
                              providerModel.getResources.where((element) => element.ResCatId == category.ResCatId).toList(),
                              _deviceType,
                              setItems);
                        }).toList(),
                      ),
                    ),
                    (_deviceType == Device.tablet)
                        ? Container(
                            height: double.infinity,
                            width: 87,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(32)),
                              color: themeProvider.boxColor,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: items.isEmpty ? 0 : items.length,
                                    physics: const BouncingScrollPhysics(),
                                    itemBuilder: (BuildContext context, int index1) {
                                      return Padding(
                                        padding: const EdgeInsets.only(top: 10, left: 15, right: 15),
                                        child: GestureDetector(
                                          onPanUpdate: (details) {
                                            if (details.delta.dx < 0) {
                                              setState(() {
                                                drawerIndex = 0;
                                              });
                                              _key.currentState!.openEndDrawer();
                                            }
                                          },
                                          child: Badge.count(
                                            largeSize: 20,
                                            textStyle: const TextStyle(fontSize: 14),
                                            alignment: Alignment.topRight,
                                            count: items[index1].ItemCount,
                                            child: Container(
                                              clipBehavior: Clip.antiAlias,
                                              decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(16))),
                                              child: (items[index1].ImageFilePath.isEmpty)
                                                  ? Image.asset(
                                                      'assets/images/noFoodImage.jpg',
                                                      fit: BoxFit.cover,
                                                    )
                                                  : Image.file(
                                                      File(items[index1].ImageFilePath),
                                                      fit: BoxFit.cover,
                                                    ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: 70,
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 7),
                                    child: IconButton(
                                      onPressed: () async {
                                        setState(() {
                                          drawerIndex = 1;
                                        });
                                        final prefs = await SharedPreferences.getInstance();
                                        if (prefs.containsKey("password") && prefs.containsKey("confirm")) {
                                          inputDialog(context, themeProvider, _key);
                                          lockIcon = true;
                                        } else {
                                          _key.currentState!.openEndDrawer();
                                        }
                                      },
                                      icon: const Icon(Icons.settings),
                                      color: Colors.yellow,
                                      iconSize: 35,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Container(
                            height: double.infinity,
                            width: 70,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(32)),
                              color: themeProvider.boxColor,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: items.isEmpty ? 0 : items.length,
                                    physics: const BouncingScrollPhysics(),
                                    itemBuilder: (BuildContext context, int index1) {
                                      return Padding(
                                        padding: const EdgeInsets.only(top: 10, left: 15, right: 15),
                                        child: GestureDetector(
                                          onPanUpdate: (details) {
                                            if (details.delta.dx < 0) {
                                              setState(() {
                                                drawerIndex = 0;
                                              });
                                              _key.currentState!.openEndDrawer();
                                            }
                                          },
                                          child: Badge.count(
                                            largeSize: 20,
                                            textStyle: const TextStyle(fontSize: 14),
                                            alignment: Alignment.topRight,
                                            count: items[index1].ItemCount,
                                            child: Container(
                                              clipBehavior: Clip.antiAlias,
                                              height: 40,
                                              decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(16))),
                                              child: (items[index1].ImageFilePath.isEmpty)
                                                  ? Image.asset('assets/images/noFoodImage.jpg', fit: BoxFit.cover)
                                                  : Image.file(
                                                      File(items[index1].ImageFilePath),
                                                      fit: BoxFit.cover,
                                                    ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: 70,
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 7),
                                    child: IconButton(
                                      onPressed: () async {
                                        setState(() {
                                          drawerIndex = 1;
                                        });
                                        final prefs = await SharedPreferences.getInstance();
                                        if (prefs.containsKey("password") && prefs.containsKey("confirm")) {
                                          inputDialog(context, themeProvider, _key);
                                          lockIcon = true;
                                        } else {
                                          _key.currentState!.openEndDrawer();
                                        }
                                      },
                                      icon: const Icon(Icons.settings),
                                      color: Colors.yellow,
                                      iconSize: 30,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ],
                )),
          ),
        ),
      ),
    );
  }
}

Future<void> inputDialog(BuildContext context, ThemeProvider themeProvider, GlobalKey<ScaffoldState> key) async {
  final trs = AppLocalizations.of(context);
  TextEditingController passwordController = TextEditingController();
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: themeProvider.fillColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: Text(trs.translate('enter_password') ?? 'Enter your password!', style: TextStyle(color: themeProvider.textColor)),
        content: TextField(
          controller: passwordController,
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
            labelText: trs.translate('password') ?? 'Password',
            labelStyle: TextStyle(color: themeProvider.borderColor),
            hintText: primaryFocus!.hasFocus ? '' : trs.translate('password') ?? 'Password',
            hintStyle: TextStyle(color: themeProvider.borderColor),
          ),
          keyboardType: TextInputType.visiblePassword,
          obscureText: true,
        ),
        actions: <Widget>[
          TextButton(
            child: Text(
              trs.translate('back') ?? 'Back',
              style: TextStyle(color: themeProvider.textColor),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          TextButton(
              child: Text(
                'OK',
                style: TextStyle(color: themeProvider.textColor),
              ),
              onPressed: () async {
                SharedPreferences.getInstance().then(
                  (prefs) {
                    String? password = prefs.getString("password");
                    if ((passwordController.text == password)) {
                      Navigator.pop(context);
                      key.currentState!.openEndDrawer();
                    } else {
                      passwordController.clear();
                    }
                  },
                );
              }),
        ],
      );
    },
  );
}

class ProductsTabBar extends StatelessWidget {
  final TblDkResCategory resCategory;
  final List<VDkResource> resources;
  final Device deviceType;
  final VoidCallback setItems;

  const ProductsTabBar(this.resCategory, this.resources, this.deviceType, this.setItems, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return (deviceType == Device.tablet)
        ? GridView.builder(
            padding: const EdgeInsets.all(23),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 1.3,
                mainAxisSpacing: 10,
                crossAxisCount: (MediaQuery.of(context).orientation == Orientation.portrait) ? 2 : 4),
            itemCount: resources.length,
            itemBuilder: (context, index) {
              return Product(resources[index], deviceType, resCategory, setItems);
            },
          )
        : GridView.builder(
            padding: const EdgeInsets.all(23),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 1.3,
                mainAxisSpacing: 10,
                crossAxisCount: (MediaQuery.of(context).orientation == Orientation.portrait) ? 2 : 3),
            itemCount: resources.length,
            itemBuilder: (context, index) {
              return Product(resources[index], deviceType, resCategory, setItems);
            },
          );
  }
}

class Product extends StatefulWidget {
  final VDkResource resource;
  final TblDkResCategory resCategory;
  final Device deviceType;
  final VoidCallback setItems;

  const Product(this.resource, this.deviceType, this.resCategory, this.setItems, {Key? key}) : super(key: key);

  @override
  State<Product> createState() => _ProductState();
}

class _ProductState extends State<Product> {
  @override
  Widget build(BuildContext context) {
    final trs = AppLocalizations.of(context);
    dynamic cartButtonColor;
    if (Provider.of<ThemeProvider>(context).darkMode) {
      cartButtonColor = const Color(0xffFFA500);
    }
    if (Provider.of<ThemeProvider>(context).darkMode == false) {
      cartButtonColor = const Color(0xffFFA500);
    }
    String formattedPrice = widget.resource.SalePrice.toStringAsFixed(2);
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 500),
            pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
              return ProductDetailPage(widget.resource, widget.resCategory);
            },
            transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
              return Align(
                child: FadeTransition(
                  opacity: animation,
                  child: child,
                ),
              );
            },
          ),
        );
      },
      child: Padding(
          padding: const EdgeInsets.all(10),
          child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
              child: Stack(
                children: [
                  Hero(
                    tag: widget.resource.ResName,
                    child: Container(
                      width: 295,
                      height: 220,
                      decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(16))),
                      child: (widget.resource.ImageFilePath.isEmpty)
                          ? Image.asset('assets/images/noFoodImage.jpg', fit: BoxFit.cover)
                          : Image.file(
                              File(widget.resource.ImageFilePath),
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: (widget.deviceType == Device.tablet)
                        ? Container(
                            width: 57.5,
                            height: 50,
                            decoration: BoxDecoration(
                                color: cartButtonColor,
                                borderRadius: const BorderRadius.only(topRight: Radius.circular(16), bottomLeft: Radius.circular(16))),
                            child: IconButton(
                              onPressed: () {
                                if (context
                                    .read<ProviderModel>()
                                    .getCartItems
                                    .where((element) => element.ResId == widget.resource.ResId)
                                    .isNotEmpty) {
                                  TblDkCartItem cartItem = context
                                      .read<ProviderModel>()
                                      .getCartItems
                                      .where((element) => element.ResId == widget.resource.ResId)
                                      .first;
                                  context.read<ProviderModel>().getCartItems[context
                                          .read<ProviderModel>()
                                          .getCartItems
                                          .indexWhere((element) => element.ResId == widget.resource.ResId)] =
                                      context
                                          .read<ProviderModel>()
                                          .getCartItems
                                          .where((element) => element.ResId == widget.resource.ResId)
                                          .first
                                          .copyWith(
                                              ItemCount: cartItem.ItemCount + 1,
                                              ItemPriceTotal: (cartItem.ItemCount + 1) * cartItem.ResPriceValue);
                                  widget.setItems();
                                } else {
                                  context.read<ProviderModel>().getCartItems.add(TblDkCartItem(
                                      ResId: widget.resource.ResId,
                                      ResRegNo: '',
                                      ResName: widget.resource.ResName,
                                      ResNameTm: widget.resource.ResNameTm,
                                      ResNameRu: widget.resource.ResNameRu,
                                      ResNameEn: widget.resource.ResNameEn,
                                      ItemCount: 1,
                                      ResPriceGroupId: 0,
                                      ResPriceValue: widget.resource.SalePrice,
                                      ItemPriceTotal: widget.resource.SalePrice,
                                      ResPendingTotalAmount: 0,
                                      ImageFilePath: widget.resource.ImageFilePath,
                                      SyncDateTime: null));
                                  widget.setItems();
                                }
                              },
                              icon: SvgPicture.asset(
                                "assets/images/Vectorcart.svg",
                                colorFilter: const ColorFilter.mode(Colors.red, BlendMode.srcIn),
                                fit: BoxFit.cover,
                                width: 30,
                                height: 30,
                              ),
                            ),
                          )
                        : Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                                color: cartButtonColor,
                                borderRadius: const BorderRadius.only(topRight: Radius.circular(16), bottomLeft: Radius.circular(16))),
                            child: IconButton(
                              onPressed: () {
                                if (context
                                    .read<ProviderModel>()
                                    .getCartItems
                                    .where((element) => element.ResId == widget.resource.ResId)
                                    .isNotEmpty) {
                                  TblDkCartItem cartItem = context
                                      .read<ProviderModel>()
                                      .getCartItems
                                      .where((element) => element.ResId == widget.resource.ResId)
                                      .first;
                                  context.read<ProviderModel>().getCartItems[context
                                          .read<ProviderModel>()
                                          .getCartItems
                                          .indexWhere((element) => element.ResId == widget.resource.ResId)] =
                                      context
                                          .read<ProviderModel>()
                                          .getCartItems
                                          .where((element) => element.ResId == widget.resource.ResId)
                                          .first
                                          .copyWith(
                                              ItemCount: cartItem.ItemCount + 1,
                                              ItemPriceTotal: (cartItem.ItemCount + 1) * cartItem.ResPriceValue);
                                  widget.setItems();
                                } else {
                                  context.read<ProviderModel>().getCartItems.add(TblDkCartItem(
                                      ResId: widget.resource.ResId,
                                      ResRegNo: '',
                                      ResName: widget.resource.ResName,
                                      ResNameTm: widget.resource.ResNameTm,
                                      ResNameRu: widget.resource.ResNameRu,
                                      ResNameEn: widget.resource.ResNameEn,
                                      ItemCount: 1,
                                      ResPriceGroupId: 0,
                                      ResPriceValue: widget.resource.SalePrice,
                                      ItemPriceTotal: widget.resource.SalePrice,
                                      ResPendingTotalAmount: 0,
                                      ImageFilePath: widget.resource.ImageFilePath,
                                      SyncDateTime: null));
                                  widget.setItems();
                                }
                              },
                              icon: SvgPicture.asset(
                                "assets/images/Vectorcart.svg",
                                colorFilter: const ColorFilter.mode(Colors.red, BlendMode.srcIn),
                                fit: BoxFit.cover,
                                width: 30,
                                height: 30,
                              ),
                            ),
                          ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: ClipRRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                        child: (widget.deviceType == Device.tablet)
                            ? Container(
                                width: 295,
                                height: 63,
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.1),
                                    borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(16), bottomRight: Radius.circular(16))),
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 2, left: 12),
                                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                    Text("$formattedPrice TMT",
                                        style: const TextStyle(
                                          fontSize: 20,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        )),
                                    FittedBox(
                                      fit: BoxFit.fitWidth,
                                      child: Text(
                                          ((trs.locale.languageCode == 'tk')
                                                      ? widget.resource.ResNameTm
                                                      : (trs.locale.languageCode == 'ru')
                                                          ? widget.resource.ResNameRu
                                                          : widget.resource.ResNameEn)
                                                  .isNotEmpty
                                              ? (trs.locale.languageCode == 'tk')
                                                  ? widget.resource.ResNameTm
                                                  : (trs.locale.languageCode == 'ru')
                                                      ? widget.resource.ResNameRu
                                                      : widget.resource.ResNameEn
                                              : widget.resource.ResName,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                          )),
                                    ),
                                  ]),
                                ),
                              )
                            : Container(
                                width: 200,
                                height: 40,
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.1),
                                    borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(16), bottomRight: Radius.circular(16))),
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 2, left: 12),
                                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                    Text("$formattedPrice TMT",
                                        style: const TextStyle(
                                          fontSize: 15,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        )),
                                    Expanded(
                                      child: Text(
                                          ((trs.locale.languageCode == 'tk')
                                                      ? widget.resource.ResNameTm
                                                      : (trs.locale.languageCode == 'ru')
                                                          ? widget.resource.ResNameRu
                                                          : widget.resource.ResNameEn)
                                                  .isNotEmpty
                                              ? (trs.locale.languageCode == 'tk')
                                                  ? widget.resource.ResNameTm
                                                  : (trs.locale.languageCode == 'ru')
                                                      ? widget.resource.ResNameRu
                                                      : widget.resource.ResNameEn
                                              : widget.resource.ResName,
                                          style: const TextStyle(
                                            fontSize: 13,
                                            color: Colors.white,
                                          )),
                                    ),
                                  ]),
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ))),
    );
  }
}
