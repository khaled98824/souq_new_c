import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:souqalfurat/providers/ads_provider.dart';
import 'package:souqalfurat/widgets/ads_items_category.dart';

class Requests extends StatefulWidget {
  static const routeName = "/requests";

  @override
  _RequestsState createState() => _RequestsState();
}

class _RequestsState extends State<Requests> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
            future: Provider.of<Products>(context,listen: false).fetchRequests(),
            builder: (ctx,data){
              if(data.connectionState ==ConnectionState.waiting){
                return  Center(child: CircularProgressIndicator());
              }else{
                return Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: CustomScrollView(
                        slivers: [
                          SliverAppBar(
                            backgroundColor: Colors.red,
                            expandedHeight: 160,
                            floating: true,
                            pinned: true,
                            flexibleSpace: FlexibleSpaceBar(
                              background: Image.network(
                                'https://firebasestorage.googleapis.com/v0/b/souq-alfurat-89023.appspot.com/o/WhatsApp%20Image%202020-09-15%20at%2011.23.35%20AM.jpeg?alt=media&token=a7c3f2d7-2629-4519-9c61-93444f989688',
                                fit: BoxFit.cover,
                              ),
                              title: Text('Requests',style: Theme.of(context).textTheme.headline4,),
                              centerTitle: true,
                            ),
                            //title: Text('My App Bar'),
                            leading: IconButton(icon: Icon(FontAwesomeIcons.arrowLeft),onPressed: (){
                              Navigator.of(context).pop();
                            },),
                            actions: [
                              //Icon(Icons.settings),
                              SizedBox(width: 12),
                            ],
                          ),
                          SliverToBoxAdapter(
                            child: GridView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: Provider.of<Products>(context,listen: false).itemsRequestsCount,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisExtent: 260,
                                mainAxisSpacing: 2,
                                crossAxisSpacing: 2,
                                childAspectRatio: 0.5,
                              ),
                              primary: false,
                              shrinkWrap: true,
                              itemBuilder: (ctx, index) =>
                                  RequestsItems(index),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );


              }
            }
        ));
  }
}

class RequestsItems extends StatelessWidget {
  final int index;
  const RequestsItems(
      this.index,
      );

  @override
  Widget build(BuildContext context) {
    String kindLike = 'request';
    return FutureBuilder(
        future: Provider.of<Products>(context, listen: false).fetchRequests(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            default:
              if (snapshot.hasError) {
                return Center(child: Text('Some error occurred!'));
              } else {
                return Consumer<Products>(
                  builder: (context, data, _) => CategoryAdsItemsCard(
                    image: data.requests[index]['imagesUrl'][1],
                    title: data.requests[index]['name'],
                    country: data.requests[index]['area'],
                    price: data.requests[index]['price'],
                    likes: data.requests[index]['likes'],
                    views: data.requests[index]['views'],
                    id: data.requests[index].documentID,
                    date: data.requests[index]['date'],
                    index: index,
                    kindLike: kindLike,
                  ),
                );
              }
          }
        });
  }
}
