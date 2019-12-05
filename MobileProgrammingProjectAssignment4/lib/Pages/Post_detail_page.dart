import 'package:all_posts/Widgets/PostCardWithCommentsWidget.dart';
import 'package:all_posts/Models/DataProvider.dart';
import 'package:all_posts/Models/Post.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:toast/toast.dart';

import 'dart:async';


class Post_detail_page extends StatelessWidget{

  final int PostID;
  Post_detail_page(this.PostID);

  double lat, lng;

  bool didSend;

  String postId,Id,Comment_name,Comment_email,Comment_body ;

  var payloadBody, payloadStatusCode, payloadResponse;
  var myCommentBody, myCommentStatusCode;


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
                        FutureBuilder<Post>
                          (
                            future: data.getPostDetail(PostID),
                            builder: (context,snapshot)
                            {
                              if(snapshot.hasData){
                                postId = snapshot.data.id.toString();
                                return
                                  ListView.builder
                                    (
                                    //load single post
                                    itemCount: 1,
                                    itemBuilder: (context,index)
                                    {
                                        return PostCardWithCommentsWidgets(snapshot.data);
                                    },
                                  );
                              }
                              else
                              {
                                return
                                  Text("Please wait...");
                              }
                            }
                        )
                    ),
              )
          ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _displayDialog(context);

          },
          child: Icon(Icons.add_comment),
          backgroundColor: Colors.black,
        ),
      );
  }


  Future postRequestHttpExample (context) async
  {
//  url specifying the postId of the post selected
    var url ='https://jsonplaceholder.typicode.com/comments?postId=$postId';

//  pull in info for comment POST
    Map data = {'name': '$Comment_name', 'email': '$Comment_email', 'body': '$Comment_body'};

    //encode Map to JSON
    var body = json.encode(data);

//    create response variable with url, heading content type, and contents of payload
    var response = await http.post(url, headers: {"Content-Type": "application/json"}, body: body);
    payloadBody = response.body;
    payloadStatusCode = response.statusCode;
    payloadResponse = response.statusCode;

    myCommentBody = json.decode(response.body.toString());
    myCommentStatusCode = json.decode(response.statusCode.toString());

//  show the StatusCode in terminal
    if(payloadStatusCode == 201) {
        didSend = true;
        print("Payload sent.");
      }

    else {
      didSend = false;
      print("Payload did not send.");
    }

//  show the https response sends in terminal
    print(myCommentStatusCode);
    print(myCommentBody);
  }

  void showToast(context) {

    if(Comment_name != null || Comment_email != null || Comment_body != null)
      {
      Toast.show("Comment Created! \n   -Comment name: " + Comment_name + "\n   -Comment email: " + Comment_email + "\n   -Comment body: " + Comment_body, context, duration: Toast.LENGTH_LONG,
          gravity: Toast.TOP);
      }
    else{
      Toast.show("Comment wasn't correctly composed. \n Please fill in all entry fields", context, duration: Toast.LENGTH_LONG,
          gravity: Toast.TOP);
    }
  }


  _displayDialog(BuildContext context)  {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Compose a comment'),
            content: new Row(
              children: <Widget>[
                new Expanded(
                    child: new Text("Post ID is: " + postId),
                ),
                new Expanded(
                    child: new TextField(
                      autofocus: true,
                      decoration: new InputDecoration(
                          labelText: 'Name', hintText: ''),
                      onChanged: (value) {
                        Comment_name = value.toString();
                      },
                    )),
                new Expanded(
                    child: new  TextField(
                    decoration: InputDecoration(
                    hintText: "email...", labelText: 'Post name'),
                      onChanged: (value) {
                        Comment_email = value.toString();
                      },
                    ),),
                new Expanded(
                    child: new TextField(
                      autofocus: true,
                      decoration: new InputDecoration(
                          labelText: 'Body', hintText: ''),
                      onChanged: (value) {
                        Comment_body = value.toString();
                      },
                    )),
              ],
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              new FlatButton(
                child: new Text('SUBMIT'),
                onPressed: ()
                {
                  postRequestHttpExample(context);
                  showToast(context); // show user comment information, couldnt find a way to save StatusCode to show user.

                  Navigator.of(context).pop(); // exit dialog
                },
              ),
            ],
          );
        });
  }
}
