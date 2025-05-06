import 'package:bloc/bloc.dart';
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
      emit(LoginSuccess(token: data['access'], name: data['name']));
    } catch (e) {
      emit(LoginFailure(error: e.toString()));
    }
  }
}
