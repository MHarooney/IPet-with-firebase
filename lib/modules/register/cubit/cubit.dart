import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ipet/models/user_model.dart';
import 'package:ipet/modules/register/cubit/states.dart';

class AppRegisterCubit extends Cubit<AppRegisterStates> {
  AppRegisterCubit() : super(AppRegisterInitialState());

  static AppRegisterCubit get(context) => BlocProvider.of(context);

  void userRegister({
    @required String name,
    @required String email,
    @required String password,
    @required String phone,
  }) {
    emit(AppRegisterLoadingState());

    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: email,
      password: password,
    )
        .then((value) {
      // print(value.user.email);
      // print(value.user.uid);
      userCreate(
        name: name,
        email: email,
        phone: phone,
        uId: value.user.uid,
      );
      // emit(AppRegisterSuccessState());
    }).catchError((error) {
      emit(AppRegisterErrorState(error.toString()));
    });
  }

  void userCreate({
    @required String name,
    @required String email,
    @required String phone,
    @required String uId,
  }) {
    UserModel model = UserModel(
      name: name,
      email: email,
      phone: phone,
      uId: uId,
      bio: 'write you bio ...',
      image: 'https://firebasestorage.googleapis.com/v0/b/ipet-8ada8.appspot.com/o/ipet_paw_img.png?alt=media&token=cd86729c-0fae-4cd8-a95d-a9d243f1f9f6',
      cover: 'https://img.freepik.com/free-vector/character-illustration-people-holding-user-account-icons_53876-43022.jpg?size=338&ext=jpg',
      isEmailVerified: false,
    );

    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .set(model.toMap())
        .then((value) {
      emit(
        AppCreateUserSuccessState(),
      );
    }).catchError((error) {
      emit(
        AppCreateUserErrorState(
          error.toString(),
        ),
      );
    });
  }

  IconData suffix = Icons.visibility_outlined;
  bool isPassword = true;

  void changePasswordVisibility() {
    isPassword = !isPassword;
    suffix =
        isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;

    emit(AppRegisterChangePasswordVisibilityState());
  }
}