import 'package:flutter/material.dart';


class ThumbnailAndTitleWidget extends StatelessWidget{

  final String postTitle;
  final String thumbnailUrl;

  ThumbnailAndTitleWidget(this.postTitle, this.thumbnailUrl);

  @override
  Widget build(BuildContext context) {

    return 
    Column
    (
      children: <Widget>
      [
        Container
        (

          width: 200,
          height: 180,
          child: 
          Column
          (
            children: <Widget>
            [
              Container
              (
                width: 100,
                height: 100,
                child: Image.network(thumbnailUrl),
              ),
              Text(postTitle, overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 15))
            ],
          )
        )
        
      ],
    );
  }
}