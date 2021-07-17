// @dart=2.9
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:souqalfurat/providers/ads_provider.dart';
import 'package:souqalfurat/providers/auth.dart';
import 'package:souqalfurat/screens/show_ad.dart';

class MyAds extends StatefulWidget {
  static const routeName = "/my_ads";

  @override
  _MyAdsState createState() => _MyAdsState();
}

class _MyAdsState extends State<MyAds> {
  @override
  Widget build(BuildContext context) {
    final userId = Provider.of<Auth>(context,listen: false).userId;
    final myAds = Provider.of<Products>(context,listen: false).myAds;
    return Scaffold(
      appBar: AppBar(title: Text('إعلاناتي'),centerTitle:true ,),
      body:  FutureBuilder(
          future:Provider.of<Products>(context,listen: false).fetchMyAds(userId),
          builder: (context, data) {
            if (data.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              return Consumer<Products>(builder: (context,data,_)=>ListView.builder(
                  itemCount:data.myAds.length,
                  itemBuilder: (context, index) => InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ShowAd(adId: data.myAds[index].documentID,indexAd: index,)));
                    },
                    child: Card(
                      child: ListTile(
                        title:Text(data.myAds[index]['date']),
                        leading:   Text(data.myAds[index]['name']),
                        trailing:Text(
                          data.myAds[index]['area'],
                          overflow: TextOverflow.clip,
                          softWrap: true,
                        ),
                      ),
                    ),
                  )));
            }
          }),
    );
  }
}
