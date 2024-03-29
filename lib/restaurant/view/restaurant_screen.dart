import 'package:codefactory_flutte_project/common/const/data.dart';
import 'package:codefactory_flutte_project/common/const/sizes.dart';
import 'package:codefactory_flutte_project/restaurant/component/restaurant_card.dart';
import 'package:codefactory_flutte_project/restaurant/model/restaurant_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class RestaurantScreen extends StatelessWidget {
  const RestaurantScreen({super.key});

  Future<List> paginateRestaurant() async {
    final dio = Dio();

    final accessToken = await stroage.read(key: ACCESS_TOKEN_KYE);

    final resp = await dio.get(
      'http://$ip/restaurant',
      options: Options(
        headers: {'authorization': 'Bearer $accessToken'},
      ),
    );
    return resp.data['data'];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: FutureBuilder<List>(
            future: paginateRestaurant(),
            builder: (context, AsyncSnapshot<List> snapshot) {
              if (!snapshot.hasData) {
                return Container();
              }

              return ListView.separated(
                  itemBuilder: (_, index) {
                    final item = snapshot.data![index];
                    final paesdItem = RestaurantModel.fromJson(json: item);
                    return RestaurantCard(
                      image: Image.network(
                        'http://$ip${paesdItem.thumbUrl}',
                        fit: BoxFit.cover,
                      ),
                      name: paesdItem.name,
                      tags: List<String>.from(
                          item['tags']), //Lsit<dynamic> 을 List<String> 으로 변경
                      ratingsCount: paesdItem.ratingsCount,
                      deliveryTime: paesdItem.deliveryTime,
                      deliveryFee: paesdItem.deliveryFee,
                      ratings: paesdItem.ratings,
                    );
                  },
                  separatorBuilder: (_, index) {
                    return const SizedBox(
                      height: Sizes.size16,
                    );
                  },
                  itemCount: snapshot.data!.length);
            },
          ),
        ),
      ),
    );
  }
}
