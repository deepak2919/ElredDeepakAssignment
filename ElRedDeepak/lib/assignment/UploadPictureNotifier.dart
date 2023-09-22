
import 'package:flutter/cupertino.dart';

class UploadPictureNotifier extends ChangeNotifier {
  String profileBannerImageUrl="";
  void profileBannerUrl(String pbiu){
    profileBannerImageUrl=pbiu;
  }
}