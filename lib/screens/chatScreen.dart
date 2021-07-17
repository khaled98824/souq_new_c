// @dart=2.9
import 'package:provider/provider.dart';
import 'package:souqalfurat/providers/chats_provider.dart';

import '../widgets/chat/messages.dart';
import '../widgets/chat/new_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String adId;
  final String userId;
  final String creatorId;
  final String adName;
  final bool isPrivate;
  final String chatId;


  const ChatScreen( this.adId,this.isPrivate,this.userId,this.creatorId,this.adName,this.chatId) ;
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.adName);
    print(widget.userId);
    print(widget.creatorId);
    print(widget.adId);
    print(widget.isPrivate);

    // final fbm = FirebaseMessaging();
    // fbm.requestNotificationPermissions();
    // fbm.configure(
    //   onMessage: (msg){
    //     print(msg);
    //     return;
    //   },
    //   onLaunch: (msg){
    //     print(msg);
    //     return;
    // },
    //   onResume: (msg){
    //     print(msg);
    //       return;
    //   }
    // );

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Screen'),
        actions: [
          DropdownButton(
            underline: Container(),
              icon: Icon(
                Icons.more_vert,
                color: Theme.of(context).primaryIconTheme.color,
              ),
              items: [
                DropdownMenuItem(
                  child: Row(
                    children: [
                      Icon(Icons.exit_to_app),
                      SizedBox(
                        width: 7,
                      ),
                      Text('Log Out'),
                    ],
                  ),
                  value: 'logout',
                ),
              ],
          onChanged: (itemId){
                if(itemId=='logout'){
                  FirebaseAuth.instance.signOut();
                }
          },),
        ],
      ),
      body:Container(
        child: Column(
          children: [
            Expanded(child: Messages(widget.adId,widget.isPrivate,widget.userId,widget.creatorId,widget.chatId)),
            NewMessage(widget.adId,widget.isPrivate,widget.userId,widget.creatorId,widget.adName,widget.chatId),
          ],
        ),
      ),

    );
  }
}
