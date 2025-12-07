import 'package:flutter_bloc/flutter_bloc.dart';
import'../../../core/repositories/auth_repository.dart';
import'../../../core/models/user.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent,AuthState>{//This BLoC converts AuthEvent into AuthState//This Bloc receives AuthEvent, And outputs AuthState
  
  final AuthRepository authRepo; //Bloc does not talk to Hive directly.

  AuthBloc(this.authRepo):super(AuthInitial()){// Inside this we register event handlers:
    on<AppStarted>(_onAppStarted);//Connect event with logic method
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogout);
    on<ContinueAsGuest>(_onGuest);
  }

  Future <void> _onAppStarted(AppStarted event, Emitter<AuthState> emit)async{
    final user = await authRepo.loadUser();
    if(user!=null){
      emit(AuthAuthenticated(user));
    }
    else{
      emit(AuthUnauthenticated());
    }
  }

  Future <void> _onLoginRequested(LoginRequested event,Emitter <AuthState> emit)async{
    emit(AuthLoading());

    await Future.delayed(const Duration(milliseconds: 500));

    if(event.email=='user@example.com' && event.password=='password123'){
      final user=User(id: 'u1', email: event.email);
      await authRepo.saveUser(user);
      emit(AuthAuthenticated(user));
    }
    else{
      emit(AuthFailer('Invalid credentials'));
      emit(AuthUnauthenticated());
    }
  }
  Future <void> _onGuest(ContinueAsGuest event,Emitter<AuthState> emit) async{
    final user =User.guest();
    await authRepo.saveUser(user);
    emit(AuthAuthenticated(user));
  }

  Future <void> _onLogout(LogoutRequested event,Emitter<AuthState> emit)async{
    await authRepo.clear();
    emit(AuthUnauthenticated());
  }
}