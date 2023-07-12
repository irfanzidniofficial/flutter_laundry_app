import 'package:d_button/d_button.dart';
import 'package:d_view/d_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_laundry_app/config/app_assets.dart';
import 'package:flutter_laundry_app/config/app_constants.dart';
import 'package:flutter_laundry_app/config/failure.dart';
import 'package:flutter_laundry_app/config/nav.dart';
import 'package:flutter_laundry_app/datasource/promo_datasource.dart';
import 'package:flutter_laundry_app/datasource/shop_datasource.dart';
import 'package:flutter_laundry_app/models/promo_model.dart';
import 'package:flutter_laundry_app/pages/detail_shop_page.dart';
import 'package:flutter_laundry_app/pages/search_by_city_page.dart';
import 'package:flutter_laundry_app/providers/home_provider.dart';
import 'package:flutter_laundry_app/widgets/error_background.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../config/app_colors.dart';
import '../../config/app_format.dart';
import '../../models/shop_model.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  static final edtSearch = TextEditingController();

  gotoSearchCity() {
    Nav.push(context, SearchByCityPage(query: edtSearch.text));
  }

  getPromo() {
    PromoDatasource.readLimit().then(
      (value) {
        value.fold(
          (failure) {
            switch (failure.runtimeType) {
              case ServerFailure:
                setHomePromoStatus(ref, 'Server Error');
                break;
              case NotFoundFailure:
                setHomePromoStatus(ref, 'Error Not Found');
                break;
              case ForbiddenFailure:
                setHomePromoStatus(ref, 'You don\t have access');

                break;
              case BadRequestFailure:
                setHomePromoStatus(ref, 'Bad Request');
                break;
              case UnauthorisedFailure:
                setHomePromoStatus(ref, 'Unauthorized');
                break;
              default:
                setHomePromoStatus(ref, 'Request Error');
                break;
            }
          },
          (result) {
            setHomePromoStatus(ref, 'Success');
            List data = result['data'];
            List<PromoModel> promos =
                data.map((e) => PromoModel.fromJson(e)).toList();

            ref.read(homePromoListProvider.notifier).setData(promos);
          },
        );
      },
    );
  }

  getRecommendation() {
    ShopDatasource.readRecomendationLimit().then(
      (value) {
        value.fold(
          (failure) {
            switch (failure.runtimeType) {
              case ServerFailure:
                setHomeRecomendationStatus(ref, 'Server Error');
                break;
              case NotFoundFailure:
                setHomeRecomendationStatus(ref, 'Error Not Found');
                break;
              case ForbiddenFailure:
                setHomeRecomendationStatus(ref, 'You don\t have access');

                break;
              case BadRequestFailure:
                setHomeRecomendationStatus(ref, 'Bad Request');
                break;
              case UnauthorisedFailure:
                setHomeRecomendationStatus(ref, 'Unauthorized');
                break;
              default:
                setHomeRecomendationStatus(ref, 'Request Error');
                break;
            }
          },
          (result) {
            setHomeRecomendationStatus(ref, 'Success');
            List data = result['data'];

            List<ShopModel> shops =
                data.map((e) => ShopModel.fromJson(e)).toList();
            ref.read(homeRecommendationListProvider.notifier).setData(shops);
          },
        );
      },
    );
  }

  refresh() {
    getPromo();
    getRecommendation();
  }

  @override
  void initState() {
    refresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => refresh(),
      child: ListView(
        children: [
          header(),
          categories(),
          DView.spaceHeight(20),
          promo(),
          DView.spaceHeight(20),
          recommendation(),
        ],
      ),
    );
  }

  Consumer promo() {
    final pageController = PageController();
    return Consumer(
      builder: (_, wiRef, ___) {
        List<PromoModel> list = wiRef.watch(homePromoListProvider);
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DView.textTitle(
                    "Promo",
                    color: Colors.black,
                  ),
                  DView.textAction(
                    () {},
                    color: AppColors.primary,
                  ),
                ],
              ),
            ),
            DView.spaceHeight(20),
            if (list.isEmpty) DView.empty('No Promo'),
            if (list.isNotEmpty)
              AspectRatio(
                aspectRatio: 16 / 9,
                child: PageView.builder(
                  controller: pageController,
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    PromoModel item = list[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: FadeInImage(
                                placeholder: const AssetImage(
                                  AppAssets.placeholerlaundry,
                                ),
                                image: NetworkImage(
                                  '${AppConstants.baseImageURL}/promo/${item.image}',
                                ),
                                fit: BoxFit.cover,
                                imageErrorBuilder:
                                    (context, error, stackTrace) {
                                  return const Icon(Icons.error);
                                },
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.white,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 6,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    item.shop.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                  DView.spaceHeight(4),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "${AppFormat.shortPrice(item.newPrice)} / kg",
                                        style: const TextStyle(
                                          color: Colors.green,
                                        ),
                                      ),
                                      DView.spaceWidth(),
                                      Text(
                                        "${AppFormat.shortPrice(item.oldPrice)} / kg",
                                        style: const TextStyle(
                                          color: Colors.red,
                                          decoration:
                                              TextDecoration.lineThrough,
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
            if (list.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 30,
                ),
                child: ErrorBackground(
                  ratio: 16 / 9,
                  message: 'No Promo',
                ),
              ),
            if (list.isNotEmpty)
              SmoothPageIndicator(
                controller: pageController,
                count: list.length,
                effect: WormEffect(
                  dotHeight: 4,
                  dotWidth: 12,
                  dotColor: Colors.grey[300]!,
                  activeDotColor: Colors.green,
                ),
              ),
          ],
        );
      },
    );
  }

  Consumer recommendation() {
    return Consumer(
      builder: (_, wiRef, __) {
        List<ShopModel> list = wiRef.watch(homeRecommendationListProvider);
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 0, 30, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DView.textTitle(
                    "Recommendation",
                    color: Colors.black,
                  ),
                  DView.textAction(
                    () {},
                    color: AppColors.primary,
                  ),
                ],
              ),
            ),
            if (list.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: ErrorBackground(
                  ratio: 1.2,
                  message: 'No Recommendation yet',
                ),
              ),
            if (list.isNotEmpty)
              SizedBox(
                height: 250,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    ShopModel item = list[index];
                    return GestureDetector(
                      onTap: () {
                        Nav.push(context, DetailShopPage(shop: item));
                      },
                      child: Container(
                        margin: EdgeInsets.fromLTRB(
                          index == 0 ? 30 : 10,
                          0,
                          index == list.length - 1 ? 30 : 10,
                          0,
                        ),
                        width: 200,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: FadeInImage(
                                placeholder: const AssetImage(
                                  AppAssets.placeholerlaundry,
                                ),
                                image: NetworkImage(
                                  '${AppConstants.baseImageURL}/shop/${item.image}',
                                ),
                                fit: BoxFit.cover,
                                imageErrorBuilder:
                                    (context, error, stackTrace) {
                                  return const Icon(Icons.error);
                                },
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                height: 150,
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                  ),
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.transparent,
                                      Colors.black,
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              left: 8,
                              bottom: 8,
                              right: 8,
                              child: Column(
                                children: [
                                  Row(
                                    children: ['Regular', 'Express'].map((e) {
                                      return Container(
                                        decoration: BoxDecoration(
                                          color: Colors.green.withOpacity(0.8),
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        margin: const EdgeInsets.only(right: 5),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        child: Text(
                                          e,
                                          style: const TextStyle(
                                            height: 1,
                                            color: Colors.white,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                  DView.spaceHeight(8),
                                  Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: const EdgeInsets.all(8),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.name,
                                          style: GoogleFonts.ptSans(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        ),
                                        DView.spaceHeight(8),
                                        Row(
                                          children: [
                                            RatingBar(
                                              initialRating: item.rate,
                                              itemCount: 5,
                                              allowHalfRating: true,
                                              itemPadding:
                                                  const EdgeInsets.all(0),
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
                                              '(${item.rate})',
                                              style: const TextStyle(
                                                color: Colors.black87,
                                                fontSize: 11,
                                              ),
                                            ),
                                          ],
                                        ),
                                        DView.spaceHeight(4),
                                        Text(
                                          item.location,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        );
      },
    );
  }

  Consumer categories() {
    return Consumer(
      builder: (_, wiRef, ___) {
        String categorySelected = wiRef.watch(homeCategoryProvider);
        return SizedBox(
          height: 30,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: AppConstants.homeCategories.length,
            itemBuilder: (context, index) {
              String category = AppConstants.homeCategories[index];
              return Padding(
                padding: EdgeInsets.fromLTRB(
                  index == 0 ? 30 : 8,
                  0,
                  index == AppConstants.homeCategories.length - 1 ? 30 : 8,
                  0,
                ),
                child: InkWell(
                  onTap: () {
                    setHomeCategory(ref, category);
                  },
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: categorySelected == category
                              ? Colors.green
                              : Colors.grey[400]!),
                      color: categorySelected == category
                          ? Colors.green
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    child: Text(
                      category,
                      style: TextStyle(
                        height: 1,
                        color: categorySelected == category
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Padding header() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 20, 30, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'We\'re ready',
            style: GoogleFonts.ptSans(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          DView.spaceHeight(4),
          Text(
            'to clean your clothes',
            style: GoogleFonts.ptSans(
              fontSize: 20,
              color: Colors.black54,
              fontWeight: FontWeight.w400,
            ),
          ),
          DView.spaceHeight(20),
          Column(
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.location_city,
                    color: Colors.green,
                    size: 20,
                  ),
                  DView.spaceWidth(4),
                  Text(
                    "Find by city",
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      color: Colors.grey[600],
                    ),
                  )
                ],
              ),
              DView.spaceHeight(8),
              IntrinsicHeight(
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.green[50],
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () => gotoSearchCity(),
                              icon: const Icon(
                                Icons.search,
                              ),
                            ),
                            Expanded(
                              child: TextField(
                                controller: edtSearch,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Search...",
                                ),
                                onSubmitted: (value) => gotoSearchCity(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    DView.spaceWidth(),
                    DButtonElevation(
                      onClick: () {},
                      mainColor: Colors.green,
                      splashColor: Colors.greenAccent,
                      width: 50,
                      radius: 10,
                      child: const Icon(
                        Icons.tune,
                      ),
                    ),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
