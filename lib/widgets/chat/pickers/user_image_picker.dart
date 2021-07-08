// @dart=2.9
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  final void Function(File pickedImage) imagePickFn;

   UserImagePicker( this.imagePickFn) ;
  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  String imageUrl;
  File _pickedImage;
  final ImagePicker _picker = ImagePicker();

  void _pickImage(ImageSource src) async {
    final pickedImageFile = await _picker.getImage(source: src,imageQuality: 50,maxWidth: 150,maxHeight: 150);

    if (pickedImageFile != null) {

      setState(() {
        _pickedImage = File(pickedImageFile.path);
      });
      widget.imagePickFn(_pickedImage);



    }else{
      print('no image selected');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CircleAvatar(radius: 40,
        backgroundColor: Colors.grey,
          backgroundImage: _pickedImage != null ?FileImage(_pickedImage):null,

        ),
        SizedBox(height: 10,),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // FlatButton.icon(onPressed: ()=>_pickImage(ImageSource.camera),
            //     textColor: Theme.of(context).primaryColor,
            //     icon: Icon(Icons.photo_camera_back_outlined,size: 20,),
            //   label: Text('Add Image \nFrom Camera',textAlign: TextAlign.center,style: TextStyle(fontSize: 14),),
            // ),
            FlatButton.icon(onPressed: ()=>_pickImage(ImageSource.gallery),
              textColor: Theme.of(context).primaryColor,
              icon: Icon(Icons.image_outlined,size: 33,),
              label: Text('Add Image \nFrom Gallery',textAlign: TextAlign.center,style: TextStyle(fontSize: 14),),
            ),

          ],
        )
      ],
    );
  }
}
