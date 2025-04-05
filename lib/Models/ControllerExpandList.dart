import 'package:flutter/material.dart';

class ControllerExpandList{

  ScrollController controller = ScrollController() ;
  int countList = 0;
  bool hasNeedUpdate = false;

  ControllerExpandList(this.countList);

  ///Controle de Expansao do Filtro.
  int controllerToExpand(var listDynamic, int amountList) {
    if(listDynamic.length >= countList) {
      amountList = countList;
      hasNeedUpdate = true;
    }else{
      amountList = listDynamic.length;
      hasNeedUpdate = false;
    }
    
    return amountList;
  }



}