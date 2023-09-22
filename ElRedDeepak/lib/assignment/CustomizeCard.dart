import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutterlayouts/assignment/ViewEditImageNotifier.dart';
import 'package:flutterlayouts/common/Utils.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'dart:ui' as ui;

import 'package:screenshot/screenshot.dart';
import 'package:toast/toast.dart'; // Import the dart:ui package
class CustomizeCard extends StatefulWidget {
  const CustomizeCard({Key? key}) : super(key: key);

  @override
  State<CustomizeCard> createState() => _CustomizeCardState();
}

class _CustomizeCardState extends State<CustomizeCard> {


  @override
  void dispose() {
    // Dispose of the provider when the widget is removed from the tree
    super.dispose();
    viewEditImageNotifier.croppedFile=null;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) {

    });
  }

  final ScreenshotController _screenshotController = ScreenshotController();
  late ViewEditImageNotifier viewEditImageNotifier;
  GlobalKey _photoViewKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    viewEditImageNotifier = Provider.of<ViewEditImageNotifier>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Customize Your Card"),
        actions: [
          CupertinoButton(
              child: Icon(Icons.close,color: Colors.black,),
            onPressed: (){
                Navigator.pop(context);
            },
          )
        ],
      ),
      body:Container(
        color: Colors.grey.withOpacity(0.2),
        padding: EdgeInsets.all(10),
        child: Container(
          width: MediaQuery.of(context).size.width/1.1,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CupertinoButton(
                padding: EdgeInsets.zero,
                color: Colors.lightBlue.withOpacity(0.2),
                onPressed: () {
                  showBSSelect();
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),

                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.image,color: Colors.blue,),
                      SizedBox(width: 10,),
                      Text("Change picture here and adjust")
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10,),
              Expanded(child: Container(
                alignment: Alignment.topCenter,
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Consumer<ViewEditImageNotifier>(
                        builder: (context, data, child){
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(16.0),
                            child: Container(
                              alignment: Alignment.center,
                              child: Screenshot(
                                controller: _screenshotController,
                                child: viewEditImageNotifier.croppedFile!=null?PhotoView(
                                  key: ValueKey("panZoomedImage"), // Add a key to the PhotoView widget
                                  imageProvider:
                                  FileImage(File(viewEditImageNotifier.croppedFile!.path)),
                                  basePosition: Alignment.topCenter,
                                  backgroundDecoration: BoxDecoration(
                                    color: Colors.black,
                                  ),
                                  minScale: PhotoViewComputedScale.covered,
                                  maxScale: PhotoViewComputedScale.covered,
                                ):
                                PhotoView(
                                  key: ValueKey("panZoomedImage"), // Add a key to the PhotoView widget
                                  imageProvider: NetworkImage(
                                      data.profileBannerImageUrl
                                  ),
                                  basePosition: Alignment.topCenter,
                                  backgroundDecoration: BoxDecoration(
                                    color: Colors.black,
                                  ),
                                  minScale: PhotoViewComputedScale.covered,
                                  maxScale: PhotoViewComputedScale.covered,
                                ),
                              ),
                            ),
                          );
                           // Image.network(data.profileBannerImageUrl,fit: BoxFit.cover,alignment: Alignment.center);
                        }),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                            margin: EdgeInsets.only(top: 20),
                            alignment: Alignment.topCenter,
                            child: CircularImageWidget()
                        ),
                        SizedBox(height: 10,),
                        Text("Alaxandra",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18),),
                        SizedBox(height: 10,),
                        Text("Stanton",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 14),)
                      ],
                    ),

                  ],
                ),
              ), flex: 9,),

              Expanded(
                  child: CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      CapturePannedImage();
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.pink,

                      ),

                      child: Text("Save", style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
  void CapturePannedImage()async{
    final Directory tempDir = await getTemporaryDirectory();
    final Uint8List ? imageBytes = await  _screenshotController.capture();
    String filePath=tempDir.path+"/"+"test.jpg";
    File  capturedFile=await uint8ListToFile(imageBytes,filePath);
    _uploadImage(capturedFile.path);
  }

  Future<File> uint8ListToFile(Uint8List ? uint8list, String filePath) async {
    final file = File(filePath);
    await file.writeAsBytes(uint8list!);
    return file;
  }

  String accessToken="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyIjoiclhnY1Y2YXh3eVRobTNQdE04aGtSaXJTQ2ZsMiIsImlhdCI6MTY5NTIzMTc5MSwiZXhwIjoxNjk2NTI3NzkxfQ.9W-QURjNQWAtZIqzYB3-yvJWeCayXvojHcIRmjpVD4A";
  Future<void> _uploadImage(String filePath) async {
    FormData formData = FormData();
    formData.files.add(MapEntry(
      'profileBannerImageURL', // Field name for the image
      await MultipartFile.fromFile(filePath,contentType: MediaType('image', 'jpg')), // Replace with your image file path
    ));
    Dio dio = Dio();
    dio.options.headers['Authorization'] = 'Bearer $accessToken';
    try{
      Utils(context).startLoading();
      final response = await dio.post('https://dev.elred.io/postProfileBannerImage', data: formData);
      //print(response);
      Utils(context).stopLoading();
      if(response.data["success"]){
        showToast(response.data["message"].toString(), gravity: Toast.top,duration:Toast.lengthLong);
        Utils(context).stopLoading();
        viewEditImageNotifier.setProfileBannerImageUrl(response.data["result"][0]["profileBannerImageURL"].toString());
        Navigator.pop(context);
      }else{
        showToast(response.data["message"].toString(), gravity: Toast.top,duration:Toast.lengthLong);
      }
    } catch (e) {
      Utils(context).stopLoading();
      if (e is DioError && e.response != null) {
        print('Response Data: ${e.response?.data}');
        print('Response Headers: ${e.response?.headers}');
      }
      // Handle the error here
      print('DioException: $e');
    }
  }
  void showToast(String msg, {int? duration, int? gravity}) {
    Toast.show(msg, duration: duration, gravity: gravity);
  }



  showBSSelect() async{
    viewEditImageNotifier.selectedImage = await showModalBottomSheet(
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
    if (viewEditImageNotifier.selectedImage != null) {
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
    viewEditImageNotifier.croppedFile= await ImageCropper().cropImage(
      sourcePath: viewEditImageNotifier.selectedImage!.path,
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
    if(viewEditImageNotifier.croppedFile!=null){
      viewEditImageNotifier.setCroppedFile();
    }
  }

}

class CircularImageWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.0, // Adjust the width as needed
      height: 100.0, // Adjust the height as needed
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white, // Set the border color to white
          width: 3.0, // Set the border width as needed
        ),
      ),
      child: ClipOval(
        child: Image.network(
          'https://source.unsplash.com/user/c_v_r/100x100', // Replace with your image URL
          width: 100.0, // Adjust the width as needed
          height: 100.0, // Adjust the height as needed
          fit: BoxFit.cover, // You can choose how to fit the image inside the circle
        ),
      ),
    );
  }
}
