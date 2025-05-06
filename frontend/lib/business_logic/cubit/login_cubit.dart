import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import '../../../data/repository/auth_repository.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository authRepository;

  LoginCubit(this.authRepository) : super(LoginInitial());

  Future<void> login(String email, String password) async {
    emit(LoginLoading());
    try {
      final data = await authRepository.loginUser(email, password);

      final accessToken = data['access'];
      final refreshToken = data['refresh'];

      if (accessToken == null || refreshToken == null) {
        emit(LoginFailure(error: 'Invalid token response'));
        return;
      }

      emit(LoginSuccess(accessToken: accessToken, refreshToken: refreshToken));
    } catch (e) {
      emit(LoginFailure(error: e.toString()));
    }
  }
}
