import 'package:all_posts/Widgets/PostCardWithCommentsWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:all_posts/Models/DataProvider.dart';
import 'package:all_posts/Widgets/PostCardWidget.dart';
import 'package:all_posts/Models/Post.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:http/http.dart';



class Posts_page extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    
    return 
    _Posts();
  }

}

class _Posts extends State<Posts_page>{
  

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
          (
            Center
            (
              child: 
              Column
              (
                children: <Widget>
                [
//
                  Flexible
                  (
                    child: 
                    FutureBuilder<List<Post>>
                    (
                      future: data.getPosts(),
                      builder: (context,snapshot)
                      {

                        if(snapshot.hasData){
                          return
                          ListView.builder
                          (
                            itemCount: snapshot.data.length,
                            itemBuilder: (context,index){

                                return
                                PostCardWidget(snapshot.data[index]);

                            },
                          );
                        }
                        else
                        {
                          return
                          Icon(Icons.error_outline);
                        }
                      }
                    )
                  ),
                ],
              )
            )
          )          
        )
      ),
    );
  }

}
