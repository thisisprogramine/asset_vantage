
import 'package:asset_vantage/src/data/models/authentication/token.dart';

import '../../../core/api_client.dart';
import '../../models/authentication/forgot_password_model.dart';


abstract class AuthenticationRemoteDataSource {
  Future<ForgotPasswordModel> forgotPassword({required String email});
  Future<Token> loginUser({required Map<String, String> params});
  Future<Token> resetPassword({required Map<String, dynamic> params});
  Future<Token> verifyOtp({required Map<String, dynamic> params});
}

class AuthenticationRemoteDataSourceImpl
    extends AuthenticationRemoteDataSource {
  final ApiClient _client;

  AuthenticationRemoteDataSourceImpl(this._client);

  @override
  Future<ForgotPasswordModel> forgotPassword({required String email}) async {
    final response = await _client.post('/api/v1/users/otp/$email',
        params: {"countryCode": '91'}
    );
    return ForgotPasswordModel.fromJson(response);
  }

  @override
  Future<Token> loginUser({required Map<String, String> params}) async {
    final response = await _client.post('login',
      body: params,
    );
    return Token.fromJson(response);
  }

  @override
  Future<Token> resetPassword(
      {required Map<String, dynamic> params}) async {
    final response = await _client.post(
      "confirm_challenge",
      body: params,
    );
    return Token.fromJson(response);
  }

  @override
  Future<Token> verifyOtp({required Map<String, dynamic> params}) async {
    final response = await _client.post(
        "confirm_challenge",
        body: params
    );
    return Token.fromJson(response);
  }
}
