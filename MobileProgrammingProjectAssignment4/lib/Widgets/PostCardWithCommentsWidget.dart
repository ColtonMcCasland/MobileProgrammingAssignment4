import 'package:flutter/material.dart';
import 'package:all_posts/Models/Post.dart';
import 'package:provider/provider.dart';
import 'package:all_posts/Models/DataProvider.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:all_posts/Widgets/CommentsWidget.dart';
import 'package:all_posts/Models/User.dart';
import 'package:all_posts/Pages/User_page.dart';
import 'package:pk_skeleton/pk_skeleton.dart';


class PostCardWithCommentsWidgets extends StatelessWidget{
  
  final Post post;

  PostCardWithCommentsWidgets(this.post);

  @override
  Widget build(BuildContext context) {

    final data = Provider.of<DataProvider>(context);

    return 
    FutureBuilder<User>
    (
      future: data.getUser(this.post.userId),
      builder: (context,snapshot)
      {
        if(snapshot.hasData){
          return
          (
            Container
            (
              margin: EdgeInsets.only(bottom: 10),
              child: 
              Card
              (
                elevation: 5,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
                child: 
                Container
                (
                  margin: EdgeInsets.only(bottom: 10),
                  padding: EdgeInsets.all(10),
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
                          GestureDetector
                          (
                            child: Text(snapshot.data.name,style: TextStyle(fontSize: 20)),
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context){                
                                return 
                                ChangeNotifierProvider
                                (
                                  builder: (context) => DataProvider(),
                                  child: User_page(this.post.userId)
                                );
                              }));
                            },
                          )
                        ],
                      ),
                      Row
                      (
                        children: <Widget>
                        [
                          Container
                          (
                            width: 300,
                            child: Text(this.post.title, style: TextStyle(fontWeight: FontWeight.bold ,fontSize: 20)),
                          )          
                        ]               
                      ),
                      Row
                      (

                        children: <Widget>
                        [

                          Container
                          (
                            margin: EdgeInsets.only(top: 20),
                            width: 300,
                            child: Text(this.post.body),
                          )          
                        ]
                      ),  
                      Row
                      (
                        children: <Widget>
                        [
                          Text("\nComments\n", style: TextStyle(fontWeight: FontWeight.bold ,fontSize: 20),)
                        ],
                      ),
                      Row
                      (
                        children: <Widget>
                        [
                          Flexible
                          (
                            child: 
                            CommentsWidget(this.post)
                          )
                        ],
                      )         
                    ],
                  ),
                )
              ),
            )
          );
        }
        else{
          return
          PKCardPageSkeleton(
            totalLines: 1,
          );
        }
      }
    );
  }
}