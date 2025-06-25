import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vision_parse/core/entities/profile.dart';
import 'package:vision_parse/core/get_it.dart';
import 'package:vision_parse/utils/shared_preferences_manager.dart';

part 'auth_event.dart';
part 'auth_state.dart';

/// Enum representing the progress status of a request.
enum RequestProgressStatus {
  /// Indicates that no request is in progress.
  nothing,

  /// Indicates that a request is currently loading.
  loading,

  /// Indicates that a request has been successfully completed.
  success,

  /// Indicates that a request has encountered an error.
  error,
}

/// Extension on [RequestProgressStatus] providing convenience methods.
extension RequestProgressStatusExtension on RequestProgressStatus {
  /// Returns `true` if the status is [RequestProgressStatus.nothing], `false` otherwise.
  bool get isNothing => this == RequestProgressStatus.nothing;

  /// Returns `true` if the status is [RequestProgressStatus.loading], `false` otherwise.
  bool get isLoading => this == RequestProgressStatus.loading;

  /// Returns `true` if the status is [RequestProgressStatus.success], `false` otherwise.
  bool get isSuccess => this == RequestProgressStatus.success;

  /// Returns `true` if the status is [RequestProgressStatus.error], `false` otherwise.
  bool get isError => this == RequestProgressStatus.error;
}


class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthState()) {
    on<AuthEmailLoginEvent>(_onAuthEmailLoginEvent);
  }

  void _onAuthEmailLoginEvent(
    AuthEmailLoginEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(
      emailLoginProgressStatus: RequestProgressStatus.loading,
    ));
    try {
      await serviceLocator<SupabaseClient>().auth.signInWithPassword(
        email: event.email,
        password: event.password,
      );
      final user = await serviceLocator<SupabaseClient>().rpc('get_user_profile').single();
      // por si acaso
      serviceLocator<SharedPreferencesManager>().setIsGuest(false);
      emit(state.copyWith(
        emailLoginProgressStatus: RequestProgressStatus.success,
        profile: Profile.fromJson(user),
      ));
    } on AuthException catch (e) {
      emit(state.copyWith(
        emailLoginProgressStatus: RequestProgressStatus.error,
        emailErrorMessage: e.message,
      ));
    } catch (e) {
      emit(state.copyWith(
        emailLoginProgressStatus: RequestProgressStatus.error,
        emailErrorMessage: e.toString(),
      ));
    }
  }
}
