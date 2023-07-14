// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:d_view/d_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_laundry_app/config/app_colors.dart';
import 'package:flutter_laundry_app/config/app_constants.dart';
import 'package:flutter_laundry_app/config/app_format.dart';

import 'package:flutter_laundry_app/models/shop_model.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../config/app_assets.dart';

class DetailShopPage extends StatelessWidget {
  const DetailShopPage({
    Key? key,
    required this.shop,
  }) : super(key: key);
  final ShopModel shop;

  // launchWA(BuildContext context, String number) async {
  //   bool? yes = await DInfo.dialogConfirmation(
  //     context,
  //     'Chat via whatsapp',
  //     'Yes to confirm',
  //   );
  //   if (yes ?? false) {
  //     const link = WhatsAppUnilink(
  //       //  phoneNumber: number, // error dikarenakan data dari BE tidak valid no hpnya
  //       phoneNumber: '62085893124302',
  //       text: 'Hello, i want to order a laundry services',
  //     );
  //     if (await canLaunchUrl(link.asUri())) {
  //       launchUrl(link.asUri(), mode: LaunchMode.externalApplication);
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(0),
        children: [
          headerImage(context),
          DView.spaceHeight(10),
          groupItemInfo(context),
          DView.spaceHeight(20),
          category(),
          description(),
          DView.spaceHeight(20),
          Container(
            height: 50,
            margin: const EdgeInsets.symmetric(
              horizontal: 24,
            ),
            child: ElevatedButton(
              onPressed: () {},
              child: const Text(
                'Oder',
                style: TextStyle(
                  height: 1,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          DView.spaceHeight(20),
        ],
      ),
    );
  }

  Padding description() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DView.spaceHeight(20),
          DView.textTitle("Deskripsi", color: Colors.black87),
          DView.spaceHeight(8),
          Text(
            shop.description,
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Padding category() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DView.textTitle("Category", color: Colors.black87),
          DView.spaceHeight(8),
          Wrap(
            spacing: 5,
            children: [
              'Regular',
              'Express',
              'Economical',
              'Exclusive',
            ].map((e) {
              return Chip(
                visualDensity: const VisualDensity(vertical: -4),
                side: const BorderSide(
                  color: AppColors.primary,
                ),
                backgroundColor: Colors.white,
                label: Text(
                  e,
                  style: const TextStyle(height: 1),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Padding groupItemInfo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 26),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                itemInfo(
                  const Icon(
                    Icons.location_city_rounded,
                    color: AppColors.primary,
                    size: 20,
                  ),
                  shop.city,
                ),
                DView.spaceHeight(6),
                itemInfo(
                  const Icon(
                    Icons.location_on,
                    color: AppColors.primary,
                    size: 20,
                  ),
                  shop.location,
                ),
                DView.spaceHeight(6),
                itemInfo(
                  Image.asset(
                    AppAssets.wa,
                    width: 20,
                  ),
                  shop.whatsapp,
                ),
              ],
            ),
          ),
          DView.spaceWidth(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                AppFormat.longPrice(shop.price),
                textAlign: TextAlign.right,
                style: const TextStyle(
                  height: 1,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const Text('/kg'),
            ],
          )
        ],
      ),
    );
  }

  Widget itemInfo(Widget icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 30,
          height: 20,
          alignment: Alignment.centerLeft,
          child: icon,
        ),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 16,
            ),
          ),
        )
      ],
    );
  }

  Widget headerImage(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: AspectRatio(
        aspectRatio: 1,
        child: Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Image.network(
                "${AppConstants.baseImageURL}/shop/${shop.image}",
                fit: BoxFit.cover,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: AspectRatio(
                aspectRatio: 2.5,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: const LinearGradient(
                      colors: [
                        Colors.black,
                        Colors.transparent,
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        shop.name,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold),
                      ),
                      DView.spaceHeight(8),
                      Row(
                        children: [
                          RatingBar(
                            initialRating: shop.rate,
                            itemCount: 5,
                            allowHalfRating: true,
                            itemPadding: const EdgeInsets.all(0),
                            itemSize: 16,
                            unratedColor: Colors.grey[300],
                            ratingWidget: RatingWidget(
                              full: const Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              half: Icon(
                                Icons.star,
                                color: Colors.grey[300],
                              ),
                              empty: Icon(
                                Icons.star,
                                color: Colors.grey[300],
                              ),
                            ),
                            onRatingUpdate: (value) {},
                            ignoreGestures: true,
                          ),
                          DView.spaceWidth(4),
                          Text(
                            '(${shop.rate})',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                      shop.pickup && !shop.delivery
                          ? DView.nothing()
                          : Padding(
                              padding: const EdgeInsets.only(top: 16),
                              child: Row(
                                children: [
                                  if (shop.pickup) childOrder('Pickup'),
                                  if (shop.delivery) DView.spaceWidth(8),
                                  if (shop.delivery) childOrder('Delivery'),
                                ],
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 36,
              left: 16,
              child: SizedBox(
                height: 36,
                child: FloatingActionButton.extended(
                  heroTag: 'fab-back-button',
                  icon: const Icon(Icons.navigate_before),
                  extendedPadding: const EdgeInsets.only(
                    left: 10,
                    right: 16,
                  ),
                  extendedIconLabelSpacing: 0,
                  backgroundColor: Colors.white,
                  onPressed: () => Navigator.pop(context),
                  label: const Text('Back'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container childOrder(String name) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.green,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              height: 1,
            ),
          ),
          DView.spaceWidth(3),
          const Icon(
            Icons.check_circle,
            color: Colors.white,
            size: 14,
          )
        ],
      ),
    );
  }
}
