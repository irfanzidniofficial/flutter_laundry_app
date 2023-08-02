// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:d_view/d_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_laundry_app/config/app_colors.dart';
import 'package:flutter_laundry_app/config/failure.dart';
import 'package:flutter_laundry_app/config/nav.dart';
import 'package:flutter_laundry_app/datasource/shop_datasource.dart';
import 'package:flutter_laundry_app/models/shop_model.dart';
import 'package:flutter_laundry_app/pages/detail_shop_page.dart';
import 'package:flutter_laundry_app/providers/search_by_city_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchByCityPage extends ConsumerStatefulWidget {
  const SearchByCityPage({
    Key? key,
    required this.query,
  }) : super(key: key);

  final String query;

  @override
  ConsumerState<SearchByCityPage> createState() => _SearchByCityPageState();
}

class _SearchByCityPageState extends ConsumerState<SearchByCityPage> {
  final edtSearch = TextEditingController();

  execute() {
    ShopDatasource.searchByCity(edtSearch.text).then((value) {
      setSearchByCityStatus(ref, 'loading');
      value.fold(
        (failure) {
          switch (failure.runtimeType) {
            case ServerFailure:
              setSearchByCityStatus(ref, 'Server Error');
              break;
            case NotFoundFailure:
              setSearchByCityStatus(ref, 'Not Found');
              break;
            case ForbiddenFailure:
              setSearchByCityStatus(ref, 'You don\'t have access');
              break;
            case BadRequestFailure:
              setSearchByCityStatus(ref, 'Bad Request');
              break;
            case UnauthorisedFailure:
              setSearchByCityStatus(ref, 'Unauthorized');
              break;
            default:
              setSearchByCityStatus(ref, 'Request Error');
              break;
          }
        },
        (result) {
          setSearchByCityStatus(ref, 'Success');
          List data = result['data'];
          List<ShopModel> list =
              data.map((e) => ShopModel.fromJson(e)).toList();
          ref.read(searchByCityListProvider.notifier).setData(list);
        },
      );
    });
  }

  @override
  void initState() {
    if (widget.query != '') {
      edtSearch.text = widget.query;

      execute();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          height: 40,
          child: Row(
            children: [
              const Text(
                "City: ",
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 16,
                  height: 1,
                ),
              ),
              Expanded(
                child: TextField(
                  controller: edtSearch,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                  ),
                  style: const TextStyle(
                    height: 1,
                  ),
                  onSubmitted: (value) => execute(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => execute(),
            icon: const Icon(
              Icons.search,
            ),
          ),
        ],
      ),
      body: Consumer(
        builder: (_, wiRef, ___) {
          String status = wiRef.watch(searchByCityStatusProvider);
          List<ShopModel> list = wiRef.watch(searchByCityListProvider);

          if (status == '') {
            return DView.nothing();
          }
          if (status == 'Loading') return DView.loadingCircle();

          if (status == 'Success') {
            return ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                ShopModel shop = list[index];
                return ListTile(
                  onTap: () {
                    Nav.push(
                        context,
                        DetailShopPage(
                          shop: shop,
                        ));
                  },
                  leading: CircleAvatar(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    radius: 18,
                    child: Text('${index + 1}'),
                  ),
                  title: Text(shop.name),
                  subtitle: Text(shop.city),
                  trailing: const Icon(Icons.navigate_next),
                );
              },
            );
          }
          return DView.error(status);
        },
      ),
    );
  }
}
