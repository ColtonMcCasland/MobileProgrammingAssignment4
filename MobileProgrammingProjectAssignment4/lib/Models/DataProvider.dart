import 'dart:core';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:all_posts/Models/Post.dart';
import 'package:all_posts/Models/User.dart';
import 'package:all_posts/Models/Comment.dart';
import 'package:http/http.dart' as http;


class DataProvider with ChangeNotifier {

  List<Comment> listOfPostComments = List<Comment>();
  List<Post> currentPosts = List();
  List<Post> nextPosts = List();


  Future<http.Response> makeAPICall(String url) async{

    final response = await http.get(url);
    
    return response;
  }


//  get user information for PostCard
  Future<User> getUser(int userID) async {
    User user;

    var response = await makeAPICall("https://jsonplaceholder.typicode.com/users?id=$userID");

    if (response.statusCode == 200)
    {
      return user = User.fromJson(json.decode(response.body)[0]);
    } 
    else 
    {
      throw Exception("Failed To Load");
    }
  }

  //    get all posts on jsonplaceholder
  Future<List<Post>> getPosts() async {

    var response = await makeAPICall("https://jsonplaceholder.typicode.com/posts");

    Map<String, String> headers = response.headers;
    String linkHeader= headers['link'];

    if (response.statusCode == 200) {

      currentPosts = (json.decode(response.body) as List)
          .map((data) => Post.fromJson(data))
          .toList();

      notifyListeners();
      return currentPosts;
    }
    else {
      throw Exception("Failed To Load");
    }
  }

// get comments related to a particular post
  Future<List<Comment>> getComments(int postID) async {

    var response = await makeAPICall("https://jsonplaceholder.typicode.com/comments?postId=$postID");

    if (response.statusCode == 200) {

      listOfPostComments = (json.decode(response.body) as List)
          .map((data) => Comment.fromJson(data))
          .toList();

      return listOfPostComments;
    }
    else{

      throw Exception("Failed To Load");
    }
  }


//  get posts related to a user via userId
  Future<List<Post>> getPostsByUser(int userID) async {

    var response = await makeAPICall("https://jsonplaceholder.typicode.com/posts?_page=$userID");

    Map<String, String> headers = response.headers;
    String linkHeader= headers['link'];

    if (response.statusCode == 200) {

      currentPosts = (json.decode(response.body) as List).map((data) => Post.fromJson(data)).toList();

      notifyListeners();
      return currentPosts;
    }
    else {
      throw Exception("Failed To Load");
    }

  }

//  get posts by a specific id
  Future<Post> getPostDetail(int postID) async {

    var response = await makeAPICall("https://jsonplaceholder.typicode.com/posts?id=$postID");
      Post post;


      if (response.statusCode == 200) {
        return post = Post.fromJson(json.decode(response.body)[0]);
      }
      else
      {
        throw Exception("Failed To Load");
      }

    }


}
