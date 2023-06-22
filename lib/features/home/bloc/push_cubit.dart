import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:group_chat_app/core/remote/dio_helper.dart';
import 'package:group_chat_app/features/home/bloc/push_state.dart';


class PushCubit extends Cubit<PushStates> {
  PushCubit() : super(PushInitialState());

  static PushCubit get(context) => BlocProvider.of(context);

  void pushNotification({
    required String token,
    required String title,
    required String body,
  }) {
    DioHelper.dio.post('https://fcm.googleapis.com/fcm/send', queryParameters: {
      "to": token,
      "notification": {
        "body": body,
        "title": title,
      }
    });
  }
}
