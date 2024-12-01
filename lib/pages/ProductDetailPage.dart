// ignore_for_file: file_names

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:restaurantmenu/helpers/enums.dart';
import 'package:provider/provider.dart';
import 'package:restaurantmenu/helpers/localization.dart';
import 'package:restaurantmenu/models/providerModel.dart';
import 'package:restaurantmenu/models/tbl_dk_cart_item.dart';
import 'package:restaurantmenu/models/tbl_dk_res_category.dart';
import 'package:restaurantmenu/models/v_dk_resource.dart';
import 'package:restaurantmenu/pages/ProductsPage.dart';
import '../ThemeProvider.dart';
import 'package:flutter/services.dart';
class ProductDetailPage extends StatefulWidget {
  final VDkResource? resource;
  final TblDkResCategory? category;

  const ProductDetailPage(this.resource, this.category, {Key? key}) : super(key: key);

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> with TickerProviderStateMixin {
  late PageController pageController;
  Duration pageTurnDuration = const Duration(milliseconds: 500);
  Curve pageTurnCurve = Curves.ease;
  late TabController _tabController;
  Device _deviceType = Device.mobile;
  bool showDesc = false;
  int showDescIndex = 0;
  bool hasReachedFirst = false;
  bool hasReachedEnd = false;
  int lastResCatId = 0;
  int activePage = 1;

  @override
  void initState() {
    super.initState();
    rotate();
    _tabController = TabController(
        initialIndex: (widget.category==null)?0: context.read<ProviderModel>().getResCategories.indexWhere((element) => element.ResCatId == widget.category!.ResCatId),
        vsync: this,
        length: context.read<ProviderModel>().getResCategories.length);
    pageController = PageController(
        initialPage: (widget.resource==null)?0:context.read<ProviderModel>().getResources.indexWhere((element) => element.ResId == widget.resource!.ResId),
        viewportFraction: 0.8);
    lastResCatId = (widget.category==null)?0: widget.category!.ResCatId;
  }

  @override
  void dispose() {
    _tabController.dispose();
    pageController.dispose();
    super.dispose();
  }
  Future rotate() async{
    await  SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft
    ]);
  }
  bool appBarVisible = true;

  @override
  Widget build(BuildContext context) {
    final trs = AppLocalizations.of(context);
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    ProviderModel providerModel = Provider.of<ProviderModel>(context);
    Size size = MediaQuery.of(context).size;
    Orientation orientation=MediaQuery.of(context).orientation;
    _deviceType = (MediaQuery.of(context).size.width < 800) ? Device.mobile : Device.tablet;
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitDown,
          DeviceOrientation.portraitUp,
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight
        ]);
        Navigator.of(context).push(
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 400),
            pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
              return ProductsPage(context.watch<ProviderModel>().getResCategories[_tabController.index]);
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
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: PreferredSize(
            preferredSize: appBarVisible ? const Size.square(60) : const Size.square(10),
            child: Stack(children: [
              SizedBox(
                height: appBarVisible ? 80.0 : 10,
                child: AppBar(
                  backgroundColor: themeProvider.appBarColor,
                  elevation: 0,
                  leading: IconButton(
                    onPressed: () {
                      SystemChrome.setPreferredOrientations([
                        DeviceOrientation.portraitDown,
                        DeviceOrientation.portraitUp,
                        DeviceOrientation.landscapeLeft,
                        DeviceOrientation.landscapeRight
                      ]);
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          transitionDuration: const Duration(milliseconds: 500),
                          pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
                            return ProductsPage(context.watch<ProviderModel>().getResCategories[_tabController.index]);
                          },
                          transitionsBuilder:
                              (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
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
                    icon: const Icon(Icons.arrow_back),
                    color: themeProvider.btnColor,
                    iconSize: 30,
                  ),
                  flexibleSpace: SizedBox(
                    height: 73,
                    child: SingleChildScrollView(
                      padding: (_deviceType == Device.tablet) ? const EdgeInsets.only(top: 20) : const EdgeInsets.only(top: 25, left: 10),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: TabBar(
                              controller: _tabController,
                              tabs: providerModel.getResCategories.map<Tab>((TblDkResCategory category) {
                                return Tab(text: category.ResCatName);
                              }).toList(),
                              onTap: (value) {
                                pageController.jumpToPage(context
                                    .read<ProviderModel>()
                                    .getResources
                                    .indexWhere((element) => element.ResCatId == providerModel.getResCategories[value].ResCatId));
                              },
                              labelColor: themeProvider.labelColor,
                              isScrollable: true,
                              labelPadding: (_deviceType == Device.tablet) ? const EdgeInsets.only(left: 65) : const EdgeInsets.only(left: 45),
                              indicatorSize: TabBarIndicatorSize.label,
                              indicatorColor: Colors.yellow,
                              indicatorWeight: 3.5,
                              labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              unselectedLabelColor: themeProvider.unselectedLabelColor,
                              unselectedLabelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                            ),
                          ),
                          Divider(indent: 70, endIndent: 100, color: themeProvider.dividerColor, height: 2, thickness: 2),
                        ],
                      ),
                    ),
                  ),
                  actions: const [],
                ),
              ),
            ]),
          ),
          body: PageView.builder(
            physics: const PageScrollPhysics(),
            allowImplicitScrolling: true,
            controller: pageController,
            itemBuilder: (context, index) {
              int cartItems = (context
                  .watch<ProviderModel>()
                  .getCartItems
                  .where((e) => e.ResId == context.watch<ProviderModel>().getResources[index].ResId)
                  .isNotEmpty)
                  ? context
                  .watch<ProviderModel>()
                  .getCartItems
                  .firstWhere((e) => e.ResId == context.watch<ProviderModel>().getResources[index].ResId)
                  .ItemCount
                  : 0;
              return GestureDetector(
                onVerticalDragEnd: (details) {
                  if (details.primaryVelocity! < 0 || details.primaryVelocity! > 0) {
                    pageController.keepPage;
                  }
                },
                onHorizontalDragEnd: (details) {
                  showDescIndex = 0;
                  showDesc = false;
                  if (details.primaryVelocity! < 0 && hasReachedEnd) {
                    if ((_tabController.index + 1) == _tabController.length && hasReachedEnd) {
                      _tabController.animateTo(0);
                    } else {
                      _tabController.animateTo(_tabController.index + 1);
                    }
                  }
                  if (details.primaryVelocity! > 0 && hasReachedFirst) {
                    if ((_tabController.index - 1) < 0) {
                      _tabController.animateTo(_tabController.length - 1);
                    } else {
                      _tabController.animateTo(_tabController.index - 1);
                    }
                  } else if (details.primaryVelocity == null) {
                    if (kDebugMode) {
                      print("Null");
                    }
                  } else {
                    if (details.primaryVelocity! < 0) {
                      pageController.nextPage(duration: pageTurnDuration, curve: pageTurnCurve);
                      if (context.read<ProviderModel>().getResources[index + 1].ResCatId != lastResCatId) {
                        lastResCatId = context.read<ProviderModel>().getResources[index + 1].ResCatId;
                        _tabController.animateTo(context
                            .read<ProviderModel>()
                            .getResCategories
                            .indexWhere((element) => element.ResCatId == context.read<ProviderModel>().getResources[index + 1].ResCatId));
                      }
                    } else {
                      pageController.previousPage(duration: pageTurnDuration, curve: pageTurnCurve);
                      if (context.read<ProviderModel>().getResources[index - 1].ResCatId != lastResCatId) {
                        lastResCatId = context.read<ProviderModel>().getResources[index - 1].ResCatId;
                        _tabController.animateTo(context
                            .read<ProviderModel>()
                            .getResCategories
                            .indexWhere((element) => element.ResCatId == context.read<ProviderModel>().getResources[index - 1].ResCatId));
                      }
                    }
                  }
                },
                child: Stack(children: <Widget>[
                  Hero(
                    tag: context.read<ProviderModel>().getResources[index].ResName,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 1315,
                      height: MediaQuery.of(context).size.height,
                      child: (context.read<ProviderModel>().getResources[index].ImageFilePath.isEmpty)
                          ? Image.asset(
                              'assets/images/noFoodImage.jpg',
                              fit: BoxFit.cover,
                            )
                          : Image.file(
                              File(context.read<ProviderModel>().getResources[index].ImageFilePath),
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: GestureDetector(
                      onVerticalDragEnd: (details) {
                        if (details.primaryVelocity! < 0) {
                          showDesc = true;
                          showDescIndex = index;
                          setState(() {});
                        }
                        if (details.primaryVelocity! > 0) {
                          showDesc = false;
                          showDescIndex = index;
                          setState(() {});
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0.2),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          height: (orientation==Orientation.landscape)?
                          (showDesc && showDescIndex == index)
                              ? size.height / 1.5
                              : size.height/4.8
                            :(showDesc && showDescIndex == index)
                              ? size.height/1.2
                              : size.height / 6,
                          decoration: BoxDecoration(
                            color: themeProvider.boxColor.withOpacity(0.85),
                          ),
                          child: Padding(
                            padding: (_deviceType == Device.tablet) ? const EdgeInsets.all(25) : const EdgeInsets.only(left: 8),
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                ((trs.locale.languageCode == 'tk')
                                                            ? context.read<ProviderModel>().getResources[index].ResNameTm
                                                            : (trs.locale.languageCode == 'ru')
                                                                ? context.read<ProviderModel>().getResources[index].ResNameRu
                                                                : context.read<ProviderModel>().getResources[index].ResNameEn)
                                                        .isNotEmpty
                                                    ? (trs.locale.languageCode == 'tk')
                                                        ? context.read<ProviderModel>().getResources[index].ResNameTm
                                                        : (trs.locale.languageCode == 'ru')
                                                            ? context.read<ProviderModel>().getResources[index].ResNameRu
                                                            : context.read<ProviderModel>().getResources[index].ResNameEn
                                                    : context.read<ProviderModel>().getResources[index].ResName,
                                                style: TextStyle(
                                                  fontSize: (_deviceType == Device.tablet) ? 22 : 18,
                                                  color: themeProvider.textColor2,
                                                  fontWeight: FontWeight.w600,
                                                )),
                                            Text("${context.read<ProviderModel>().getResources[index].SalePrice.toStringAsFixed(2)} TMT",
                                                style: TextStyle(
                                                  fontSize: (_deviceType == Device.tablet) ? 18 : 15,
                                                  color: themeProvider.textColor2,
                                                  fontWeight: FontWeight.w600,
                                                )),
                                          ],
                                        ),
                                      ),
                                      const Expanded(child: SizedBox.shrink()),
                                      Badge.count(
                                        textStyle: const TextStyle(fontSize: 14),
                                        isLabelVisible: cartItems>0,
                                        alignment: Alignment.topRight,
                                        count: cartItems,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            if (context
                                                .read<ProviderModel>()
                                                .getCartItems
                                                .where((element) => element.ResId == context.read<ProviderModel>().getResources[index].ResId)
                                                .isNotEmpty) {
                                              TblDkCartItem cartItem = context
                                                  .read<ProviderModel>()
                                                  .getCartItems
                                                  .where((element) => element.ResId == context.read<ProviderModel>().getResources[index].ResId)
                                                  .first;
                                              context.read<ProviderModel>().getCartItems[context.read<ProviderModel>().getCartItems.indexWhere(
                                                  (element) =>
                                                      element.ResId == context.read<ProviderModel>().getResources[index].ResId)] = context
                                                  .read<ProviderModel>()
                                                  .getCartItems
                                                  .where((element) => element.ResId == context.read<ProviderModel>().getResources[index].ResId)
                                                  .first
                                                  .copyWith(
                                                      ItemCount: cartItem.ItemCount + 1,
                                                      ItemPriceTotal: (cartItem.ItemCount + 1) * cartItem.ResPriceValue);
                                            } else {
                                              context.read<ProviderModel>().getCartItems.add(TblDkCartItem(
                                                  ResId: context.read<ProviderModel>().getResources[index].ResId,
                                                  ResRegNo: '',
                                                  ResName: context.read<ProviderModel>().getResources[index].ResName,
                                                  ResNameTm: context.read<ProviderModel>().getResources[index].ResNameTm,
                                                  ResNameRu: context.read<ProviderModel>().getResources[index].ResNameRu,
                                                  ResNameEn: context.read<ProviderModel>().getResources[index].ResNameEn,
                                                  ItemCount: 1,
                                                  ResPriceGroupId: 0,
                                                  ResPriceValue: context.read<ProviderModel>().getResources[index].SalePrice,
                                                  ItemPriceTotal: context.read<ProviderModel>().getResources[index].SalePrice,
                                                  ResPendingTotalAmount: 0,
                                                  ImageFilePath: context.read<ProviderModel>().getResources[index].ImageFilePath,
                                                  SyncDateTime: null));
                                            }
                                            setState(() {});
                                          },
                                          style: ElevatedButton.styleFrom(
                                              shape: const CircleBorder(),
                                              backgroundColor: Colors.orange,
                                              minimumSize: (_deviceType == Device.tablet) ? const Size(60, 60) : const Size(40, 40)),
                                          child: SvgPicture.asset("assets/images/Vectorcart.svg",
                                              fit: BoxFit.cover, colorFilter: const ColorFilter.mode(Colors.red, BlendMode.srcIn)),
                                        ),
                                      ),
                                      const SizedBox(width: 20),
                                    ],
                                  ),
                                  (showDesc && showDescIndex == index)
                                      ? Padding(
                                          padding: const EdgeInsets.all(15.0),
                                          child: SizedBox(
                                            height: (_deviceType == Device.mobile) ? 170 : 190,
                                            child: ListView(
                                              scrollDirection: Axis.vertical,
                                              children: [
                                                Text(
                                                    (context.read<ProviderModel>().getResources[index].ResDesc.isNotEmpty)
                                                        ? context.read<ProviderModel>().getResources[index].ResDesc
                                                        : trs.translate('desc')??"There could be a description here...",
                                                    style: TextStyle(color: themeProvider.textColor2, fontSize: 13)),
                                              ],
                                            ),
                                          ),
                                        )
                                      : const SizedBox.shrink(),
                                ],
                              ),
                            )
                          ),
                        ),
                      ),
                    ),
                  ),
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 200),
                    bottom: (orientation==Orientation.portrait)?
                    (showDesc && showDescIndex == index)
                        ? size.height / 1.25
                        : size.height / 7.8
                      :(showDesc && showDescIndex == index)
                        ? size.height/1.68
                        : size.height / 7,
                    left: (orientation==Orientation.landscape) ? size.width / 2.8 : size.width / 3.2,
                    child: ElevatedButton(
                      onPressed: () {
                        if (showDesc && showDescIndex == index) {
                          setState(() {
                            showDesc = false;
                            showDescIndex = 0;
                          });
                        } else {
                          setState(() {
                            showDesc = true;
                            showDescIndex = index;
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        backgroundColor: Colors.blue,
                        minimumSize: (_deviceType == Device.tablet) ? const Size(100, 100) : const Size(50, 50),
                      ),
                      child: (showDesc && showDescIndex == index)
                          ? Icon(
                              Icons.keyboard_arrow_down_outlined,
                              color: Colors.white,
                              size: (_deviceType == Device.tablet) ? 60 : 40,
                            )
                          : Icon(
                              Icons.keyboard_arrow_up_outlined,
                              color: Colors.white,
                              size: (_deviceType == Device.tablet) ? 60 : 40,
                            ),
                    ),
                  ),
                ]),
              );
            },
            itemCount: context.read<ProviderModel>().getResources.length,
          )),
    );
  }
}
