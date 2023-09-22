import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterlayouts/assignment/ChooseImageNotifier.dart';
import 'package:flutterlayouts/assignment/UploadPicture.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
class ChooseImage extends StatefulWidget {
  const ChooseImage({Key? key}) : super(key: key);

  @override
  State<ChooseImage> createState() => _ChooseImageState();
}

class _ChooseImageState extends State<ChooseImage> {

  late ChooseImageNotifier chooseImageNotifier ;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    chooseImageNotifier = Provider.of<ChooseImageNotifier>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Change Design"),
        elevation: 0,
      ),
      body: Container(
        child: CupertinoButton(
          onPressed: (){
            showBSSelect();
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.blue.withOpacity(0.5),
            ),
            padding: EdgeInsets.all(15),

            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Upload Picture",style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold))
              ],
            ),
          ),
        ),
      ),
    );
  }


  showBSSelect() async{
    chooseImageNotifier.selectedImage = await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CupertinoButton(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    widgetIconCircle(Icons.camera),
                    SizedBox(height: 5,),
                    Text("Camera",style: TextStyle(color: Colors.black),)
                  ],
                ),
                onPressed: () {
                  _selectImage(context,ImageSource.camera);
                },
              ),
              CupertinoButton(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    widgetIconCircle(Icons.image),
                    SizedBox(height: 5,),
                    Text("Gallery",style: TextStyle(color: Colors.black))
                  ],
                ),
                onPressed: () {
                  _selectImage(context,ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
    // Use the selectedImage as needed (e.g., display it)
    if (chooseImageNotifier.selectedImage != null) {
      showImageWithCropper();
    }
  }
  Future<void> _selectImage(BuildContext context, ImageSource isource) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: isource);
    if (pickedFile != null) {
      // Handle the selected image (you can save it, display it, or do anything else)
      File selectedImage = File(pickedFile.path);
      Navigator.pop(context, selectedImage);
    } else {
      // User canceled the image selection
    }
  }
  Widget widgetIconCircle(IconData icon){
    return Container(
      width: 40,
      height: 40,
      padding: EdgeInsets.all(5),
      child: Icon(icon,color: Colors.red,),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        border: Border.all(
          color: Colors.black38,
          width: 1
        )
      ),
    );
  }
   showImageWithCropper() async{
   chooseImageNotifier.croppedFile= await ImageCropper().cropImage(
      sourcePath: chooseImageNotifier.selectedImage.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
        ),
        WebUiSettings(
          context: context,
        ),
      ],
    );
    if(chooseImageNotifier.croppedFile!=null){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const UploadPicture()),
      );
    }
  }

}
