// @dart=2.9

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:souqalfurat/providers/auth.dart';

import 'message_bubble.dart';

class Messages extends StatelessWidget {
  final String adId;
  final String userId;
  final String creatorId;
  final bool isPrivate;


   Messages( this.adId,this.isPrivate,this.userId,this.creatorId) ;
  String chatName;
  void privateOrG(userIdA){

    if(isPrivate){
      print('adId $adId');
      print('userId from messages $userIdA');
      print('crId $creatorId');
      print('isP $isPrivate');


      chatName=adId;
      chatName = userIdA.toString()+adId+creatorId;
      print('chatName $chatName');
    }else{
      chatName=adId;
    }
  }
  @override
  Widget build(BuildContext context) {

    final userIdA= Provider.of<Auth>(context,listen: false).userId;
    privateOrG(userIdA);
    return StreamBuilder(
      stream: Firestore.instance
          .collection('chat').document(chatName).collection(chatName)
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (ctx,AsyncSnapshot<QuerySnapshot> snapShot) {
        if (snapShot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        final docs = snapShot.data;
        return ListView.builder(
            reverse: true,
            shrinkWrap: true,
            itemCount:docs.documents.length,
            itemBuilder: (ctx, index) => MessageBubble(
                  docs.documents[index]['text'],
                  docs.documents[index]['userId'] == userId,
                  docs.documents[index]['userName'],
              docs.documents[index]['user_image'],
              key: ValueKey(
                    docs.documents[index]['text'] + docs.documents[index]['userName'],
                  ),

                ));
      },
    );
  }
}
