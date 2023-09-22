import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterlayouts/assignment/ChooseImageNotifier.dart';
import 'package:flutterlayouts/assignment/ViewEditImage.dart';
import 'package:flutterlayouts/common/Utils.dart';
import 'package:http_parser/http_parser.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as path;
import 'package:toast/toast.dart';
class UploadPicture extends StatefulWidget {
  const UploadPicture({Key? key}) : super(key: key);

  @override
  State<UploadPicture> createState() => _UploadPictureState();
}

class _UploadPictureState extends State<UploadPicture> {

  late ChooseImageNotifier chooseImageNotifier ;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    chooseImageNotifier = Provider.of<ChooseImageNotifier>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload Picture"),
        elevation: 0,
      ),
      body: Container(
        child: Column(
         mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.all(10),
                alignment: Alignment.center,
                color: Colors.black.withOpacity(0.1),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  // Adjust the radius as needed
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: FileImage(File(chooseImageNotifier.croppedFile!.path)),
                        fit: BoxFit.cover, // Y
                          alignment: Alignment.topCenter
                      ),
                    ),
                  )
                  // Image.file(new File(chooseImageNotifier.croppedFile!.path),
                  //   fit: BoxFit.cover,
                  // ),
                ),
              ), flex: 12,),

            SizedBox(height: 10,),
            Expanded(child: Container(
              child: Text("Picture ready to be saved"),
            ),),
            Expanded(
              child: CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  _uploadImage();
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.pink,
                  ),
                  child: Text("Save and Continue",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                ),
              ),)
          ],
        ),
      ),
    );
  }


  String accessToken="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyIjoiclhnY1Y2YXh3eVRobTNQdE04aGtSaXJTQ2ZsMiIsImlhdCI6MTY5NTIzMTc5MSwiZXhwIjoxNjk2NTI3NzkxfQ.9W-QURjNQWAtZIqzYB3-yvJWeCayXvojHcIRmjpVD4A";
  Future<void> _uploadImage() async {
    FormData formData = FormData();
    formData.files.add(MapEntry(
      'profileBannerImageURL', // Field name for the image
      await MultipartFile.fromFile(chooseImageNotifier.croppedFile!.path,contentType: MediaType('image', 'jpg')), // Replace with your image file path
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

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ViewEditImage()),
      );
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
}

