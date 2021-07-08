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

  const Messages( this.adId) ;
  @override
  Widget build(BuildContext context) {
    final userId= Provider.of<Auth>(context).userId;
    return StreamBuilder(
      stream: Firestore.instance
          .collection('chat').document(adId).collection(adId)
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (ctx,AsyncSnapshot<QuerySnapshot> snapShot) {
        if (snapShot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        final docs = snapShot.data;
        //final user = FirebaseAuth.instance.currentUser;
        return ListView.builder(
            reverse: true,
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
