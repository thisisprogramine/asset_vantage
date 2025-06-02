
import '../../../core/api_client.dart';

abstract class AppRemoteDataSource {

}

class AppRemoteDataSourceImpl extends AppRemoteDataSource {
  final ApiClient _client;

  AppRemoteDataSourceImpl(this._client);



}