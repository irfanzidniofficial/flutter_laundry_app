import 'package:dartz/dartz.dart';
import 'package:flutter_laundry_app/config/app_session.dart';
import 'package:flutter_laundry_app/models/user_model.dart';
import 'package:http/http.dart' as http;
import '../config/app_constants.dart';
import '../config/app_request.dart';
import '../config/app_respone.dart';
import '../config/failure.dart';

class LaundryDatasource {
  static Future<Either<Failure, Map>> readByUser(int userId) async {
    Uri url = Uri.parse('${AppConstants.baseUrl}/laundry/user/$userId');

    final token = await AppSession.getBearerToken();
    try {
      final response = await http.get(
        url,
        headers: AppRequest.header(token),
      );
      final data = AppResponse.data(response);
      return Right(data);
    } catch (e) {
      if (e is Failure) {
        return Left(e);
      }
      return Left(FetchFailure(e.toString()));
    }
  }

  static Future<Either<Failure, Map>> claim(String id, String claimCode) async {
    Uri url = Uri.parse('${AppConstants.baseUrl}/laundry/claim');
    UserModel? user = await AppSession.getUser();

    final token = await AppSession.getBearerToken();
    try {
      final response = await http.post(
        url,
        body: {
          'id': id,
          'claim_code': claimCode,
          'user_id': user!.id.toString(),
        },
        headers: AppRequest.header(token),
      );
      final data = AppResponse.data(response);
      return Right(data);
    } catch (e) {
      if (e is Failure) {
        return Left(e);
      }
      return Left(FetchFailure(e.toString()));
    }
  }
}
