import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:image_cropper/image_cropper.dart';

class CustomizeCardNotifier extends ChangeNotifier {
  late File selectedImage;
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