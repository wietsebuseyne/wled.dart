part of 'wled_bloc.dart';

abstract class WledEvent extends Equatable {
  const WledEvent();
}

class ConnectWled extends WledEvent {
  final String ipAddress;

  const ConnectWled({required this.ipAddress});

  @override
  List<Object> get props => [ipAddress];
}

class DisconnectWled extends WledEvent {
  const DisconnectWled();

  @override
  List<Object> get props => [];
}

class _StateReceived extends WledEvent {
  final WLEDState state;

  const _StateReceived(this.state);

  @override
  List<Object> get props => [state];
}

class SetWledBrightness extends WledEvent {
  final int brightness;

  const SetWledBrightness(this.brightness);

  @override
  List<Object> get props => [brightness];
}

class SetWledStatus extends WledEvent {
  final bool on;

  const SetWledStatus({required this.on});

  @override
  List<Object> get props => [on];
}
