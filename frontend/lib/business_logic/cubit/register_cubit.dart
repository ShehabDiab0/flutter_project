import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../../../data/repository/auth_repository.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final AuthRepository authRepository;

  RegisterCubit(this.authRepository) : super(RegisterInitial());

  Future<void> register(Map<String, dynamic> userData) async {
    emit(RegisterLoading());
    try {
      await authRepository.registerUser(userData);
      emit(RegisterSuccess());
    } catch (e) {
      emit(RegisterFailure(error: e.toString()));
    }
  }
}
