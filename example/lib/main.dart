import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';
import 'package:flutter_image_gallery/flutter_image_gallery.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  Stream<List<dynamic>> loadImageList() async* {
    Map<dynamic, dynamic> _imageList;
    List _galleryImagesList = [];

    _imageList = await FlutterImageGallery.getAllImages;

    _galleryImagesList = _imageList['URIList'] as List;

    yield _galleryImagesList;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal[900],
          centerTitle: true,
          brightness: Brightness.dark,
          title: const Text(
            'IMAGE GALLERY',
            style: TextStyle(
              fontSize: 15,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        body: _buildGrid(context),
      ),
    );
  }

  Widget _buildGrid(BuildContext context) {
    return Container(
      width: 360,
      height: 700,
      padding: EdgeInsets.symmetric(
        horizontal: 5,
        vertical: 5,
      ),
      child: StreamBuilder(
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.hasError || snapshot == null) {
            return Container(
              width: 0,
              height: 0,
            );
          } else {
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemBuilder: (BuildContext context, int gridIndex) {
                return Container(
                  alignment: Alignment.center,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                      5,
                    ),
                    child: Image.file(
                      File(
                        snapshot.data[gridIndex].toString(),
                      ),
                      color: Colors.transparent,
                      colorBlendMode: BlendMode.darken,
                      width: 115,
                      height: 115,
                      cacheHeight: 115,
                      cacheWidth: 115,
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
              itemCount: snapshot.data.length,
            );
          }
        },
        stream: loadImageList(),
      ),
    );
  }
}
