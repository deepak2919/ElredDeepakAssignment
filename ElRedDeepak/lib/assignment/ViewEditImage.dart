import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterlayouts/assignment/EditCard.dart';
import 'package:flutterlayouts/assignment/ViewEditImageNotifier.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
class ViewEditImage extends StatefulWidget {
  const ViewEditImage({Key? key}) : super(key: key);

  @override
  State<ViewEditImage> createState() => _ViewEditImageState();
}

class _ViewEditImageState extends State<ViewEditImage> {

  late ViewEditImageNotifier viewEditImageNotifier;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getImageDetails();
  }

  @override
  Widget build(BuildContext context) {
    viewEditImageNotifier = Provider.of<ViewEditImageNotifier>(context,listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text("Artist"),
        elevation: 0,
      ),
      body: Container(

        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(child: Container(
              padding: EdgeInsets.all(10),
              alignment: Alignment.center,
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                Consumer<ViewEditImageNotifier>(
                builder: (context, data, child){
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(16.0),
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(data.profileBannerImageUrl),
                          fit: BoxFit.cover, //
                          alignment: Alignment.topCenter
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
                  )
                ],
              ),
            ), flex: 7,),
            SizedBox(height: 10,),
            Expanded(
              child: CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const EditCard()),
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.pink,
                      width: 1
                    )
                  ),

                  child: Text("Edit Card", style: TextStyle(
                      color: Colors.pink, fontWeight: FontWeight.bold),),
                ),
              ))
          ],
        ),
      ),
    );
  }

  String accessToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyIjoiclhnY1Y2YXh3eVRobTNQdE04aGtSaXJTQ2ZsMiIsImlhdCI6MTY5NTIzMTc5MSwiZXhwIjoxNjk2NTI3NzkxfQ.9W-QURjNQWAtZIqzYB3-yvJWeCayXvojHcIRmjpVD4A";

  Future<void> getImageDetails() async {
    var formData = {
      'cardImageId':
      '6300ba8b5c4ce60057ef9b0c'
    };
    Dio dio = Dio();
    dio.options.headers['Authorization'] = 'Bearer $accessToken';
    try {
      final response = await dio.post(
          'https://dev.elred.io/selectedCardDesignDetails', data: formData);
      if (response.data["success"]) {
        showToast(response.data["message"].toString(), gravity: Toast.top,
            duration: Toast.lengthLong);
        viewEditImageNotifier.setProfileBannerImageUrl(response
            .data["result"][0]["customImageCardDesignInfo"]["profileBannerImageURL"]
            .toString());

      } else {
        showToast(response.data["message"].toString(), gravity: Toast.top,
            duration: Toast.lengthLong);
      }
    } catch (e) {
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
