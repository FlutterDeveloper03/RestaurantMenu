// ignore_for_file: file_names

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:restaurantmenu/bloc/DbSyncPageCubit.dart';
import 'package:restaurantmenu/helpers/enums.dart';
import 'package:restaurantmenu/helpers/localization.dart';
import '../ThemeProvider.dart';

class SynchronizationDrawer extends StatefulWidget {
  final  VoidCallback? goBack;
  const SynchronizationDrawer({Key? key,  this.goBack}) : super(key: key);

  @override
  State<SynchronizationDrawer> createState() => _SynchronizationDrawerState();
}

class _SynchronizationDrawerState extends State<SynchronizationDrawer> {
  bool isVisible = false;
  bool value = false;
  Device _deviceType = Device.mobile;
  @override
  Widget build(BuildContext context) {
    final trs = AppLocalizations.of(context);
    final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    Size size = MediaQuery.of(context).size;
    Orientation orientation=MediaQuery.of(context).orientation;
    _deviceType = (MediaQuery.of(context).size.width < 800) ? Device.mobile : Device.tablet;
    return BlocListener<DbSyncPageCubit, DbSyncPageState>(
      listener: (context, state) {
        if (state is DbSyncedState) {
          AwesomeDialog(
              context: context,
              headerAnimationLoop: false,
              dialogType: (state.resPricesSyncCount +
                  state.resourcesSyncCount +
                  state.companyInfSyncCount +
                  state.imagesSyncCount >
                  0)
                  ? DialogType.success
                  : DialogType.warning,
              animType: AnimType.scale,
              title: trs.translate('success_text') ?? 'Success',
              desc: trs.translate('synchronized_successfully') ??
                  'Synchronized successfully',
              body: (state.resPricesSyncCount +
                  state.resourcesSyncCount +
                  state.companyInfSyncCount +
                  state.imagesSyncCount >
                  0)
                  ? Column(
                children: [
                  state.companyInfSyncCount > 0
                      ? Row(
                    children: [
                      Text(
                        trs.translate('company_sync_count_text') ??
                            'Company data total: ',
                        style:
                        const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(state.companyInfSyncCount.toString()),
                    ],
                  )
                      : const SizedBox(width: 0, height: 0),
                  state.resourcesSyncCount > 0
                      ? Row(
                    children: [
                      Text(
                        trs.translate('resource_sync_count_text') ??
                            'Resources total: ',
                        style:
                        const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(state.resourcesSyncCount.toString()),
                    ],
                  )
                      : const SizedBox(width: 0, height: 0),
                  state.resPricesSyncCount > 0
                      ? Row(
                    children: [
                      Text(
                        trs.translate(
                            'res_price_sync_count_text') ??
                            'Resource prices total: ',
                        style:
                        const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(state.resPricesSyncCount.toString()),
                    ],
                  )
                      : const SizedBox(width: 0, height: 0),
                  state.imagesSyncCount > 0
                      ? Row(
                    children: [
                      Text(
                        trs.translate('image_sync_count_text') ??
                            'Images total: ',
                        style:
                        const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(state.imagesSyncCount.toString()),
                    ],
                  )
                      : const SizedBox(width: 0, height: 0)
                ],
              )
                  : Text(
                  trs.translate('warning_message') ??
                      'Something went wrong while synchronization',
                  textAlign: TextAlign.center),
              btnOkText: 'Ok',
              btnOkColor: (state.resPricesSyncCount +
                  state.resourcesSyncCount +
                  state.companyInfSyncCount +
                  state.imagesSyncCount >
                  0)
                  ? const Color(0xFF00CA71)
                  : Colors.orangeAccent,
              btnOkOnPress: () {
                Navigator.pop(context);
              })
            .show();
        } else if (state is AccessDeniedState) {
          AwesomeDialog(
              context: context,
              headerAnimationLoop: false,
              dialogType: DialogType.error,
              animType: AnimType.scale,
              title: trs.translate('error_text') ?? 'Error',
              desc: trs.translate('access_denied') ?? 'Access denied',
              btnOkText: 'Ok',
              btnOkColor: Colors.red,
              btnOkOnPress: () {
                Navigator.pop(context);
              })
            .show();
        }
      },
      child: Container(
        width: (size.width<800) ? (orientation==Orientation.portrait)?size.width/2:300 : size.width/3,
        clipBehavior: Clip.hardEdge,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(25), bottomLeft: Radius.circular(25)),
        ),
        child: Drawer(
          backgroundColor: themeProvider.appBarColor,
          child: Padding(
            padding: const EdgeInsets.only(right: 30, left: 30),
            child: (_deviceType==Device.tablet)? Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 30, bottom: 5),
                  child: Row(
                    children: [
                      TextButton(
                          onPressed: widget.goBack,
                          child: Icon(
                            Icons.arrow_back,
                            color: themeProvider.borderColor,
                          )),
                      Text(
                        trs.translate('sync')??"Synchronization",
                        style: TextStyle(fontSize: 18, color: themeProvider.textColor),
                      ),
                      const Spacer(),
                      IconButton(
                          onPressed: () {
                            context.read<DbSyncPageCubit>().startSyncProcess('token');
                          },
                          icon: const Icon(
                            Icons.cached_outlined,
                            size: 25,
                          ),
                          color: themeProvider.iconColor),
                    ],
                  ),
                ),
                Divider(
                  height: 2,
                  color: themeProvider.dividerColor,
                ),
                SizedBox(
                  height: 600,
                  child: BlocBuilder<DbSyncPageCubit, DbSyncPageState>(
                    builder: (context, state) {
                      if (state is DbSyncPageLoadedState) {
                        return ListView(
                          children: [
                            Theme(
                              data: ThemeData(unselectedWidgetColor: themeProvider.borderColor),
                              child: CheckboxListTile(
                                title: Text(trs.translate('company_sync_text') ?? "Company data",style:TextStyle(color:themeProvider.textColor)),
                                selected: state.companyInfCheckbox,
                                value: state.companyInfCheckbox,
                                activeColor: Theme.of(context).primaryColor,
                                onChanged: (value) {
                                  BlocProvider.of<DbSyncPageCubit>(context).companyInfCheckboxClicked();
                                },
                                secondary: Icon(Icons.apartment,color:themeProvider.iconColor),
                              ),
                            ),
                            Theme(
                              data: ThemeData(unselectedWidgetColor: themeProvider.borderColor),
                              child: CheckboxListTile(
                                title: Text(trs.translate('resource_sync_text') ?? "Resources",style:TextStyle(color:themeProvider.textColor)),
                                selected: state.resourcesCheckBox,
                                value: state.resourcesCheckBox,
                                activeColor: Theme.of(context).primaryColor,
                                onChanged: (value) {
                                  BlocProvider.of<DbSyncPageCubit>(context).resourcesCheckBoxClicked();
                                },
                                secondary: Icon(Icons.backpack,color:themeProvider.iconColor),
                              ),
                            ),
                            Theme(
                              data: ThemeData(unselectedWidgetColor: themeProvider.borderColor),
                              child: CheckboxListTile(
                                title: Text(trs.translate('res_price_sync_text') ?? "Resource prices",style:TextStyle(color:themeProvider.textColor)),
                                selected: state.resPricesCheckBox,
                                value: state.resPricesCheckBox,
                                activeColor: Theme.of(context).primaryColor,
                                onChanged: (value) {
                                  BlocProvider.of<DbSyncPageCubit>(context).resPricesCheckBoxClicked();
                                },
                                secondary: Icon(Icons.sell,color:themeProvider.iconColor),
                              ),
                            ),
                            Theme(
                              data: ThemeData(unselectedWidgetColor: themeProvider.borderColor),
                              child: CheckboxListTile(
                                title: Text(trs.translate('image_sync_text') ?? "Images",style:TextStyle(color:themeProvider.textColor)),
                                selected: state.imagesCheckBox,
                                value: state.imagesCheckBox,
                                activeColor: Theme.of(context).primaryColor,
                                onChanged: (value) {
                                  BlocProvider.of<DbSyncPageCubit>(context).imagesCheckBoxClickedEvent();
                                },
                                secondary: Icon(Icons.image,color:themeProvider.iconColor),
                              ),
                            ),
                          ],
                        );
                      } else if (state is DbSyncingState) {
                        return ListView(children: [
                          Row(
                            children: [
                              Expanded(
                                child: Theme(
                                  data: ThemeData(unselectedWidgetColor: themeProvider.borderColor),
                                  child: CheckboxListTile(
                                    title: Text(trs.translate('company_sync_text') ?? "Company data",style:TextStyle(color:themeProvider.textColor)),
                                    selected: state.companyInfCheckbox == Status.initial ? false : true,
                                    value: state.companyInfCheckbox == Status.initial ? false : true,
                                    activeColor: Theme.of(context).primaryColor,
                                    onChanged: (value) {},
                                    secondary: Icon(Icons.apartment,color:themeProvider.iconColor),
                                  ),
                                ),
                              ),
                              (state.companyInfCheckbox == Status.onProgress)
                                  ? const Padding(
                                      padding: EdgeInsets.only(right: 8),
                                      child: SizedBox(width: 25, height: 25, child: CircularProgressIndicator()),
                                    )
                                  : (state.companyInfCheckbox == Status.completed)
                                      ? const Icon(Icons.check,color: Colors.blue,)
                                      : (state.companyInfCheckbox == Status.warning)
                                          ? const Icon(Icons.warning)
                                          : (state.companyInfCheckbox == Status.failed)
                                              ? const Icon(Icons.error)
                                              : const SizedBox.shrink()
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Theme(
                                  data: ThemeData(unselectedWidgetColor: themeProvider.borderColor),
                                  child: CheckboxListTile(
                                    title: Text(trs.translate('resource_sync_text') ?? "Resources",style:TextStyle(color:themeProvider.textColor)),
                                    selected: state.resourcesCheckBox == Status.initial ? false : true,
                                    value: state.resourcesCheckBox == Status.initial ? false : true,
                                    activeColor: Theme.of(context).primaryColor,
                                    onChanged: (value) {},
                                    secondary: Icon(Icons.backpack,color:themeProvider.iconColor),
                                  ),
                                ),
                              ),
                              (state.resourcesCheckBox == Status.onProgress)
                                  ? const Padding(
                                      padding: EdgeInsets.only(right: 8),
                                      child: SizedBox(width: 25, height: 25, child: CircularProgressIndicator()),
                                    )
                                  : (state.resourcesCheckBox == Status.completed)
                                      ? const Icon(Icons.check,color:Colors.blue)
                                      : (state.resourcesCheckBox == Status.warning)
                                          ? const Icon(Icons.warning)
                                          : (state.resourcesCheckBox == Status.failed)
                                              ? const Icon(Icons.error)
                                              : const SizedBox.shrink()
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Theme(
                                  data: ThemeData(unselectedWidgetColor: themeProvider.borderColor),
                                  child: CheckboxListTile(
                                    title: Text(trs.translate('res_price_sync_text') ?? "Resource prices",style:TextStyle(color:themeProvider.textColor)),
                                    selected: state.resPricesCheckBox == Status.initial ? false : true,
                                    value: state.resPricesCheckBox == Status.initial ? false : true,
                                    activeColor: Theme.of(context).primaryColor,
                                    onChanged: (value) {},
                                    secondary: Icon(Icons.sell,color:themeProvider.iconColor),
                                  ),
                                ),
                              ),
                              (state.resPricesCheckBox == Status.onProgress)
                                  ? const Padding(
                                      padding: EdgeInsets.only(right: 8),
                                      child: SizedBox(width: 25, height: 25, child: CircularProgressIndicator()),
                                    )
                                  : (state.resPricesCheckBox == Status.completed)
                                      ? const Icon(Icons.check,color:Colors.blue)
                                      : (state.resPricesCheckBox == Status.warning)
                                          ? const Icon(Icons.warning)
                                          : (state.resPricesCheckBox == Status.failed)
                                              ? const Icon(Icons.error)
                                              : const SizedBox.shrink()
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Theme(
                                  data: ThemeData(unselectedWidgetColor: themeProvider.borderColor),
                                  child: CheckboxListTile(
                                    title: Text(trs.translate('image_sync_text') ?? "Images",style:TextStyle(color:themeProvider.textColor)),
                                    selected: state.imagesCheckBox == Status.initial ? false : true,
                                    value: state.imagesCheckBox == Status.initial ? false : true,
                                    activeColor: Theme.of(context).primaryColor,
                                    onChanged: (value) {},
                                    secondary: Icon(Icons.image,color:themeProvider.iconColor),
                                  ),
                                ),
                              ),
                              (state.imagesCheckBox == Status.onProgress)
                                  ? const Padding(
                                      padding: EdgeInsets.only(right: 8.0),
                                      child: SizedBox(width: 25, height: 25, child: CircularProgressIndicator()),
                                    )
                                  : (state.imagesCheckBox == Status.completed)
                                      ? const Icon(Icons.check,color:Colors.blue)
                                      : (state.imagesCheckBox == Status.warning)
                                          ? const Icon(Icons.warning)
                                          : (state.imagesCheckBox == Status.failed)
                                              ? const Icon(Icons.error)
                                              : const SizedBox.shrink()
                            ],
                          ),
                        ]);
                      } else if (state is DbSyncedState) {
                        return ListView(children: [
                          Row(
                            children: [
                              Expanded(
                                child: Theme(
                                  data: ThemeData(unselectedWidgetColor: themeProvider.borderColor),
                                  child: CheckboxListTile(
                                    title: Text(trs.translate('company_sync_text') ?? "Company data",style:TextStyle(color:themeProvider.textColor)),
                                    selected: state.companyInfCheckbox == Status.initial ? false : true,
                                    value: state.companyInfCheckbox == Status.initial ? false : true,
                                    activeColor: Theme.of(context).primaryColor,
                                    onChanged: (value) {
                                      BlocProvider.of<DbSyncPageCubit>(context).companyInfCheckboxClicked();
                                    },
                                    secondary: Icon(Icons.apartment,color:themeProvider.iconColor),
                                  ),
                                ),
                              ),
                              (state.companyInfCheckbox == Status.onProgress)
                                  ? const Padding(
                                      padding: EdgeInsets.only(right: 8),
                                      child: SizedBox(width: 25, height: 25, child: CircularProgressIndicator()),
                                    )
                                  : (state.companyInfCheckbox == Status.completed)
                                      ? const Icon(Icons.check,color:Colors.blue)
                                      : (state.companyInfCheckbox == Status.warning)
                                          ? const Icon(Icons.warning)
                                          : (state.companyInfCheckbox == Status.failed)
                                              ? const Icon(Icons.error)
                                              : const SizedBox.shrink()
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Theme(
                                  data: ThemeData(unselectedWidgetColor: themeProvider.borderColor),
                                  child: CheckboxListTile(
                                    title: Text(trs.translate('resource_sync_text') ?? "Resources",style:TextStyle(color:themeProvider.textColor)),
                                    selected: state.resourcesCheckBox == Status.initial ? false : true,
                                    value: state.resourcesCheckBox == Status.initial ? false : true,
                                    activeColor: Theme.of(context).primaryColor,
                                    onChanged: (value) {
                                      BlocProvider.of<DbSyncPageCubit>(context).resourcesCheckBoxClicked();
                                    },
                                    secondary: Icon(Icons.backpack,color:themeProvider.iconColor),
                                  ),
                                ),
                              ),
                              (state.resourcesCheckBox == Status.onProgress)
                                  ? const Padding(
                                      padding: EdgeInsets.only(right: 8),
                                      child: SizedBox(width: 25, height: 25, child: CircularProgressIndicator()),
                                    )
                                  : (state.resourcesCheckBox == Status.completed)
                                      ? const Icon(Icons.check,color:Colors.blue)
                                      : (state.resourcesCheckBox == Status.warning)
                                          ? const Icon(Icons.warning)
                                          : (state.resourcesCheckBox == Status.failed)
                                              ? const Icon(Icons.error)
                                              : const SizedBox.shrink()
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Theme(
                                  data: ThemeData(unselectedWidgetColor: themeProvider.borderColor),
                                  child: CheckboxListTile(
                                    title: Text(trs.translate('res_price_sync_text') ?? "Resource prices",style:TextStyle(color:themeProvider.textColor)),
                                    selected: state.resPricesCheckBox == Status.initial ? false : true,
                                    value: state.resPricesCheckBox == Status.initial ? false : true,
                                    activeColor: Theme.of(context).primaryColor,
                                    onChanged: (value) {
                                      BlocProvider.of<DbSyncPageCubit>(context).resPricesCheckBoxClicked();
                                    },
                                    secondary: Icon(Icons.sell,color:themeProvider.iconColor),
                                  ),
                                ),
                              ),
                              (state.resPricesCheckBox == Status.onProgress)
                                  ? const Padding(
                                      padding: EdgeInsets.only(right: 8),
                                      child: SizedBox(width: 25, height: 25, child: CircularProgressIndicator()),
                                    )
                                  : (state.resPricesCheckBox == Status.completed)
                                      ? const Icon(Icons.check,color:Colors.blue)
                                      : (state.resPricesCheckBox == Status.warning)
                                          ? const Icon(Icons.warning)
                                          : (state.resPricesCheckBox == Status.failed)
                                              ? const Icon(Icons.error)
                                              : const SizedBox.shrink()
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Theme(
                                  data: ThemeData(unselectedWidgetColor: themeProvider.borderColor),
                                  child: CheckboxListTile(
                                    title: Text(trs.translate('image_sync_text') ?? "Images",style:TextStyle(color:themeProvider.textColor)),
                                    selected: state.imagesCheckBox == Status.initial ? false : true,
                                    value: state.imagesCheckBox == Status.initial ? false : true,
                                    activeColor: Theme.of(context).primaryColor,
                                    onChanged: (value) {
                                      BlocProvider.of<DbSyncPageCubit>(context).imagesCheckBoxClickedEvent();
                                    },
                                    secondary: Icon(Icons.image,color:themeProvider.iconColor),
                                  ),
                                ),
                              ),
                              (state.imagesCheckBox == Status.onProgress)
                                  ? const Padding(
                                      padding: EdgeInsets.only(right: 8.0),
                                      child: SizedBox(width: 25, height: 25, child: CircularProgressIndicator()),
                                    )
                                  : (state.imagesCheckBox == Status.completed)
                                      ? const Icon(Icons.check,color:Colors.blue)
                                      : (state.imagesCheckBox == Status.warning)
                                          ? const Icon(Icons.warning)
                                          : (state.imagesCheckBox == Status.failed)
                                              ? const Icon(Icons.error)
                                              : const SizedBox.shrink()
                            ],
                          ),
                        ]);
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  ),
                ),
              ],
            )
            :(orientation==Orientation.portrait)? Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top:25.0),
                  child:
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Transform.translate(offset: const Offset(-25, 0),child: TextButton(onPressed: widget.goBack, child:  Icon(Icons.arrow_back,color: themeProvider.borderColor,))),
                      Transform.translate(offset: const Offset(-30,0),child: Text(textAlign: TextAlign.left,trs.translate('sync')??"Synchronization",style: TextStyle(fontSize:17,color: themeProvider.textColor),)),
                      Expanded(
                        child: Transform.translate(
                          offset: const Offset(-20,0),
                          child: IconButton(onPressed: (){
                            context.read<DbSyncPageCubit>().startSyncProcess('token');
                          },icon: const Icon(Icons.cached_outlined,size: 25,),color: themeProvider.iconColor,
                            padding: const EdgeInsets.fromLTRB(0,3,20,2),),
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  height: 2,
                  color: themeProvider.dividerColor,
                ),
                SizedBox(
                  height: 600,
                  child: BlocBuilder<DbSyncPageCubit, DbSyncPageState>(
                    builder: (context, state) {
                      if (state is DbSyncPageLoadedState) {
                        return ListView(
                          children: [
                        Theme(
                        data: ThemeData(unselectedWidgetColor: themeProvider.borderColor),
                              child: CheckboxListTile(
                                title: Text(trs.translate('company_sync_text') ?? "Company data",style: TextStyle(color:themeProvider.textColor)),
                                selected: state.companyInfCheckbox,
                                checkboxShape: RoundedRectangleBorder(side: MaterialStateBorderSide.resolveWith(
                                      (states) => const BorderSide(width: 1.0, color: Colors.red),
                                ),),
                                value: state.companyInfCheckbox,
                                activeColor: Theme.of(context).primaryColor,
                                onChanged: (value) {
                                  BlocProvider.of<DbSyncPageCubit>(context).companyInfCheckboxClicked();
                                },
                                secondary: Icon(Icons.apartment,color: themeProvider.iconColor),
                              ),
                            ),
                            Theme(
                              data: ThemeData(unselectedWidgetColor: themeProvider.borderColor),
                              child: CheckboxListTile(
                                title: Text(trs.translate('resource_sync_text') ?? "Resources",style: TextStyle(color:themeProvider.textColor)),
                                selected: state.resourcesCheckBox,
                                value: state.resourcesCheckBox,
                                activeColor: Theme.of(context).primaryColor,
                                onChanged: (value) {
                                  BlocProvider.of<DbSyncPageCubit>(context).resourcesCheckBoxClicked();
                                },
                                secondary: Icon(Icons.backpack,color:themeProvider.iconColor),
                              ),
                            ),
                            Theme(
                              data: ThemeData(unselectedWidgetColor: themeProvider.borderColor),
                              child: CheckboxListTile(
                                title: Text(trs.translate('res_price_sync_text') ?? "Resource prices",style: TextStyle(color:themeProvider.textColor)),
                                selected: state.resPricesCheckBox,
                                value: state.resPricesCheckBox,
                                activeColor: Theme.of(context).primaryColor,
                                onChanged: (value) {
                                  BlocProvider.of<DbSyncPageCubit>(context).resPricesCheckBoxClicked();
                                },
                                secondary: Icon(Icons.sell,color: themeProvider.iconColor,),
                              ),
                            ),
                            Theme(
                              data: ThemeData(unselectedWidgetColor: themeProvider.borderColor),
                              child: CheckboxListTile(
                                title: Text(trs.translate('image_sync_text') ?? "Images",style: TextStyle(color:themeProvider.textColor)),
                                selected: state.imagesCheckBox,
                                value: state.imagesCheckBox,
                                activeColor: Theme.of(context).primaryColor,
                                onChanged: (value) {
                                  BlocProvider.of<DbSyncPageCubit>(context).imagesCheckBoxClickedEvent();
                                },
                                secondary: Icon(Icons.image,color:themeProvider.iconColor),
                              ),
                            ),
                          ],
                        );
                      } else if (state is DbSyncingState) {
                        return ListView(children: [
                          Row(
                            children: [
                              Expanded(
                                child: Theme(
                                  data: ThemeData(unselectedWidgetColor: themeProvider.borderColor),
                                  child: CheckboxListTile(
                                    title: Text(trs.translate('company_sync_text') ?? "Company data",style: TextStyle(color:themeProvider.textColor)),
                                    selected: state.companyInfCheckbox == Status.initial ? false : true,
                                    value: state.companyInfCheckbox == Status.initial ? false : true,
                                    activeColor: Theme.of(context).primaryColor,
                                    onChanged: (value) {},
                                    secondary: Icon(Icons.apartment,color:themeProvider.iconColor),
                                  ),
                                ),
                              ),
                              (state.companyInfCheckbox == Status.onProgress)
                                  ? const Padding(
                                padding: EdgeInsets.only(right: 8),
                                child: SizedBox(width: 25, height: 25, child: CircularProgressIndicator()),
                              )
                                  : (state.companyInfCheckbox == Status.completed)
                                  ? const Icon(Icons.check,color: Colors.blue,)
                                  : (state.companyInfCheckbox == Status.warning)
                                  ? const Icon(Icons.warning)
                                  : (state.companyInfCheckbox == Status.failed)
                                  ? const Icon(Icons.error)
                                  : const SizedBox.shrink()
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Theme(
                                  data: ThemeData(unselectedWidgetColor: themeProvider.borderColor),
                                  child: CheckboxListTile(
                                    title: Text(trs.translate('resource_sync_text') ?? "Resources",style: TextStyle(color:themeProvider.textColor)),
                                    selected: state.resourcesCheckBox == Status.initial ? false : true,
                                    value: state.resourcesCheckBox == Status.initial ? false : true,
                                    activeColor: Theme.of(context).primaryColor,
                                    onChanged: (value) {},
                                    secondary: Icon(Icons.backpack,color:themeProvider.iconColor),
                                  ),
                                ),
                              ),
                              (state.resourcesCheckBox == Status.onProgress)
                                  ? const Padding(
                                padding: EdgeInsets.only(right: 8),
                                child: SizedBox(width: 25, height: 25, child: CircularProgressIndicator()),
                              )
                                  : (state.resourcesCheckBox == Status.completed)
                                  ? const Icon(Icons.check,color:Colors.blue)
                                  : (state.resourcesCheckBox == Status.warning)
                                  ? const Icon(Icons.warning)
                                  : (state.resourcesCheckBox == Status.failed)
                                  ? const Icon(Icons.error)
                                  :const SizedBox.shrink()
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Theme(
                                  data: ThemeData(unselectedWidgetColor: themeProvider.borderColor),
                                  child: CheckboxListTile(
                                    title: Text(trs.translate('res_price_sync_text') ?? "Resource prices",style: TextStyle(color:themeProvider.textColor)),
                                    selected: state.resPricesCheckBox == Status.initial ? false : true,
                                    value: state.resPricesCheckBox == Status.initial ? false : true,
                                    activeColor: Theme.of(context).primaryColor,
                                    onChanged: (value) {},
                                    secondary: Icon(Icons.sell,color:themeProvider.iconColor),
                                  ),
                                ),
                              ),
                              (state.resPricesCheckBox == Status.onProgress)
                                  ? const Padding(
                                padding: EdgeInsets.only(right: 8),
                                child: SizedBox(width: 25, height: 25, child: CircularProgressIndicator()),
                              )
                                  : (state.resPricesCheckBox == Status.completed)
                                  ? const Icon(Icons.check,color:Colors.blue)
                                  : (state.resPricesCheckBox == Status.warning)
                                  ? const Icon(Icons.warning)
                                  : (state.resPricesCheckBox == Status.failed)
                                  ? const Icon(Icons.error)
                                  : const SizedBox.shrink()
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Theme(
                                  data: ThemeData(unselectedWidgetColor: themeProvider.borderColor),
                                  child: CheckboxListTile(
                                    title: Text(trs.translate('image_sync_text') ?? "Images",style: TextStyle(color:themeProvider.textColor)),
                                    selected: state.imagesCheckBox == Status.initial ? false : true,
                                    value: state.imagesCheckBox == Status.initial ? false : true,
                                    activeColor: Theme.of(context).primaryColor,
                                    onChanged: (value) {},
                                    secondary: Icon(Icons.image,color:themeProvider.iconColor),
                                  ),
                                ),
                              ),
                              (state.imagesCheckBox == Status.onProgress)
                                  ? const Padding(
                                padding: EdgeInsets.only(right: 8.0),
                                child: SizedBox(width: 25, height: 25, child: CircularProgressIndicator()),
                              )
                                  : (state.imagesCheckBox == Status.completed)
                                  ? const Icon(Icons.check,color:Colors.blue)
                                  : (state.imagesCheckBox == Status.warning)
                                  ? const Icon(Icons.warning)
                                  : (state.imagesCheckBox == Status.failed)
                                  ? const Icon(Icons.error)
                                  :const SizedBox.shrink()
                            ],
                          ),
                        ]);
                      } else if (state is DbSyncedState) {
                        return ListView(children: [
                          Row(
                            children: [
                              Expanded(
                                child: Theme(
                                  data: ThemeData(unselectedWidgetColor: themeProvider.borderColor),
                                  child: CheckboxListTile(
                                    title: Text(trs.translate('company_sync_text') ?? "Company data",style: TextStyle(color:themeProvider.textColor)),
                                    selected: state.companyInfCheckbox == Status.initial ? false : true,
                                    value: state.companyInfCheckbox == Status.initial ? false : true,
                                    activeColor: Theme.of(context).primaryColor,
                                    onChanged: (value) {
                                      BlocProvider.of<DbSyncPageCubit>(context).companyInfCheckboxClicked();
                                    },
                                    secondary: Icon(Icons.apartment,color:themeProvider.iconColor),
                                  ),
                                ),
                              ),
                              (state.companyInfCheckbox == Status.onProgress)
                                  ? const Padding(
                                padding: EdgeInsets.only(right: 8),
                                child: SizedBox(width: 25, height: 25, child: CircularProgressIndicator()),
                              )
                                  : (state.companyInfCheckbox == Status.completed)
                                  ? const Icon(Icons.check,color:Colors.blue)
                                  : (state.companyInfCheckbox == Status.warning)
                                  ? const Icon(Icons.warning)
                                  : (state.companyInfCheckbox == Status.failed)
                                  ? const Icon(Icons.error)
                                  : const SizedBox.shrink()
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Theme(
                                  data: ThemeData(unselectedWidgetColor: themeProvider.borderColor),
                                    child: CheckboxListTile(
                                    title: Text(trs.translate('resource_sync_text') ?? "Resources",style: TextStyle(color:themeProvider.textColor)),
                                    selected: state.resourcesCheckBox == Status.initial ? false : true,
                                    value: state.resourcesCheckBox == Status.initial ? false : true,
                                    activeColor: Theme.of(context).primaryColor,
                                    onChanged: (value) {
                                      BlocProvider.of<DbSyncPageCubit>(context).resourcesCheckBoxClicked();
                                    },
                                    secondary: Icon(Icons.backpack,color:themeProvider.iconColor),
                                  ),
                                ),
                              ),
                              (state.resourcesCheckBox == Status.onProgress)
                                  ? const Padding(
                                padding: EdgeInsets.only(right: 8),
                                child: SizedBox(width: 25, height: 25, child: CircularProgressIndicator()),
                              )
                                  : (state.resourcesCheckBox == Status.completed)
                                  ? const Icon(Icons.check,color:Colors.blue)
                                  : (state.resourcesCheckBox == Status.warning)
                                  ? const Icon(Icons.warning)
                                  : (state.resourcesCheckBox == Status.failed)
                                  ? const Icon(Icons.error)
                                  : const SizedBox.shrink()
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Theme(
                                  data: ThemeData(unselectedWidgetColor: themeProvider.borderColor),
                                  child: CheckboxListTile(
                                    title: Text(trs.translate('res_price_sync_text') ?? "Resource prices",style: TextStyle(color:themeProvider.textColor)),
                                    selected: state.resPricesCheckBox == Status.initial ? false : true,
                                    value: state.resPricesCheckBox == Status.initial ? false : true,
                                    activeColor: Theme.of(context).primaryColor,
                                    onChanged: (value) {
                                      BlocProvider.of<DbSyncPageCubit>(context).resPricesCheckBoxClicked();
                                    },
                                    secondary: Icon(Icons.sell,color:themeProvider.iconColor),
                                  ),
                                ),
                              ),
                              (state.resPricesCheckBox == Status.onProgress)
                                  ? const Padding(
                                padding: EdgeInsets.only(right: 8),
                                child: SizedBox(width: 25, height: 25, child: CircularProgressIndicator()),
                              )
                                  : (state.resPricesCheckBox == Status.completed)
                                  ? const Icon(Icons.check,color:Colors.blue)
                                  : (state.resPricesCheckBox == Status.warning)
                                  ? const Icon(Icons.warning)
                                  : (state.resPricesCheckBox == Status.failed)
                                  ? const Icon(Icons.error)
                                  :const SizedBox.shrink()
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Theme(
                                  data: ThemeData(unselectedWidgetColor: themeProvider.borderColor),
                                  child: CheckboxListTile(
                                    title: Text(trs.translate('image_sync_text') ?? "Images",style: TextStyle(color:themeProvider.textColor)),
                                    selected: state.imagesCheckBox == Status.initial ? false : true,
                                    value: state.imagesCheckBox == Status.initial ? false : true,
                                    activeColor: Theme.of(context).primaryColor,
                                    onChanged: (value) {
                                      BlocProvider.of<DbSyncPageCubit>(context).imagesCheckBoxClickedEvent();
                                    },
                                    secondary: Icon(Icons.image,color:themeProvider.iconColor),
                                  ),
                                ),
                              ),
                              (state.imagesCheckBox == Status.onProgress)
                                  ? const Padding(
                                padding: EdgeInsets.only(right: 8.0),
                                child: SizedBox(width: 25, height: 25, child: CircularProgressIndicator()),
                              )
                                  : (state.imagesCheckBox == Status.completed)
                                  ? const Icon(Icons.check,color:Colors.blue)
                                  : (state.imagesCheckBox == Status.warning)
                                  ? const Icon(Icons.warning)
                                  : (state.imagesCheckBox == Status.failed)
                                  ? const Icon(Icons.error)
                                  : const SizedBox.shrink()
                            ],
                          ),
                        ]);
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  ),
                ),
              ],
            )
            :SingleChildScrollView(
              scrollDirection:Axis.vertical,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(top: 30, bottom: 5),
                    child: Row(
                      children: [
                        Transform.translate(offset: const Offset(-25, 0),child: TextButton(onPressed: widget.goBack, child:  Icon(Icons.arrow_back,color: themeProvider.borderColor,))),
                        Transform.translate(offset: const Offset(-40, 0),child: Text(trs.translate('sync')??"Synchronization",style: TextStyle(fontSize:18,color: themeProvider.textColor),)),
                        const Spacer(),
                        IconButton(onPressed: (){
                          context.read<DbSyncPageCubit>().startSyncProcess('token');
                        },icon: const Icon(Icons.cached_outlined,size: 25,),color: themeProvider.iconColor),
                      ],
                    ),
                  ),
                  Divider(
                    height: 2,
                    color: themeProvider.dividerColor,
                  ),
                  SizedBox(
                    height:290,
                    child: BlocBuilder<DbSyncPageCubit, DbSyncPageState>(
                      builder: (context, state) {
                        if (state is DbSyncPageLoadedState) {
                          return ListView(
                            children: [
                              Theme(
                                data: ThemeData(unselectedWidgetColor: themeProvider.borderColor),
                                child: CheckboxListTile(
                                  title: Text(trs.translate('company_sync_text') ?? "Company data",style:TextStyle(color:themeProvider.textColor)),
                                  selected: state.companyInfCheckbox,
                                  value: state.companyInfCheckbox,
                                  activeColor: Theme.of(context).primaryColor,
                                  onChanged: (value) {
                                    BlocProvider.of<DbSyncPageCubit>(context).companyInfCheckboxClicked();
                                  },
                                  secondary: Icon(Icons.apartment,color:themeProvider.iconColor),
                                ),
                              ),
                              Theme(
                                data: ThemeData(unselectedWidgetColor: themeProvider.borderColor),
                                child: CheckboxListTile(
                                  title: Text(trs.translate('resource_sync_text') ?? "Resources",style:TextStyle(color:themeProvider.textColor)),
                                  selected: state.resourcesCheckBox,
                                  value: state.resourcesCheckBox,
                                  activeColor: Theme.of(context).primaryColor,
                                  onChanged: (value) {
                                    BlocProvider.of<DbSyncPageCubit>(context).resourcesCheckBoxClicked();
                                  },
                                  secondary: Icon(Icons.backpack,color:themeProvider.iconColor),
                                ),
                              ),
                              Theme(
                                data: ThemeData(unselectedWidgetColor: themeProvider.borderColor),
                                child: CheckboxListTile(
                                  title: Text(trs.translate('res_price_sync_text') ?? "Resource prices",style:TextStyle(color:themeProvider.textColor)),
                                  selected: state.resPricesCheckBox,
                                  value: state.resPricesCheckBox,
                                  activeColor: Theme.of(context).primaryColor,
                                  onChanged: (value) {
                                    BlocProvider.of<DbSyncPageCubit>(context).resPricesCheckBoxClicked();
                                  },
                                  secondary: Icon(Icons.sell,color:themeProvider.iconColor),
                                ),
                              ),
                              Theme(
                                data: ThemeData(unselectedWidgetColor: themeProvider.borderColor),
                                child: CheckboxListTile(
                                  title: Text(trs.translate('image_sync_text') ?? "Images",style:TextStyle(color:themeProvider.textColor)),
                                  selected: state.imagesCheckBox,
                                  value: state.imagesCheckBox,
                                  activeColor: Theme.of(context).primaryColor,
                                  onChanged: (value) {
                                    BlocProvider.of<DbSyncPageCubit>(context).imagesCheckBoxClickedEvent();
                                  },
                                  secondary: Icon(Icons.image,color:themeProvider.iconColor),
                                ),
                              ),
                            ],
                          );
                        } else if (state is DbSyncingState) {
                          return ListView(children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Theme(
                                    data: ThemeData(unselectedWidgetColor: themeProvider.borderColor),
                                    child: CheckboxListTile(
                                      title: Text(trs.translate('company_sync_text') ?? "Company data",style:TextStyle(color:themeProvider.textColor)),
                                      selected: state.companyInfCheckbox == Status.initial ? false : true,
                                      value: state.companyInfCheckbox == Status.initial ? false : true,
                                      activeColor: Theme.of(context).primaryColor,
                                      onChanged: (value) {},
                                      secondary: Icon(Icons.apartment,color:themeProvider.iconColor),
                                    ),
                                  ),
                                ),
                                (state.companyInfCheckbox == Status.onProgress)
                                    ? const Padding(
                                  padding: EdgeInsets.only(right: 8),
                                  child: SizedBox(width: 25, height: 25, child: CircularProgressIndicator()),
                                )
                                    : (state.companyInfCheckbox == Status.completed)
                                    ? const Icon(Icons.check,color: Colors.blue,)
                                    : (state.companyInfCheckbox == Status.warning)
                                    ? const Icon(Icons.warning)
                                    : (state.companyInfCheckbox == Status.failed)
                                    ? const Icon(Icons.error)
                                    : const SizedBox.shrink()
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Theme(
                                    data: ThemeData(unselectedWidgetColor: themeProvider.borderColor),
                                    child: CheckboxListTile(
                                      title: Text(trs.translate('resource_sync_text') ?? "Resources",style:TextStyle(color:themeProvider.textColor)),
                                      selected: state.resourcesCheckBox == Status.initial ? false : true,
                                      value: state.resourcesCheckBox == Status.initial ? false : true,
                                      activeColor: Theme.of(context).primaryColor,
                                      onChanged: (value) {},
                                      secondary: Icon(Icons.backpack,color:themeProvider.iconColor),
                                    ),
                                  ),
                                ),
                                (state.resourcesCheckBox == Status.onProgress)
                                    ? const Padding(
                                  padding: EdgeInsets.only(right: 8),
                                  child: SizedBox(width: 25, height: 25, child: CircularProgressIndicator()),
                                )
                                    : (state.resourcesCheckBox == Status.completed)
                                    ? const Icon(Icons.check,color:Colors.blue)
                                    : (state.resourcesCheckBox == Status.warning)
                                    ? const Icon(Icons.warning)
                                    : (state.resourcesCheckBox == Status.failed)
                                    ? const Icon(Icons.error)
                                    : const SizedBox.shrink()
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Theme(
                                    data: ThemeData(unselectedWidgetColor: themeProvider.borderColor),
                                    child: CheckboxListTile(
                                      title: Text(trs.translate('res_price_sync_text') ?? "Resource prices",style:TextStyle(color:themeProvider.textColor)),
                                      selected: state.resPricesCheckBox == Status.initial ? false : true,
                                      value: state.resPricesCheckBox == Status.initial ? false : true,
                                      activeColor: Theme.of(context).primaryColor,
                                      onChanged: (value) {},
                                      secondary: Icon(Icons.sell,color:themeProvider.iconColor),
                                    ),
                                  ),
                                ),
                                (state.resPricesCheckBox == Status.onProgress)
                                    ? const Padding(
                                  padding: EdgeInsets.only(right: 8),
                                  child: SizedBox(width: 25, height: 25, child: CircularProgressIndicator()),
                                )
                                    : (state.resPricesCheckBox == Status.completed)
                                    ? const Icon(Icons.check,color:Colors.blue)
                                    : (state.resPricesCheckBox == Status.warning)
                                    ? const Icon(Icons.warning)
                                    : (state.resPricesCheckBox == Status.failed)
                                    ? const Icon(Icons.error)
                                    : const SizedBox.shrink()
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Theme(
                                    data: ThemeData(unselectedWidgetColor: themeProvider.borderColor),
                                    child: CheckboxListTile(
                                      title: Text(trs.translate('image_sync_text') ?? "Images",style:TextStyle(color:themeProvider.textColor)),
                                      selected: state.imagesCheckBox == Status.initial ? false : true,
                                      value: state.imagesCheckBox == Status.initial ? false : true,
                                      activeColor: Theme.of(context).primaryColor,
                                      onChanged: (value) {},
                                      secondary: Icon(Icons.image,color:themeProvider.iconColor),
                                    ),
                                  ),
                                ),
                                (state.imagesCheckBox == Status.onProgress)
                                    ? const Padding(
                                  padding: EdgeInsets.only(right: 8.0),
                                  child: SizedBox(width: 25, height: 25, child: CircularProgressIndicator()),
                                )
                                    : (state.imagesCheckBox == Status.completed)
                                    ? const Icon(Icons.check,color:Colors.blue)
                                    : (state.imagesCheckBox == Status.warning)
                                    ? const Icon(Icons.warning)
                                    : (state.imagesCheckBox == Status.failed)
                                    ? const Icon(Icons.error)
                                    : const SizedBox.shrink()
                              ],
                            ),
                          ]);
                        } else if (state is DbSyncedState) {
                          return ListView(children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Theme(
                                    data: ThemeData(unselectedWidgetColor: themeProvider.borderColor),
                                    child: CheckboxListTile(
                                      title: Text(trs.translate('company_sync_text') ?? "Company data",style:TextStyle(color:themeProvider.textColor)),
                                      selected: state.companyInfCheckbox == Status.initial ? false : true,
                                      value: state.companyInfCheckbox == Status.initial ? false : true,
                                      activeColor: Theme.of(context).primaryColor,
                                      onChanged: (value) {
                                        BlocProvider.of<DbSyncPageCubit>(context).companyInfCheckboxClicked();
                                      },
                                      secondary: Icon(Icons.apartment,color:themeProvider.iconColor),
                                    ),
                                  ),
                                ),
                                (state.companyInfCheckbox == Status.onProgress)
                                    ? const Padding(
                                  padding: EdgeInsets.only(right: 8),
                                  child: SizedBox(width: 25, height: 25, child: CircularProgressIndicator()),
                                )
                                    : (state.companyInfCheckbox == Status.completed)
                                    ? const Icon(Icons.check,color:Colors.blue)
                                    : (state.companyInfCheckbox == Status.warning)
                                    ? const Icon(Icons.warning)
                                    : (state.companyInfCheckbox == Status.failed)
                                    ? const Icon(Icons.error)
                                    : const SizedBox.shrink()
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Theme(
                                    data: ThemeData(unselectedWidgetColor: themeProvider.borderColor),
                                    child: CheckboxListTile(
                                      title: Text(trs.translate('resource_sync_text') ?? "Resources",style:TextStyle(color:themeProvider.textColor)),
                                      selected: state.resourcesCheckBox == Status.initial ? false : true,
                                      value: state.resourcesCheckBox == Status.initial ? false : true,
                                      activeColor: Theme.of(context).primaryColor,
                                      onChanged: (value) {
                                        BlocProvider.of<DbSyncPageCubit>(context).resourcesCheckBoxClicked();
                                      },
                                      secondary: Icon(Icons.backpack,color:themeProvider.iconColor),
                                    ),
                                  ),
                                ),
                                (state.resourcesCheckBox == Status.onProgress)
                                    ? const Padding(
                                  padding: EdgeInsets.only(right: 8),
                                  child: SizedBox(width: 25, height: 25, child: CircularProgressIndicator()),
                                )
                                    : (state.resourcesCheckBox == Status.completed)
                                    ? const Icon(Icons.check,color:Colors.blue)
                                    : (state.resourcesCheckBox == Status.warning)
                                    ? const Icon(Icons.warning)
                                    : (state.resourcesCheckBox == Status.failed)
                                    ? const Icon(Icons.error)
                                    : const SizedBox.shrink()
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Theme(
                                    data: ThemeData(unselectedWidgetColor: themeProvider.borderColor),
                                    child: CheckboxListTile(
                                      title: Text(trs.translate('res_price_sync_text') ?? "Resource prices",style:TextStyle(color:themeProvider.textColor)),
                                      selected: state.resPricesCheckBox == Status.initial ? false : true,
                                      value: state.resPricesCheckBox == Status.initial ? false : true,
                                      activeColor: Theme.of(context).primaryColor,
                                      onChanged: (value) {
                                        BlocProvider.of<DbSyncPageCubit>(context).resPricesCheckBoxClicked();
                                      },
                                      secondary: Icon(Icons.sell,color:themeProvider.iconColor),
                                    ),
                                  ),
                                ),
                                (state.resPricesCheckBox == Status.onProgress)
                                    ? const Padding(
                                  padding: EdgeInsets.only(right: 8),
                                  child: SizedBox(width: 25, height: 25, child: CircularProgressIndicator()),
                                )
                                    : (state.resPricesCheckBox == Status.completed)
                                    ? const Icon(Icons.check,color:Colors.blue)
                                    : (state.resPricesCheckBox == Status.warning)
                                    ? const Icon(Icons.warning)
                                    : (state.resPricesCheckBox == Status.failed)
                                    ? const Icon(Icons.error)
                                    : const SizedBox.shrink()
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Theme(
                                    data: ThemeData(unselectedWidgetColor: themeProvider.borderColor),
                                    child: CheckboxListTile(
                                      title: Text(trs.translate('image_sync_text') ?? "Images",style:TextStyle(color:themeProvider.textColor)),
                                      selected: state.imagesCheckBox == Status.initial ? false : true,
                                      value: state.imagesCheckBox == Status.initial ? false : true,
                                      activeColor: Theme.of(context).primaryColor,
                                      onChanged: (value) {
                                        BlocProvider.of<DbSyncPageCubit>(context).imagesCheckBoxClickedEvent();
                                      },
                                      secondary: Icon(Icons.image,color:themeProvider.iconColor),
                                    ),
                                  ),
                                ),
                                (state.imagesCheckBox == Status.onProgress)
                                    ? const Padding(
                                  padding: EdgeInsets.only(right: 8.0),
                                  child: SizedBox(width: 25, height: 25, child: CircularProgressIndicator()),
                                )
                                    : (state.imagesCheckBox == Status.completed)
                                    ? const Icon(Icons.check,color:Colors.blue)
                                    : (state.imagesCheckBox == Status.warning)
                                    ? const Icon(Icons.warning)
                                    : (state.imagesCheckBox == Status.failed)
                                    ? const Icon(Icons.error)
                                    : const SizedBox.shrink()
                              ],
                            ),
                          ]);
                        } else {
                          return const SizedBox.shrink();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
