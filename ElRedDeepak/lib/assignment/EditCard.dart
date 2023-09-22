import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterlayouts/assignment/CustomizeCard.dart';
import 'package:flutterlayouts/assignment/ViewEditImageNotifier.dart';
import 'package:provider/provider.dart';
class EditCard extends StatefulWidget {
  const EditCard({Key? key}) : super(key: key);

  @override
  State<EditCard> createState() => _EditCardState();
}

class _EditCardState extends State<EditCard> {
  late ViewEditImageNotifier viewEditImageNotifier;


  @override
  Widget build(BuildContext context) {
    viewEditImageNotifier = Provider.of<ViewEditImageNotifier>(context,listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text("Custom Image Card"),
        elevation: 0,
      ),
      body:  Container(
        color: Colors.grey.withOpacity(0.2),
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
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
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(data.profileBannerImageUrl),
                                fit: BoxFit.cover,
                                  alignment: Alignment.topCenter
                              ),
                            ),
                          ),
                        );
                        //  Image.network(data.profileBannerImageUrl,fit: BoxFit.cover,alignment: Alignment.center);
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
                  Container(
                    alignment: Alignment.topRight,

                    child: CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>  CustomizeCard()),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        padding: EdgeInsets.only(left: 10,right: 10,top: 5,bottom: 5),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.edit,color: Colors.pink,),
                            SizedBox(width: 5,),
                            Text("Customize",style: TextStyle(color: Colors.pink,fontWeight: FontWeight.bold),),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ), flex: 7,),
            SizedBox(height: 10,),
            Expanded(
                child: CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => const EditCard()),
                    // );
                    Navigator.pop(context);
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
    );
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
