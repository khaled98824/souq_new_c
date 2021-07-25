// @dart=2.9
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:souqalfurat/providers/ads_provider.dart';
import 'package:souqalfurat/providers/auth.dart';
import 'package:souqalfurat/screens/add_new_ad.dart';
import 'package:souqalfurat/screens/show_ad.dart';

class MyAds extends StatefulWidget {
  static const routeName = "/my_ads";

  @override
  _MyAdsState createState() => _MyAdsState();
}

class _MyAdsState extends State<MyAds> {
  @override
  Widget build(BuildContext context) {
    final userId = Provider.of<Auth>(context, listen: false).userId;
    final myAds = Provider.of<Products>(context, listen: false).myAds;
    return Scaffold(
      appBar: AppBar(
        title: Text('إعلاناتي'),
        centerTitle: true,
      ),
      body: FutureBuilder(
          future:
              Provider.of<Products>(context, listen: false).fetchMyAds(userId),
          builder: (context, data) {
            if (data.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              return Consumer<Products>(
                  builder: (context, data, _) => ListView.separated(
                      itemCount: data.myAds.length,
                      separatorBuilder: (context, index) => Divider(
                            thickness: 2,
                            color: Colors.deepOrange,
                          ),
                      itemBuilder: (context, index) => InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ShowAd(
                                            adId: data.myAds[index].documentID,
                                            indexAd: index,
                                          )));
                            },
                            child: Dismissible(
                              key: Key(data.myAds[index].documentID),
                              onDismissed: (dir) {
                                showSnackBar(data.myAds[index].documentID);
                              },
                              background: Container(
                                alignment: Alignment.centerRight,
                                color: Colors.red,
                                child: Icon(
                                  FontAwesomeIcons.trash,
                                  color: Colors.white,
                                ),
                              ),
                              child: Card(
                                child: ListTile(
                                    title: Text(data.myAds[index]['date']),
                                    leading: Text(data.myAds[index]['name']),
                                    trailing: IconButton(
                                      icon: Icon(FontAwesomeIcons.edit,color: Colors.green,),
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => AddNewAd(
                                                    context,
                                                    data.myAds[index]
                                                        .documentID,
                                                    true)));
                                      },
                                    )),
                              ),
                            ),
                          )));
            }
          }),
    );
  }

  showSnackBar(String adId) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Delete Ad'),
        action: SnackBarAction(
          label: 'Confirm delete',
          onPressed: () {
            deleteUndo();
           Provider.of<Products>(context,listen: false).deleteAd(adId);
            deleteUndo();
          },
        ),
      ),
    );
  }

  void deleteUndo() {
    setState(() {});
  }

}
