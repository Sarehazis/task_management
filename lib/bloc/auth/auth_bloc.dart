import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore firestore;
  late final CollectionReference users;

  AuthBloc(this._firebaseAuth)
      : firestore = FirebaseFirestore.instance,
        users = FirebaseFirestore.instance.collection('users'),
        super(AuthStateInitial()) {
    on<AuthEventLogin>((event, emit) async {
      emit(AuthStateLoading());

      try {
        UserCredential userCredential =
            await _firebaseAuth.signInWithEmailAndPassword(
          email: event.email,
          password: event.password,
        );

        await users.add({
          'email': userCredential.user!.email,
          'uid': userCredential.user!.uid,
          'name': userCredential.user!.displayName,
          'createdAt': Timestamp.now(),
          'lastLoginAt': Timestamp.now(),
        });

        emit(AuthStateLoaded());
      } catch (e) {
        emit(AuthStateError(message: 'Login gagal: ${e.toString()}'));
      }
    });

    on<AuthEventLogout>((event, emit) async {
      try {
        await _firebaseAuth.signOut();
        emit(AuthStateInitial());
      } catch (e) {
        emit(AuthStateError(message: 'Logout gagal: ${e.toString()}'));
      }
    });
  }
}
