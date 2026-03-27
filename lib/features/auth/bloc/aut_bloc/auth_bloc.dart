import 'package:bloc/bloc.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:meta/meta.dart';

import '../../../../config/failure.dart';
import '../../data/auth_remote_data_source.dart';
import '../../data/employee_local_data_source.dart';
import '../../models/user.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthRemoteDataSource ds;
  EmployeeLocalDataSource repo;
  AuthBloc(this.ds, this.repo) : super(AuthLoading()) {
    on<AuthEvent>((event, emit) async {
      if (event is Login) {
        emit(AuthLoading());
        var failOrNot = await ds.login(
          username: event.username,
          password: event.password,
          rememberMe: event.rememberMe,
        );
        failOrNot.fold((l) => emit(AuthFailed(l)), (r) => emit(AuthSuccess(r)));
      }

      if (event is LogoutEvent) {
        repo.saveUser(u: null);
        repo.signOut();
        emit(AuthFailed(const Failure()));
      }

      if (event is GetLocalUser) {
        if (repo.rememberMe ?? false) {
          var user = repo.user;
          if (user != null) {
            bool hasExpired = JwtDecoder.isExpired(user.token!);
            if (!hasExpired) {
              emit.call(AuthSuccess(user));
              return;
            }
          }
        }
        emit.call(AuthInitial());
      }
    });
  }
}
