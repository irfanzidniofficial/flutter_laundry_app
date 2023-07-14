import 'package:flutter/material.dart';
import 'package:flutter_laundry_app/config/app_session.dart';
import 'package:flutter_laundry_app/datasource/laundry_datasource.dart';
import 'package:flutter_laundry_app/models/laundry_model.dart';
import 'package:flutter_laundry_app/models/user_model.dart';
import 'package:flutter_laundry_app/providers/my_laudry_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../config/failure.dart';

class MyLaundyView extends ConsumerStatefulWidget {
  const MyLaundyView({super.key});

  @override
  ConsumerState<MyLaundyView> createState() => _MyLaundyViewState();
}

class _MyLaundyViewState extends ConsumerState<MyLaundyView> {
  late UserModel user;

  getMyLaundry() {
    LaundryDatasource.readByUser(user.id).then((value) {
      value.fold(
        (failure) {
          switch (failure.runtimeType) {
            case ServerFailure:
              setMyLaundryStatus(ref, 'Server Error');
              break;
            case NotFoundFailure:
              setMyLaundryStatus(ref, 'Error Not Found');
              break;
            case ForbiddenFailure:
              setMyLaundryStatus(ref, 'You don\t have access');

              break;
            case BadRequestFailure:
              setMyLaundryStatus(ref, 'Bad Request');
              break;
            case UnauthorisedFailure:
              setMyLaundryStatus(ref, 'Unauthorized');
              break;
            default:
              setMyLaundryStatus(ref, 'Request Error');
              break;
          }
        },
        (result) {
          setMyLaundryStatus(ref, 'Success');
          List data = result['data'];
          List<LaundryModel> laundries =
              data.map((e) => LaundryModel.fromJson(e)).toList();
          ref.read(myLaundryListProvider.notifier).setData(laundries);
        },
      );
    });
  }

  dialogClaim() {}

  @override
  void initState() {
    AppSession.getUser().then((value) {
      user = value!;
    });
    getMyLaundry();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 60, 30, 20),
              child: Row(
                children: [
                  Text(
                    "My Laundry",
                    style: GoogleFonts.montserrat(
                      fontSize: 24,
                      color: Colors.green,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  OutlinedButton.icon(
                    onPressed: () => dialogClaim(),
                    label: const Text(
                      "Claim",
                      style: TextStyle(
                        height: 1,
                      ),
                    ),
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
            ),
          ],
        )
      ],
    );
  }
}
