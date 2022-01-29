part of 'wled_bloc.dart';

abstract class WledState extends Equatable {
  const WledState();
}

class WledUnconnected extends WledState {
  const WledUnconnected();
  @override
  List<Object> get props => [];
}

class WledConnecting extends WledState {
  final String ipAddress;

  const WledConnecting({required this.ipAddress});

  @override
  List<Object> get props => [ipAddress];
}

class WledConnected extends WledState {
  final String ipAddress;
  final WLEDState state;

  const WledConnected({required this.ipAddress, required this.state});

  @override
  List<Object> get props => [ipAddress, state];

  WledConnected copyWith({String? ipAddress, WLEDState? state}) {
    return WledConnected(
      ipAddress: ipAddress ?? this.ipAddress,
      state: state ?? this.state,
    );
  }
}
