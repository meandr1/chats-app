import 'package:chats/helpers/validator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> with Validator {
  AuthCubit() : super(AuthInitial());

validateEmail(String? email){
}

validatePass(String? pass){
  emit(AuthValidation(pass: pass));
}

void changeObscureStatus(){
emit(AuthValidation());
}

}
