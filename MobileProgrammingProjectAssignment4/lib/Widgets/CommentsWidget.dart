import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:all_posts/Models/DataProvider.dart';
import 'package:all_posts/Models/Post.dart';
import 'package:all_posts/Models/Comment.dart';

class CommentsWidget extends StatelessWidget{

  final Post post;
  CommentsWidget(this.post);

  @override
  Widget build(BuildContext context) {

    final data = Provider.of<DataProvider>(context);

    return 
    Container
    (
      decoration: 
      BoxDecoration
      (
        color: Colors.lightGreenAccent,
        borderRadius: BorderRadius.all(Radius.circular(10.0))
      ),
      height: 300,
      child: 
      FutureBuilder<List<Comment>>
      (
        future: data.getComments(post.id),
        builder: (context, snapshot)
        {
          if(snapshot.hasData){
            return 
            ListView.builder
            (
              itemCount: snapshot.data.length,
              itemBuilder: (context, index){
                return
                Container
                (
                  child: 
                  Column
                  (
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>
                    [
                      Text("email: " + snapshot.data[index].email, style: TextStyle(fontWeight: FontWeight.bold )),
                      Text(snapshot.data[index].name + ":",style: TextStyle(fontWeight: FontWeight.bold )),
                      Text(snapshot.data[index].body),
                      SizedBox(height: 20,)
                    ],
                  )
                );
              },
            );
          }
          else{
            return Text("");
          }
        },
      )
    );
  }
}