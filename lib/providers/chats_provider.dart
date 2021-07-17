// @dart=2.9

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:souqalfurat/models/chats_model.dart';

class ChatsProvider with ChangeNotifier {
  List<DocumentSnapshot> listChats;

  bool isCreate;

  Future<List<DocumentSnapshot>> futureChats(
      adId, userId, chatName, userName, creatorId, adName) async {
    QuerySnapshot querySnapshot =
        await Firestore.instance.collection("private_chats").getDocuments();
    final List<DocumentSnapshot> snap = querySnapshot.documents
        .where((DocumentSnapshot documentSnapshot) =>
            documentSnapshot['adId'] == adId ||
            documentSnapshot['creatorChatId'] == userId)
        .toList();
    if (snap.isNotEmpty) {
      print('snap= ${snap[0]['userName']}');
      isCreate = true;
      print(isCreate);
    } else {
      print('save chat');
      isCreate = false;
      Firestore.instance.collection('private_chats').add({
        'chatId': chatName,
        'adId': adId,
        'adName': adName,
        'creatorAdId': creatorId,
        'chatDate': DateFormat('yyyy-MM-dd-HH:mm').format(DateTime.now()),
        'createdAt': Timestamp.now(),
        'creatorChatName': userName,
        'creatorChatId': userId,
      });
    }
    notifyListeners();
    return snap;
  }

//fetch my chats
  Future<List<DocumentSnapshot>> fetchMyChats(
      [adId, userId, chatName, userName, creatorId]) async {
    QuerySnapshot querySnapshot =
        await Firestore.instance.collection("private_chats").getDocuments();
    final List<DocumentSnapshot> snap = querySnapshot.documents
        .where((DocumentSnapshot documentSnapshot) =>
            documentSnapshot['creatorAdId'] == userId ||documentSnapshot['creatorChatId'] == userId)
        .toList();
    listChats =snap;
    notifyListeners();
    return snap;
  }

  notifyListeners();
}
