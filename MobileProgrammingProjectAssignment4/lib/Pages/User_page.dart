import 'package:all_posts/Models/ThumbnailAndTitle.dart';
import 'package:all_posts/Widgets/ThumbnailAndTitleWidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:all_posts/Models/DataProvider.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:all_posts/Models/User.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:all_posts/Widgets/PostCardWithCommentsWidget.dart';
import 'package:all_posts/Models/Post.dart';




class User_page extends StatelessWidget{


  final int userID;

  User_page(this.userID);

  double lat, lng;

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  
  @override
  Widget build(BuildContext context) {

    final data = Provider.of<DataProvider>(context);

    return 
    Scaffold
    (
      body: 
      SafeArea
      (
        child: 
        Builder
        (
          builder: (context)=>
          Center
          (
            child:
            FutureBuilder<User>
            (
              future: data.getUser(this.userID),
              builder: (context, snapshot){
                if(snapshot.hasData){


//                Parse lat and long from payload
                  lat = double.parse(snapshot.data.address.geo.lat);
                  lng = double.parse(snapshot.data.address.geo.lng);
                  _add(); // add marker showing lat and long position


                  return
                  (
                    Padding
                    (
                      padding: EdgeInsets.all(20),
                      child:
                      Column
                      (
                        children: <Widget>
                        [
                          Row
                          (
                            children: <Widget>
                            [
                              Icon(MdiIcons.account,size: 30),
                              Text(snapshot.data.name, style: TextStyle(fontSize: 20))
                            ],
                          ),
                          Row
                          (
                            children: <Widget>
                            [
                              Icon(MdiIcons.web,size: 30),
                              Text(snapshot.data.website, style: TextStyle(fontSize: 20)),
                            ],
                          ),
                          Row
                            (
                            children: <Widget>
                            [
                              Icon(MdiIcons.email,size: 30),
                              Text(snapshot.data.email, style: TextStyle(fontSize: 20))
                            ],
                          ),
                          Row
                            (
                            children: <Widget>
                            [
                              Icon(MdiIcons.phone,size: 30),
                              Text(snapshot.data.phone, style: TextStyle(fontSize: 20))
                            ],
                          ),
//                          Row
//                            (
//                            children: <Widget>
//                            [
//                              Icon(MdiIcons.pin,size: 30),
//                              Text(lat.toString() + " " + lng.toString(), style: TextStyle(fontSize: 20))
//                            ],
//                          ),
                          SizedBox(height: 10),
                          Row
                          (
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>
                            [
                              Text("All User Posts",style: TextStyle(fontSize: 20)),
                            ],
                          ),
                          SizedBox(height: 20),
                          Flexible
                          (
                            child:
                            FutureBuilder<List<Post>>
                            (
                              future: data.getPostsByUser(this.userID),
                              builder: (context, snapshot){
                                if(snapshot.hasData){
                                  return
                                  ListView.builder
                                  (
                                    itemCount: snapshot.data.length,
                                    itemBuilder: (context, index){
                                      return
                                        PostCardWithCommentsWidgets(snapshot.data[index]);
                                    },
                                  );
                                }
                                else{
                                  return
                                  CircularProgressIndicator();
                                }
                              }
                            )
                          ),
                            Flexible
                            (
                                child:
                                GoogleMap(
                            onMapCreated:(GoogleMapController controller)
                            {_controller.complete(controller);_goToUser();},
                                  initialCameraPosition: CameraPosition(target: LatLng(lat,lng),),
                                  markers: Set<Marker>.of(markers.values),
                                ),
                            ),
                        ],
                      )
                    )
                  );
                }
                else{
                  return
                  CircularProgressIndicator();
                }
              }
            )
          ),
        )
      )
    );
  }
  Completer<GoogleMapController> _controller = Completer();

  Future<void> _goToUser() async {

    final GoogleMapController controller = await _controller.future;

    controller.animateCamera(
        CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(lat, lng),)
        )
    );
  }


  void _add() {
    var markerIdVal = "current location";
    final MarkerId markerId = MarkerId(markerIdVal);

    // creating a new MARKER
    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(lat, lng,),
      infoWindow: InfoWindow(title: markerIdVal, snippet: '*'),

    );

      // adding a new marker to map
      markers[markerId] = marker;
  }

}
