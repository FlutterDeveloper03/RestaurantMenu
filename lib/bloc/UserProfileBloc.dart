// ignore_for_file: file_names

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurantmenu/helpers/SharedPrefKeys.dart';
import 'package:restaurantmenu/helpers/dbHelper.dart';
import 'package:restaurantmenu/models/tbl_dk_res_price_group.dart';
import 'package:shared_preferences/shared_preferences.dart';

//region States
class UserProfileState extends Equatable{
  @override
  List<Object?> get props => [];
}

class UserProfileInitialState extends UserProfileState{}
class LoadingUserProfileState extends UserProfileState{}
class SavingUserProfileState extends UserProfileState{}
class UserProfileSavedState extends UserProfileState{}
class UserProfileLoadedState extends UserProfileState{
  final List<TblDkResPriceGroup> priceGroups;
  final int selectedPriceGroupId;

  UserProfileLoadedState(this.priceGroups,this.selectedPriceGroupId);

  @override
  List<Object?> get props => [priceGroups,selectedPriceGroupId];
}

class UserProfileLoadErrorState extends UserProfileState{
  final String errorMsg;

  UserProfileLoadErrorState(this.errorMsg);

  @override
  List<Object?> get props => [errorMsg];
}
//endregion states

//region Cubit
class UserProfileCubit extends Cubit<UserProfileState>{
  UserProfileCubit():super(UserProfileInitialState());

  void loadUserProfile()async{
    emit(LoadingUserProfileState());
    try{
      List<TblDkResPriceGroup> priceGroups = (await DbHelper.queryAllRows('tbl_dk_res_price_group')).map((e) => TblDkResPriceGroup.fromMap(e)).toList();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int selectedPriceGroupId = prefs.getInt(SharedPrefKeys.resPriceGroupId) ?? 1;
      emit(UserProfileLoadedState(priceGroups,selectedPriceGroupId));
    }catch(e){
      emit(UserProfileLoadErrorState("Error on LoadCategoriesEvent: $e"));
    }
  }

  void saveUserProfile(int resPriceGroupId) async {
    emit(SavingUserProfileState());
    try{
      SharedPreferences.getInstance().then((prefs) => prefs.setInt(SharedPrefKeys.resPriceGroupId, resPriceGroupId));
      emit(UserProfileSavedState());
    }catch(e){
      emit(UserProfileLoadErrorState("Error on LoadCategoriesEvent: $e"));
    }
  }

}
//endregion Cubit