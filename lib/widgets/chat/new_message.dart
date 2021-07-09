// @dart=2.9
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:souqalfurat/providers/auth.dart';

class NewMessage extends StatefulWidget {
  final String adId;
  final String userId;
  final String creatorId;
  final bool isPrivate;

   NewMessage(this.adId,this.isPrivate,this.userId,this.creatorId);
  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _controller = TextEditingController();
  String _enteredMessage = '';

  _sendMessage(userId,adId) async {
    FocusScope.of(context).unfocus();
    //final user = FirebaseAuth.instance.currentUser;
    final userData = await Firestore.instance
        .collection('users')
        .document(userId)
        .get();
    Firestore.instance.collection('chat').document(chatName).collection(chatName).add({
      'adId':widget.adId,
      'text': _enteredMessage,
      'createdAt': Timestamp.now(),
      'userName': userData['name'],
      'userId': userId,
      'user_image': userData['imageUrl']
    });
    _controller.clear();
    setState(() {
      _enteredMessage = '';
    });
    createPrivateChat(userData['name'],userId);

  }
createPrivateChat(userName,userId){
  Firestore.instance.collection('private_chats').document(chatName).collection(chatName).add({
    'chatId':chatName,
    'adId':widget.adId,
    'createdAt': Timestamp.now(),
    'userName': userName,
    'userId': userId,

  });
}
  String chatName;
  void privateOrG(userIdA){

    if(widget.isPrivate){
      print('adId ${widget.adId}');
      print('userId from messages $userIdA');
      print('crId ${widget.creatorId}');
      print('isP ${widget.isPrivate}');


      chatName=widget.adId;
      chatName = userIdA.toString()+widget.adId+widget.creatorId;
      print('chatName $chatName');
    }else{
      chatName=widget.adId;
    }
  }
  @override
  Widget build(BuildContext context) {

    final userIdG= Provider.of<Auth>(context).userId;
    privateOrG(userIdG);

    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              autocorrect: true,
              enableSuggestions: true,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                  hintText: 'Send a message',
                  hintStyle: TextStyle(color: Theme.of(context).primaryColor),
                  enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).primaryColor))),
              onChanged: (val) {
                setState(() {
                  _enteredMessage = val;
                });
              },
            ),
          ),
          IconButton(
            color: Theme.of(context).primaryColor,
            onPressed: () {
              _enteredMessage.trim().isEmpty ? null : _sendMessage(userIdG,widget.adId);
            },
            icon: Icon(Icons.send),
          )
        ],
      ),
    );
  }
}
