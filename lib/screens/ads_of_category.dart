import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:souqalfurat/providers/ads_provider.dart';
import 'package:souqalfurat/widgets/ads_items_category.dart';

class AdsOfCategory extends StatefulWidget {
  static const routeName = "/ads-0f-category";
  final String categoryName;


  const AdsOfCategory( this.categoryName);
  @override
  _AdsOfCategoryState createState() => _AdsOfCategoryState();
}

class _AdsOfCategoryState extends State<AdsOfCategory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
          future: Provider.of<Products>(context,listen: false).fetchCategoryAds(widget.categoryName),
          builder: (context,data){
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
                          expandedHeight: 200,
                          floating: true,
                          pinned: true,
                          flexibleSpace: FlexibleSpaceBar(
                            background: Image.network(
                              'https://source.unsplash.com/random?monochromatic+dark',
                              fit: BoxFit.cover,
                            ),
                            title: Text('Flexible Title'),
                            centerTitle: true,
                          ),
                          //title: Text('My App Bar'),
                          leading: Icon(Icons.arrow_back),
                          actions: [
                            Icon(Icons.settings),
                            SizedBox(width: 12),
                          ],
                        ),
                        SliverToBoxAdapter(
                          child: GridView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: Provider.of<Products>(context,listen: false).itemsCategoryCount,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisExtent: 260,
                              mainAxisSpacing: 2,
                              crossAxisSpacing: 2,
                              childAspectRatio: 0.5,
                            ),
                            primary: false,
                            shrinkWrap: true,
                            itemBuilder: (context, index) =>
                                AdsOfCategoryItems(index,widget.categoryName),
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

class AdsOfCategoryItems extends StatelessWidget {
  final int index;
  final String category;
  const AdsOfCategoryItems(
    this.index,this.category
  );

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Provider.of<Products>(context, listen: false).fetchCategoryAds(category),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            default:
              if (snapshot.hasError) {
                return Center(child: Text('Some error occurred!'));
              } else {
                return Consumer<Products>(
                  builder: (context, data, _) => CategoryAdsItems(
                    image: data.itemsCategory[index]['imagesUrl'][1],
                    title: data.itemsCategory[index]['name'],
                    country: data.itemsCategory[index]['area'],
                    price: data.itemsCategory[index]['price'],
                    likes: data.itemsCategory[index]['likes'],
                    views: data.itemsCategory[index]['views'],
                    id: data.itemsCategory[index].documentID,
                    date: data.itemsCategory[index]['date'],
                    index: index,
                  ),
                );
              }
          }
        });
  }
}
