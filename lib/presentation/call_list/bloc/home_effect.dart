part of 'home_bloc.dart';

/// One-off side effects for the Home page; never stored in [HomeState].
sealed class HomeEffect extends Equatable {
  const HomeEffect();

  @override
  List<Object?> get props => [];
}

final class LaunchCall extends HomeEffect {
  const LaunchCall(this.phone);

  final String phone;

  @override
  List<Object?> get props => [phone];
}

final class LaunchSms extends HomeEffect {
  const LaunchSms(this.phone, this.body);

  final String phone;
  final String body;

  @override
  List<Object?> get props => [phone, body];
}

final class NavigateTo extends HomeEffect {
  const NavigateTo(this.location);

  final String location;

  @override
  List<Object?> get props => [location];
}

final class ShowMessage extends HomeEffect {
  const ShowMessage(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
