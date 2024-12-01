// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:restaurantmenu/bloc/UserProfileBloc.dart';
import 'package:restaurantmenu/helpers/SharedPrefKeys.dart';
import 'package:restaurantmenu/helpers/enums.dart';
import 'package:restaurantmenu/helpers/localization.dart';
import 'package:restaurantmenu/models/providerModel.dart';
import 'package:restaurantmenu/models/tbl_dk_res_price_group.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../ThemeProvider.dart';
class ProfileDrawer extends StatefulWidget {
  final  VoidCallback? goBack;
  const ProfileDrawer({Key? key,  this.goBack}) : super(key: key);

  @override
  State<ProfileDrawer> createState() => _ProfileDrawerState();
}

class _ProfileDrawerState extends State<ProfileDrawer> {
  TblDkResPriceGroup? tblDkResPriceGroup;
  Device _deviceType=Device.mobile;
  String? dropdownvalue;
  @override
  void initState() {
    super.initState();
    loadData();
  }
  Future loadData() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      dropdownvalue = prefs.getString(SharedPrefKeys.initialPage) ?? "HomePage";
    });

  }
  @override
  Widget build(BuildContext context) {
    var items = [
      "HomePage",
      "ProductsPage",
      "ProductDetailPage"
    ];

    final ProviderModel providerModel = Provider.of<ProviderModel>(context);
    final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    _deviceType=(MediaQuery.of(context).size.width<800)?Device.mobile:Device.tablet;
    final trs = AppLocalizations.of(context);
    return BlocConsumer<UserProfileCubit,UserProfileState>(
      listener: (context, state) {
        if (state is UserProfileInitialState || state is UserProfileSavedState){
          context.read<UserProfileCubit>().loadUserProfile();
        }
      },
        builder: (context,state){
          return (state is UserProfileLoadedState) ? Container(
              width: 379,
              height:834,
              clipBehavior: Clip.hardEdge,
              decoration:  const BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(25),bottomLeft:Radius.circular(25)
                ),
              ),
              child: Drawer(
                backgroundColor: themeProvider.appBarColor,
                child: Padding(
                  padding: const EdgeInsets.only(right:30,left:30),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(top: 30,bottom: 5),
                        child: (_deviceType==Device.tablet)?Row(
                          children: [
                            Align(alignment:Alignment.centerLeft,child: TextButton(onPressed: widget.goBack, child:  Icon(Icons.arrow_back,color: themeProvider.borderColor,))),
                            Text(trs.translate('profile')??"My profile",style: TextStyle(fontSize:20,color: themeProvider.textColor),),
                            const Spacer(),
                            Icon(Icons.person_outline_sharp,color: themeProvider.iconColor,size: 25,),
                          ],
                        )
                        :Row(
                          children: [
                            Transform.translate(offset: const Offset(-20,0),child: TextButton(onPressed: widget.goBack, child:  Icon(Icons.arrow_back,color: themeProvider.borderColor,))),
                            Transform.translate(offset: const Offset(-30,0),child: Text(trs.translate('profile')??"My profile",style: TextStyle(fontSize:17,color: themeProvider.textColor),)),
                            Expanded(child: Transform.translate(offset: const Offset(-20,0),child: Icon(Icons.person_outline_sharp,color: themeProvider.iconColor,size: 25,))),
                          ],
                        ),
                      ),
                      Divider(height: 2,color: themeProvider.dividerColor,),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top:15),
                              child: Text(trs.translate('username')??'Username',style: TextStyle(color: themeProvider.textColor,fontSize: 20),),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 15.0),
                              child: Text(providerModel.getDbUName,style: TextStyle(color: themeProvider.textColor,fontSize: 25),),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top:10),
                              child: Text(trs.translate('lbl_price_group')??'Price groups:',style: TextStyle(color: themeProvider.textColor,fontSize: 20)),
                            ),
                            DropdownButton<TblDkResPriceGroup>(
                              dropdownColor: themeProvider.appBarColor,
                              padding: const EdgeInsets.only(left:20,right:30),
                              value: state.priceGroups.where((element) => element.ResPriceGroupId==state.selectedPriceGroupId).first,
                              isExpanded: true,
                              iconSize: 35,
                              icon:  Icon(Icons.keyboard_arrow_down,color: themeProvider.iconColor,),
                              items: state.priceGroups.map((resPriceGroup) {
                                return DropdownMenuItem(
                                  value: resPriceGroup,
                                  child: Text(resPriceGroup.ResPriceGroupName,style: TextStyle(color: themeProvider.textColor),),
                                );
                              }).toList(),
                              onChanged: (TblDkResPriceGroup? resPriceGroup) {
                                context.read<UserProfileCubit>().saveUserProfile(resPriceGroup!.ResPriceGroupId);
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top:10.0),
                              child: Text(trs.translate('init_page')??'Initial page:',style: TextStyle(color: themeProvider.textColor,fontSize: 20)),
                            ),
                            DropdownButton(
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
                                  dropdownvalue= newValue!;
                                });
                                saveData(newValue!);
                              },
                            ),

                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ) : const SizedBox.shrink();
        },
    );
  }

  Future saveData(String newValue) async{
    final sharedPref = await SharedPreferences.getInstance();
    sharedPref.setString(SharedPrefKeys.initialPage,newValue);
  }
}

