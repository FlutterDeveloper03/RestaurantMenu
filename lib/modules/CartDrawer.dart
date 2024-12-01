// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:restaurantmenu/ThemeProvider.dart';
import 'package:restaurantmenu/helpers/enums.dart';
import 'package:restaurantmenu/helpers/localization.dart';
import 'package:restaurantmenu/models/providerModel.dart';
import 'package:restaurantmenu/models/tbl_dk_cart_item.dart';
import 'package:restaurantmenu/modules/InnerPageViewDrawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartDrawer extends StatefulWidget {
  const CartDrawer({Key? key}) : super(key: key);

  @override
  State<CartDrawer> createState() => _CartDrawerState();
}

class _CartDrawerState extends State<CartDrawer> {
  TextEditingController passwordController = TextEditingController();
  late int myIndex;
  late PageController _controller;
  Device _deviceType = Device.mobile;

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: 0);
  }

  _onChangePage(int index) {
    if (index != 0) setState(() => myIndex = index);
    _controller.animateToPage(index.clamp(0, 2), duration: const Duration(milliseconds: 200), curve: Curves.linear);
  }

  @override
  Widget build(BuildContext context) {
    final trs = AppLocalizations.of(context);
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    ProviderModel providerModel = Provider.of<ProviderModel>(context);
    _deviceType = (MediaQuery.of(context).size.width < 800) ? Device.mobile : Device.tablet;
    Size size = MediaQuery.of(context).size;
    Orientation orientation = MediaQuery.of(context).orientation;
    String cartTotal = providerModel.getCartItems.isEmpty
        ? "0 TMT"
        : "${providerModel.getCartItems.fold(0.0, (previousValue, element) => previousValue + element.ItemPriceTotal)}TMT";
    return Container(
      width: (size.width < 800)
          ? (orientation == Orientation.portrait)
              ? size.width / 1.3
              : size.width / 2
          : size.width / 3,
      clipBehavior: Clip.hardEdge,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(32), bottomLeft: Radius.circular(32)),
      ),
      child: Drawer(
        backgroundColor: themeProvider.appBarColor,
        child: PageView.builder(
            controller: _controller,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 3,
            itemBuilder: (context, index) {
              // Original Drawer
              if (index == 0) {
                return Padding(
                  padding: const EdgeInsets.only(right: 30, left: 30),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(right: 10, left: 10, top: 30, bottom: 5),
                        child: (_deviceType == Device.tablet)
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    trs.translate('cart') ?? 'Cart',
                                    style: TextStyle(fontSize: 24, color: themeProvider.textColor),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        providerModel.getCartItems.clear();
                                      });
                                    },
                                    icon: SvgPicture.asset(
                                      "assets/images/Vectordelete.svg",
                                      colorFilter: const ColorFilter.mode(Colors.red, BlendMode.srcIn),
                                      fit: BoxFit.cover,
                                      width: 30,
                                      height: 30,
                                    ),
                                    iconSize: 30,
                                  )
                                ],
                              )
                            : (orientation == Orientation.portrait)
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        trs.translate('cart') ?? 'Cart',
                                        style: TextStyle(fontSize: 20, color: themeProvider.textColor),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          setState(() {
                                            providerModel.getCartItems.clear();
                                          });
                                        },
                                        icon: SvgPicture.asset(
                                          "assets/images/Vectordelete.svg",
                                          colorFilter: const ColorFilter.mode(Colors.red, BlendMode.srcIn),
                                          fit: BoxFit.cover,
                                          width: 25,
                                          height: 25,
                                        ),
                                        iconSize: 25,
                                      )
                                    ],
                                  )
                                : Row(
                                    children: [
                                      Text(
                                        trs.translate('cart') ?? 'Cart',
                                        style: TextStyle(fontSize: 20, color: themeProvider.textColor),
                                      ),
                                      const Spacer(),
                                      IconButton(
                                        onPressed: () {
                                          setState(() {
                                            providerModel.getCartItems.clear();
                                          });
                                        },
                                        icon: SvgPicture.asset(
                                          "assets/images/Vectordelete.svg",
                                          colorFilter: const ColorFilter.mode(Colors.red, BlendMode.srcIn),
                                          fit: BoxFit.cover,
                                          width: 25,
                                          height: 25,
                                        ),
                                      )
                                    ],
                                  ),
                      ),
                      Divider(
                        height: 2,
                        color: themeProvider.dividerColor,
                      ),
                      Expanded(
                        child: providerModel.getCartItems.isNotEmpty
                            ? Column(children: [
                                Expanded(
                                  child: ListView.separated(
                                      separatorBuilder: (context, separatorIndex) {
                                        return const Divider(
                                          color: Colors.grey,
                                          thickness: 0.3,
                                        );
                                      },
                                      itemCount: providerModel.getCartItems.isEmpty ? 0 : providerModel.getCartItems.length,
                                      itemBuilder: (context, index) {
                                        if (providerModel.getCartItems.isNotEmpty) {
                                          return (_deviceType == Device.tablet)
                                              ? ListTile(
                                                  leading: Container(
                                                    height: 50,
                                                    width: 50,
                                                    decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(4))),
                                                    child: (providerModel.getCartItems[index].ImageFilePath.isEmpty)
                                                        ? Image.asset('assets/images/noFoodImage.jpg')
                                                        : Image.file(
                                                            File(providerModel.getCartItems[index].ImageFilePath),
                                                            fit: BoxFit.cover,
                                                          ),
                                                  ),
                                                  title: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(providerModel.getCartItems[index].ResName,
                                                          style: TextStyle(
                                                              color: themeProvider.textColor, fontWeight: FontWeight.normal, fontSize: 14)),
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                            child: Row(
                                                              children: [
                                                                const Icon(Icons.list_alt),
                                                                Text(
                                                                  providerModel.getCartItems[index].ItemCount.toStringAsFixed(2),
                                                                  style: TextStyle(
                                                                      color: themeProvider.textColor, fontWeight: FontWeight.bold, fontSize: 14),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Row(
                                                              children: [
                                                                const Icon(Icons.functions),
                                                                Text(
                                                                  providerModel.getCartItems[index].ResPriceValue.toStringAsFixed(2),
                                                                  style: TextStyle(
                                                                      color: themeProvider.textColor, fontWeight: FontWeight.bold, fontSize: 14),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  trailing: Row(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          IconButton(
                                                              onPressed: () {
                                                                TblDkCartItem cartItem = context
                                                                    .read<ProviderModel>()
                                                                    .getCartItems
                                                                    .where((element) => element.ResId == providerModel.getCartItems[index].ResId)
                                                                    .first;
                                                                context.read<ProviderModel>().updateCartItems(
                                                                    context.read<ProviderModel>().getCartItems.indexWhere(
                                                                        (element) => element.ResId == providerModel.getCartItems[index].ResId),
                                                                    context
                                                                        .read<ProviderModel>()
                                                                        .getCartItems
                                                                        .where((element) =>
                                                                            element.ResId == providerModel.getCartItems[index].ResId)
                                                                        .first
                                                                        .copyWith(ItemCount: cartItem.ItemCount + 1,ItemPriceTotal: (cartItem.ItemCount + 1) * cartItem.ResPriceValue));
                                                              },
                                                              padding: const EdgeInsets.fromLTRB(0, 3, 15, 2),
                                                              constraints: const BoxConstraints(),
                                                              icon: const Icon(Icons.add)),
                                                          IconButton(
                                                              onPressed: () {
                                                                TblDkCartItem cartItem = context
                                                                    .read<ProviderModel>()
                                                                    .getCartItems
                                                                    .where((element) => element.ResId == providerModel.getCartItems[index].ResId)
                                                                    .first;
                                                                context.read<ProviderModel>().updateCartItems(
                                                                    context.read<ProviderModel>().getCartItems.indexWhere(
                                                                            (element) => element.ResId == providerModel.getCartItems[index].ResId),
                                                                    cartItem.ItemCount > 1
                                                                        ? context
                                                                        .read<ProviderModel>()
                                                                        .getCartItems
                                                                        .where((element) =>
                                                                    element.ResId == providerModel.getCartItems[index].ResId)
                                                                        .first
                                                                        .copyWith(ItemCount: cartItem.ItemCount - 1,ItemPriceTotal: (cartItem.ItemCount - 1) * cartItem.ResPriceValue)
                                                                        : context
                                                                        .read<ProviderModel>()
                                                                        .getCartItems
                                                                        .where((element) =>
                                                                    element.ResId == providerModel.getCartItems[index].ResId)
                                                                        .first
                                                                        .copyWith(ItemCount: 1)
                                                                );
                                                              },
                                                              padding: const EdgeInsets.fromLTRB(0, 3, 15, 0),
                                                              constraints: const BoxConstraints(),
                                                              icon: const Icon(Icons.remove)),
                                                        ],
                                                      ),
                                                      Container(
                                                        width: 30,
                                                        height: 30,
                                                        decoration: const BoxDecoration(
                                                            borderRadius: BorderRadius.all(Radius.circular(10)), color: Color(0xffFED931)),
                                                        child: IconButton(
                                                          icon: SvgPicture.asset(
                                                            "assets/images/Vectordelete.svg",
                                                            colorFilter: const ColorFilter.mode(Colors.black87, BlendMode.srcIn),
                                                          ),
                                                          color: Colors.black,
                                                          onPressed: () {
                                                            setState(() {
                                                              providerModel.getCartItems.removeAt(index);
                                                            });
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  selected: true,
                                                  onTap: () {
                                                    setState(() {
                                                      providerModel.getCartItems.removeAt(index);
                                                    });
                                                  },
                                                )
                                              : (orientation == Orientation.portrait)
                                                  ? Column(
                                                      children: [
                                                        ListTile(
                                                          leading: Container(
                                                            height: 40,
                                                            width: 40,
                                                            decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(4))),
                                                            child: (providerModel.getCartItems[index].ImageFilePath.isEmpty)
                                                                ? Image.asset('assets/images/noFoodImage.jpg')
                                                                : Image.file(
                                                                    File(providerModel.getCartItems[index].ImageFilePath),
                                                                    fit: BoxFit.cover,
                                                                  ),
                                                          ),
                                                          title: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text(providerModel.getCartItems[index].ResName,
                                                                  style: TextStyle(
                                                                      color: themeProvider.textColor,
                                                                      fontWeight: FontWeight.normal,
                                                                      fontSize: 13)),
                                                            ],
                                                          ),
                                                          trailing: SizedBox(
                                                            width: MediaQuery.sizeOf(context).width/5,
                                                            child: FittedBox(
                                                              fit: BoxFit.fitWidth,
                                                              child: Row(
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                mainAxisSize: MainAxisSize.min,
                                                                children: [
                                                                  Padding(
                                                                    padding: const EdgeInsets.only(top: 25.0),
                                                                    child: Column(
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      mainAxisSize: MainAxisSize.min,
                                                                      children: [
                                                                        IconButton(
                                                                            onPressed: () {
                                                                              TblDkCartItem cartItem = context
                                                                                  .read<ProviderModel>()
                                                                                  .getCartItems
                                                                                  .where((element) =>
                                                                                      element.ResId == providerModel.getCartItems[index].ResId)
                                                                                  .first;
                                                                              context.read<ProviderModel>().getCartItems[context
                                                                                      .read<ProviderModel>()
                                                                                      .getCartItems
                                                                                      .indexWhere((element) =>
                                                                                          element.ResId == providerModel.getCartItems[index].ResId)] =
                                                                                  context
                                                                                      .read<ProviderModel>()
                                                                                      .getCartItems
                                                                                      .where((element) =>
                                                                                          element.ResId == providerModel.getCartItems[index].ResId)
                                                                                      .first
                                                                                      .copyWith(ItemCount: cartItem.ItemCount + 1,ItemPriceTotal: (cartItem.ItemCount + 1) * cartItem.ResPriceValue);
                                                                            },
                                                                            padding: const EdgeInsets.fromLTRB(0, 3, 15, 2),
                                                                            constraints: const BoxConstraints(),
                                                                            icon: const Icon(Icons.add)),
                                                                        IconButton(
                                                                            onPressed: () {
                                                                              TblDkCartItem cartItem = context
                                                                                  .read<ProviderModel>()
                                                                                  .getCartItems
                                                                                  .where((element) =>
                                                                                      element.ResId == providerModel.getCartItems[index].ResId)
                                                                                  .first;
                                                                              context.read<ProviderModel>().getCartItems[context
                                                                                      .read<ProviderModel>()
                                                                                      .getCartItems
                                                                                      .indexWhere((element) =>
                                                                                          element.ResId == providerModel.getCartItems[index].ResId)] =
                                                                                  cartItem.ItemCount > 1
                                                                                      ? context
                                                                                          .read<ProviderModel>()
                                                                                          .getCartItems
                                                                                          .where((element) =>
                                                                                              element.ResId == providerModel.getCartItems[index].ResId)
                                                                                          .first
                                                                                          .copyWith(ItemCount: cartItem.ItemCount - 1,ItemPriceTotal: (cartItem.ItemCount - 1) * cartItem.ResPriceValue)
                                                                                      : context
                                                                                          .read<ProviderModel>()
                                                                                          .getCartItems
                                                                                          .where((element) =>
                                                                                              element.ResId == providerModel.getCartItems[index].ResId)
                                                                                          .first
                                                                                          .copyWith(ItemCount: 1);
                                                                            },
                                                                            padding: const EdgeInsets.fromLTRB(0, 3, 15, 0),
                                                                            constraints: const BoxConstraints(),
                                                                            icon: const Icon(Icons.remove)),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    width: 30,
                                                                    height: 30,
                                                                    decoration: const BoxDecoration(
                                                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                                                        color: Color(0xffFED931)),
                                                                    child: IconButton(
                                                                      icon: SvgPicture.asset(
                                                                        "assets/images/Vectordelete.svg",
                                                                        colorFilter: const ColorFilter.mode(Colors.black87, BlendMode.srcIn),
                                                                      ),
                                                                      color: Colors.black,
                                                                      onPressed: () {
                                                                        setState(() {
                                                                          providerModel.getCartItems.removeAt(index);
                                                                        });
                                                                      },
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          selected: true,
                                                          onTap: () {
                                                            setState(() {
                                                              providerModel.getCartItems.removeAt(index);
                                                            });
                                                          },
                                                        ),
                                                        Align(
                                                          alignment: Alignment.centerLeft,
                                                          child: Row(
                                                            mainAxisSize: MainAxisSize.min,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  const Icon(Icons.list_alt, color: Colors.blue),
                                                                  Text(
                                                                    providerModel.getCartItems[index].ItemCount.toStringAsFixed(2),
                                                                    style: TextStyle(
                                                                        color: themeProvider.textColor,
                                                                        fontWeight: FontWeight.bold,
                                                                        fontSize: 14),
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                                                                children: [
                                                                  const Icon(
                                                                    Icons.functions,
                                                                    color: Colors.blue,
                                                                  ),
                                                                  Text(
                                                                    providerModel.getCartItems[index].ResPriceValue.toStringAsFixed(2),
                                                                    style: TextStyle(
                                                                        color: themeProvider.textColor,
                                                                        fontWeight: FontWeight.bold,
                                                                        fontSize: 14),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  : ListTile(
                                                      leading: Container(
                                                        height: 35,
                                                        width: 35,
                                                        decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(4))),
                                                        child: (providerModel.getCartItems[index].ImageFilePath.isEmpty)
                                                            ? Image.asset('assets/images/noFoodImage.jpg')
                                                            : Image.file(
                                                                File(providerModel.getCartItems[index].ImageFilePath),
                                                                fit: BoxFit.cover,
                                                              ),
                                                      ),
                                                      title: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(providerModel.getCartItems[index].ResName,
                                                              style: TextStyle(
                                                                  color: themeProvider.textColor, fontWeight: FontWeight.normal, fontSize: 13)),
                                                          Row(
                                                            children: [
                                                              Expanded(
                                                                child: Row(
                                                                  children: [
                                                                    const Icon(Icons.list_alt),
                                                                    Text(
                                                                      providerModel.getCartItems[index].ItemCount.toStringAsFixed(2),
                                                                      style: TextStyle(
                                                                          color: themeProvider.textColor,
                                                                          fontWeight: FontWeight.bold,
                                                                          fontSize: 13),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Expanded(
                                                                child: Row(
                                                                  children: [
                                                                    const Icon(Icons.functions),
                                                                    Text(
                                                                      providerModel.getCartItems[index].ResPriceValue.toStringAsFixed(2),
                                                                      style: TextStyle(
                                                                          color: themeProvider.textColor,
                                                                          fontWeight: FontWeight.bold,
                                                                          fontSize: 13),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                      trailing: Row(
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            mainAxisSize: MainAxisSize.min,
                                                            children: [
                                                              IconButton(
                                                                  onPressed: () {
                                                                    TblDkCartItem cartItem = context
                                                                        .read<ProviderModel>()
                                                                        .getCartItems
                                                                        .where((element) =>
                                                                    element.ResId == providerModel.getCartItems[index].ResId)
                                                                        .first;
                                                                    context.read<ProviderModel>().getCartItems[context
                                                                        .read<ProviderModel>()
                                                                        .getCartItems
                                                                        .indexWhere((element) =>
                                                                    element.ResId == providerModel.getCartItems[index].ResId)] =
                                                                        context
                                                                            .read<ProviderModel>()
                                                                            .getCartItems
                                                                            .where((element) =>
                                                                        element.ResId == providerModel.getCartItems[index].ResId)
                                                                            .first
                                                                            .copyWith(ItemCount: cartItem.ItemCount + 1, ItemPriceTotal: (cartItem.ItemCount + 1) * cartItem.ResPriceValue);
                                                                  },
                                                                  padding: const EdgeInsets.fromLTRB(0, 3, 15, 2),
                                                                  constraints: const BoxConstraints(),
                                                                  icon: const Icon(Icons.add)),
                                                              IconButton(
                                                                  onPressed: () {
                                                                    TblDkCartItem cartItem = context
                                                                        .read<ProviderModel>()
                                                                        .getCartItems
                                                                        .where((element) =>
                                                                    element.ResId == providerModel.getCartItems[index].ResId)
                                                                        .first;
                                                                    context.read<ProviderModel>().getCartItems[context
                                                                        .read<ProviderModel>()
                                                                        .getCartItems
                                                                        .indexWhere((element) =>
                                                                    element.ResId == providerModel.getCartItems[index].ResId)] =
                                                                    cartItem.ItemCount > 1
                                                                        ? context
                                                                        .read<ProviderModel>()
                                                                        .getCartItems
                                                                        .where((element) =>
                                                                    element.ResId == providerModel.getCartItems[index].ResId)
                                                                        .first
                                                                        .copyWith(ItemCount: cartItem.ItemCount - 1,ItemPriceTotal: (cartItem.ItemCount - 1) * cartItem.ResPriceValue)
                                                                        : context
                                                                        .read<ProviderModel>()
                                                                        .getCartItems
                                                                        .where((element) =>
                                                                    element.ResId == providerModel.getCartItems[index].ResId)
                                                                        .first
                                                                        .copyWith(ItemCount: 1);
                                                                  },
                                                                  padding: const EdgeInsets.fromLTRB(0, 3, 15, 0),
                                                                  constraints: const BoxConstraints(),
                                                                  icon: const Icon(Icons.remove)),
                                                            ],
                                                          ),
                                                          Container(
                                                            width: 33,
                                                            height: 33,
                                                            decoration: const BoxDecoration(
                                                                borderRadius: BorderRadius.all(Radius.circular(10)), color: Color(0xffFED931)),
                                                            child: IconButton(
                                                              icon: SvgPicture.asset(
                                                                "assets/images/Vectordelete.svg",
                                                                colorFilter: const ColorFilter.mode(Colors.black87, BlendMode.srcIn),
                                                              ),
                                                              color: Colors.black,
                                                              onPressed: () {
                                                                setState(() {
                                                                  providerModel.getCartItems.removeAt(index);
                                                                });
                                                              },
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      selected: true,
                                                      onTap: () {
                                                        setState(() {
                                                          providerModel.getCartItems.removeAt(index);
                                                        });
                                                      },
                                                    );
                                        } else {
                                          return  Center(
                                            child:
                                                Column(
                                                  children: [
                                                    SvgPicture.asset(
                                                      "assets/images/Vectorcart.svg",
                                                      colorFilter: const ColorFilter.mode(Colors.yellow, BlendMode.srcIn),
                                                      fit: BoxFit.cover,
                                                      width: 25,
                                                      height: 25,
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.only(top:15.0,bottom:15.0),
                                                      child: Text(trs.translate('no_cart_item_text')??"Your cart is empty", style: TextStyle(color: themeProvider.textColor, fontSize: 20,fontWeight:FontWeight.bold)),
                                                    ),
                                                    Text(trs.translate('go_menu_text')??"Go through the menu and choose the dish you want", style: const TextStyle(color: Colors.yellow, fontSize: 18)),
                                                    IconButton(
                                                      onPressed: () async {
                                                        final prefs = await SharedPreferences.getInstance();
                                                        if (prefs.containsKey("password") && prefs.containsKey("confirm")) {
                                                          passwordController.clear();
                                                          inputDialog(context, themeProvider);
                                                        } else {
                                                          _onChangePage(1);
                                                        }
                                                      },
                                                      icon: const Icon(Icons.settings),
                                                      color: Colors.yellow,
                                                      iconSize: 25,
                                                    ),
                                                  ],
                                                ),
                                          );
                                        }
                                      }),
                                ),
                                (_deviceType == Device.tablet)
                                    ? Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(top: 20),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(trs.translate('total') ?? "Total",
                                                    style: TextStyle(color: themeProvider.textColor, fontSize: 20)),
                                                Text(
                                                  cartTotal,
                                                  style: TextStyle(
                                                    color: themeProvider.textColor,
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.bottomRight,
                                            child: IconButton(
                                              onPressed: () async {
                                                final prefs = await SharedPreferences.getInstance();
                                                if (prefs.containsKey("password") && prefs.containsKey("confirm")) {
                                                  passwordController.clear();
                                                  inputDialog(context, themeProvider);
                                                } else {
                                                  _onChangePage(1);
                                                }
                                              },
                                              icon: const Icon(Icons.settings),
                                              color: Colors.yellow,
                                              iconSize: 30,
                                            ),
                                          ),
                                        ],
                                      )
                                    : (orientation == Orientation.portrait)
                                        ? Column(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(top: 20),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(trs.translate('total') ?? "Total",
                                                        style: TextStyle(color: themeProvider.textColor, fontSize: 20)),
                                                    Text(
                                                      cartTotal,
                                                      style: TextStyle(
                                                        color: themeProvider.textColor,
                                                        fontSize: 20,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Align(
                                                alignment: Alignment.bottomRight,
                                                child: IconButton(
                                                  onPressed: () async {
                                                    final prefs = await SharedPreferences.getInstance();
                                                    if (prefs.containsKey("password") && prefs.containsKey("confirm")) {
                                                      passwordController.clear();
                                                      inputDialog(context, themeProvider);
                                                    } else {
                                                      _onChangePage(1);
                                                    }
                                                  },
                                                  icon: const Icon(Icons.settings),
                                                  color: Colors.yellow,
                                                  iconSize: 30,
                                                ),
                                              ),
                                            ],
                                          )
                                        : Column(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(top: 20),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(trs.translate('total') ?? "Total",
                                                        style: TextStyle(color: themeProvider.textColor, fontSize: 18)),
                                                    const Spacer(),
                                                    Text(
                                                      cartTotal,
                                                      style: TextStyle(
                                                        color: themeProvider.textColor,
                                                        fontSize: 18,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Align(
                                                alignment: Alignment.bottomRight,
                                                child: IconButton(
                                                  onPressed: () async {
                                                    final prefs = await SharedPreferences.getInstance();
                                                    if (prefs.containsKey("password") && prefs.containsKey("confirm")) {
                                                      passwordController.clear();
                                                      inputDialog(context, themeProvider);
                                                    } else {
                                                      _onChangePage(1);
                                                    }
                                                  },
                                                  icon: const Icon(Icons.settings),
                                                  color: Colors.yellow,
                                                  iconSize: 25,
                                                ),
                                              ),
                                            ],
                                          )
                              ])
                            : (orientation==Orientation.portrait)?Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  "assets/images/Vectorcart.svg",
                                  colorFilter: const ColorFilter.mode(Colors.yellow, BlendMode.srcIn),
                                  fit: BoxFit.cover,
                                  width: 25,
                                  height: 25,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top:15.0,bottom:15.0),
                                  child: Text(trs.translate('no_cart_item_text')??"Your cart is empty", style: TextStyle(color: themeProvider.textColor, fontSize: 20,fontWeight:FontWeight.bold)),
                                ),
                                Text(trs.translate('go_menu_text')??"Go through the menu and choose the dish you want", style: const TextStyle(color: Colors.yellow, fontSize: 18)),

                              ],
                            )
                            :SizedBox(
                              height:100,
                              child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                              SvgPicture.asset(
                                "assets/images/Vectorcart.svg",
                                colorFilter: const ColorFilter.mode(Colors.yellow, BlendMode.srcIn),
                                fit: BoxFit.cover,
                                width: 25,
                                height: 25,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top:15.0,bottom:15.0),
                                child: Text(trs.translate('no_cart_item_text')??"Your cart is empty", style: TextStyle(color: themeProvider.textColor, fontSize: 20,fontWeight:FontWeight.bold)),
                              ),
                              Text(trs.translate('go_menu_text')??"Go through the menu and choose the dish you want", style: const TextStyle(color: Colors.yellow, fontSize: 18)),

                          ],
                        ),
                            ),
                      ),
                      providerModel.getCartItems.isEmpty?Align(alignment:Alignment.bottomRight,
                        child: IconButton(
                        onPressed: () async {
                          final prefs = await SharedPreferences.getInstance();
                          if (prefs.containsKey("password") && prefs.containsKey("confirm")) {
                            passwordController.clear();
                            inputDialog(context, themeProvider);
                          } else {
                            _onChangePage(1);
                          }
                        },
                        icon: const Icon(Icons.settings),
                        color: Colors.yellow,
                        iconSize: 30,
                      ),
                      ):const SizedBox.shrink(),
                    ],
                  ),
                );
              }
              if (myIndex == 1) {
                return const InnerPageViewDrawer(visible: true, isHome: false);
              }
              return null;
            }),
      ),
    );
  }

  Future<void> inputDialog(BuildContext context, ThemeProvider themeProvider) async {
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
                        _onChangePage(1);
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
}
