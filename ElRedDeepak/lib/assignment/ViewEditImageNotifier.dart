import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:image_cropper/image_cropper.dart';

class ViewEditImageNotifier extends ChangeNotifier {
  String profileBannerImageUrl="";
  var rng = Random();
  void setProfileBannerImageUrl(String imgUrl){
    profileBannerImageUrl=imgUrl;
    profileBannerImageUrl=profileBannerImageUrl+"?="+rng.nextInt(99999).toString();
    notifyListeners();
  }



  File ? selectedImage;
  CroppedFile ?  croppedFile;
  void setSelectedImage(File choosedImage){
    selectedImage=choosedImage;
    notifyListeners();
  }

  void setCroppedFile(){
    croppedFile=croppedFile;
    notifyListeners();
  }
}