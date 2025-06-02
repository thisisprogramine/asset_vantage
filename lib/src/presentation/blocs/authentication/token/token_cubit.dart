
import 'package:asset_vantage/src/core/unathorised_exception.dart';
import 'package:asset_vantage/src/domain/params/no_params.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../../../../domain/usecases/preferences/get_user_preference.dart';
import 'package:time_listener/time_listener.dart';

class TokenCubit extends Cubit<bool> {
  final GetUserPreference getUserPreference;

  TokenCubit({
    required this.getUserPreference,
  }) : super(false);

  Future<void> startTokenObserver() async{
    emit(false);

    final eitherUetUserPreference = await getUserPreference(NoParams());
    eitherUetUserPreference.fold((error) {

    }, (user) {

      if(user.user != null) {
        if(user.user?.tokenExp != null) {
          DateTime tokenExpireTime = DateTime.fromMillisecondsSinceEpoch(DateTime.now().add(const Duration(seconds: 10)).millisecondsSinceEpoch);

          final listener = TimeListener.create(interval: CheckInterval.seconds);

          listener.listen((DateTime dt) {
            if(!tokenExpireTime.isAfter(dt)) {
              emit(true);
              listener.cancel();
            }
          });
        }
      }
    });
  }

  Future<void> checkIfTokenExpired() async{
    emit(false);

    final eitherUetUserPreference = await getUserPreference(NoParams());
    eitherUetUserPreference.fold((error) {

    }, (user) {

      if(JwtDecoder.isExpired(user.idToken ?? '')) {
        emit(false);
      }

    });
  }

  Future<void> emitAsLogout() async{
    emit(false);
  }
}
