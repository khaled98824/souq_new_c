// @dart=2.9

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:souqalfurat/models/chats_model.dart';

class ChatsProvider with ChangeNotifier{
List<ChatsModel> listChats ;
bool isCreate;

Future<List<DocumentSnapshot>> futureChats(adId,userId,chatName,userName,creatorId) async{
  QuerySnapshot querySnapshot= await Firestore.instance.collection("private_chats").getDocuments();
  final List<DocumentSnapshot> snap = querySnapshot.documents.where((DocumentSnapshot documentSnapshot) => documentSnapshot['adId'] == adId && documentSnapshot['userId'] ==userId).toList();
 if(snap.isNotEmpty){
   print('snap= ${snap[0]['userName']}');
   isCreate =true;
   print(isCreate);
 }else{
   print('save chat');
   isCreate =false;
   Firestore.instance.collection('private_chats').add({
     'chatId':chatName,
     'adId':adId,
     'creatorAdId':creatorId,
     'createdAt': Timestamp.now(),
     'userName': userName,
     'userId': userId,

   });
 }

  return snap;
}
notifyListeners();

}