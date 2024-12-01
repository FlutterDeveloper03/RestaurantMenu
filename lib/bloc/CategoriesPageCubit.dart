// ignore_for_file: file_names

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurantmenu/models/tbl_dk_res_category.dart';

//region States
class CategoriesPageState extends Equatable{
  @override
  List<Object?> get props => [];
}

class CategoriesPageInitialState extends CategoriesPageState{}
class LoadingCategoriesPageState extends CategoriesPageState{}
class CategoriesPageLoadedState extends CategoriesPageState{
  final int categoriesCount;

  CategoriesPageLoadedState(this.categoriesCount);

  @override
  List<Object?> get props => [categoriesCount];
}

class CategoriesPageLoadErrorState extends CategoriesPageState{
  final String errorMsg;

  CategoriesPageLoadErrorState(this.errorMsg);

  @override
  List<Object?> get props => [errorMsg];
}
//endregion states

//region Cubit
class CategoriesPageCubit extends Cubit<CategoriesPageState>{
  CategoriesPageCubit():super(CategoriesPageInitialState());

  void loadCategories(List<TblDkResCategory> categories){
    emit(LoadingCategoriesPageState());
    try{
      emit(CategoriesPageLoadedState(categories.length));
    }catch(e){
      emit(CategoriesPageLoadErrorState("Error on LoadCategoriesEvent: $e"));
    }
  }

}
//endregion Cubit