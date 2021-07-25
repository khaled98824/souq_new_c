// @dart=2.9

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:souqalfurat/providers/ads_provider.dart';
import 'package:souqalfurat/providers/auth.dart';
import 'package:souqalfurat/providers/full_provider.dart';
import 'package:souqalfurat/screens/requests.dart';
import 'package:souqalfurat/widgets/bottomNavBar.dart';
import 'package:souqalfurat/widgets/head.dart';
import 'package:souqalfurat/widgets/new_Ads.dart';
import 'package:souqalfurat/widgets/searchArea.dart';
import 'ads_of_category.dart';
import 'constants.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = "/home";

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> _listItem = [
    'assets/images/Elct2.jpg',
    'assets/images/cars.jpg',
    'assets/images/mobile3.jpg',
    'assets/images/jobs3.jpg',
    'assets/images/SERV3.jpg',
    'assets/images/home3.jpg',
    'assets/images/trucks3.jpg',
    'assets/images/farm7.jpg',
    'assets/images/farming3.jpg',
    'assets/images/game.jpg',
    'assets/images/clothes.jpg',
    'assets/images/food.jpg',
    'assets/images/requests.jpg'
  ];

  var adImagesUrlF = [];
  bool adsOrCategory = false;
  ScrollController controller;
  bool bottomIsVisible = true;

  getUrlsForAds() async {
    DocumentSnapshot documentsAds;
    bool showSliderAds = false;

    DocumentReference documentRef = Firestore.instance
        .collection('UrlsForAds')
        .document('gocqpQlhow2tfetqlGpP');
    documentsAds = await documentRef.get();
    adImagesUrlF = documentsAds.data['urls'];
    return adImagesUrlF;
  }
  String subtitle = '';
  String content = '';
  String data = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = ScrollController();
    controller.addListener(listenBottom);
    Provider.of<Auth>(context, listen: false).gitCurrentUserInfo();

    //noti
    OneSignal.shared
        .setNotificationReceivedHandler((OSNotification notification) {
      setState(() {
        subtitle = notification.payload.subtitle;
        content = notification.payload.body;
        data = notification.payload.additionalData['data'];
        print(subtitle);
      });
    });

    OneSignal.shared
        .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      print('Notification Opened');
    });

    OneSignal.shared.getPermissionSubscriptionState().then((state) {
      DocumentReference ref = Firestore.instance
          .collection('users')
          .document(Provider.of<Auth>(context,listen: false).userId);

      ref.updateData({
        'osUserID': '${state.subscriptionStatus.userId}',
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // controller.removeListener(listenBottom);
    controller.dispose();
  }

  void listenBottom() {
    //final direction = controller.position.userScrollDirection;
    if (controller.position.pixels >= 200) {
      hideBottom();
    } else {
      showBottom();
    }
  }

  void showBottom() {
    if (!bottomIsVisible) setState(() => bottomIsVisible = true);
  }

  void hideBottom() {
    if (bottomIsVisible) setState(() => bottomIsVisible = false);
  }

  @override
  Widget build(BuildContext context) {
    final screenSizeWidth = MediaQuery.of(context).size.width;
    final getAllData =
        Provider.of<Products>(context, listen: false).fetchNewAds(false);
    final fullDataP = Provider.of<FullDataProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          controller: controller,
          child: Column(
            children: [
              head(screenSizeWidth),
              SizedBox(
                height: 4,
              ),
              SearchAreaDesign(),
              SizedBox(
                height: 12,
              ),
              Container(
                height: 32,
                width: MediaQuery.of(context).size.width - 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Colors.grey[300]),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, Requests.routeName);
                      },
                      child: Container(
                        child: Row(
                          children: [
                            Text('الطلبات',
                                style: Theme.of(context).textTheme.headline5),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Colors.grey[400]),
                      height: 30,
                      width: 1,
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          adsOrCategory = true;
                        });
                      },
                      child: Container(
                          child: Row(
                        children: [
                          Text('الإعلانات',
                              style: Theme.of(context).textTheme.headline5)
                        ],
                      )),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Colors.grey[400]),
                      height: 30,
                      width: 1,
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          adsOrCategory = false;
                        });
                      },
                      child: Container(
                          child: Row(
                        children: [
                          Text('الأقسام',
                              style: Theme.of(context).textTheme.headline5)
                        ],
                      )),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 6,
              ),
              Consumer<FullDataProvider>(
                  builder: (context, data, _) => FutureBuilder(
                      future: fullDataP.getUrlsForAds(),
                      builder: (context, data) =>
                          data.connectionState == ConnectionState.waiting
                              ? CircularProgressIndicator()
                              : Container(
                                  width: screenSizeWidth - 10,
                                  height: 85,
                                  child: new Swiper(
                                    itemBuilder: (ctx, int index) {
                                      return InkWell(
                                        onTap: () {},
                                        child: Hero(
                                            tag: Text('imageAd'),
                                            child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(3),
                                                child: Image.network(
                                                  data.data[index],
                                                  fit: BoxFit.fill,
                                                  // height: 75,
                                                  // width: 390,
                                                ))),
                                      );
                                    },
                                    scrollDirection: Axis.horizontal,
                                    itemCount: fullDataP.adImagesUrlF.length,
                                    itemWidth: screenSizeWidth - 10,
                                    itemHeight: 99.0,
                                    duration: 2000,
                                    autoplayDelay: 13000,
                                    autoplay: true,
                                    // pagination: new SwiperPagination(
                                    //   alignment: Alignment.centerRight,
                                    // ),
                                    control: new SwiperControl(
                                      size: 18,
                                    ),
                                  ),
                                ))),
              SizedBox(
                height: 10,
              ),
              adsOrCategory
                  ? Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height,
                          child: CustomScrollView(
                            slivers: [
                              buildAds(context),
                            ],
                          ),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            alignment: WrapAlignment.spaceAround,
                            children: <Widget>[
                              ItemCategory(
                                text: "أجهزة - إلكترونيات",
                                imagePath: _listItem[0],
                                callback: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              AdsOfCategory("أجهزة - إلكترونيات")));
                                },
                                screenSizeWidth2: screenSizeWidth,
                              ),
                              ItemCategory(
                                text: "السيارات - الدراجات",
                                imagePath: _listItem[1],
                                callback: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              AdsOfCategory("السيارات - الدراجات")));
                                },
                                screenSizeWidth2: screenSizeWidth,
                              )
                            ]),
                        Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            alignment: WrapAlignment.spaceAround,
                            children: <Widget>[
                              ItemCategory(
                                text: "الموبايل",
                                imagePath: _listItem[2],
                                callback: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              AdsOfCategory("الموبايل")));
                                },
                                screenSizeWidth2: screenSizeWidth,
                              ),
                              ItemCategory(
                                text: "وظائف وأعمال",
                                imagePath: _listItem[3],
                                callback: () {Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            AdsOfCategory("وظائف وأعمال")));},
                                screenSizeWidth2: screenSizeWidth,
                              )
                            ]),
                        Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            alignment: WrapAlignment.spaceAround,
                            children: <Widget>[
                              ItemCategory(
                                text: "مهن وخدمات",
                                imagePath: _listItem[4],
                                callback: () {Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            AdsOfCategory("مهن وخدمات")));},
                                screenSizeWidth2: screenSizeWidth,
                              ),
                              ItemCategory(
                                text: "المنزل",
                                imagePath: _listItem[5],
                                callback: () {Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            AdsOfCategory("المنزل")));},
                                screenSizeWidth2: screenSizeWidth,
                              )
                            ]),
                        Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            alignment: WrapAlignment.spaceAround,
                            children: <Widget>[
                              ItemCategory(
                                text: "المعدات والشاحنات",
                                imagePath: _listItem[6],
                                callback: () {Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            AdsOfCategory("المعدات والشاحنات")));},
                                screenSizeWidth2: screenSizeWidth,
                              ),
                              ItemCategory(
                                text: "المواشي",
                                imagePath: _listItem[7],
                                callback: () {Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            AdsOfCategory("المواشي")));},
                                screenSizeWidth2: screenSizeWidth,
                              )
                            ]),
                        Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            alignment: WrapAlignment.spaceAround,
                            children: <Widget>[
                              ItemCategory(
                                text: "الزراعة",
                                imagePath: _listItem[8],
                                callback: () {Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            AdsOfCategory("الزراعة")));},
                                screenSizeWidth2: screenSizeWidth,
                              ),
                              ItemCategory(
                                text: "ألعاب",
                                imagePath: _listItem[9],
                                callback: () {Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            AdsOfCategory("ألعاب")));},
                                screenSizeWidth2: screenSizeWidth,
                              )
                            ]),
                        Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            alignment: WrapAlignment.spaceAround,
                            children: <Widget>[
                              ItemCategory(
                                text: "ألبسة",
                                imagePath: _listItem[10],
                                callback: () {Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            AdsOfCategory("ألبسة")));},
                                screenSizeWidth2: screenSizeWidth,
                              ),
                              ItemCategory(
                                text: "أطعمة",
                                imagePath: _listItem[11],
                                callback: () {Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            AdsOfCategory("أطعمة")));},
                                screenSizeWidth2: screenSizeWidth,
                              )
                            ]),
                        Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            alignment: WrapAlignment.spaceAround,
                            children: <Widget>[
                              ItemCategory(
                                text: "طلبات المستخدمين",
                                imagePath: _listItem[12],
                                callback: () {Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            AdsOfCategory("طلبات المستخدمين")));},
                                screenSizeWidth2: screenSizeWidth,
                              ),
                            ]),
                      ],
                    )
            ],
          ),
        ),
      ),
      bottomNavigationBar: AnimatedContainer(
          duration: Duration(milliseconds: 500),
          height: bottomIsVisible ? 66 : 0,
          child: BottomNavB())
    );
  }


}

class ItemCategory extends StatelessWidget {
  final String text;
  final VoidCallback callback;
  final String imagePath;
  final double screenSizeWidth2;

  ItemCategory({
    this.text,
    this.callback,
    this.imagePath,
    this.screenSizeWidth2,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: callback,
      child: Card(
        elevation: 0,
        child: SizedBox(
          width: screenSizeWidth2 > 395 ? 190 : 172,
          height: 170,
          child: Container(
            width: 100,
            //width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              image: DecorationImage(
                  image: AssetImage(imagePath), fit: BoxFit.fill),
              color: Colors.redAccent,
            ),
            child: Transform.translate(
                offset: Offset(11, -68),
                child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 13, vertical: 71),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.grey[100]),
                    child: Center(
                      child: Text(text,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headline3),
                    ))),
          ),
        ),
      ),
    );
  }
}
