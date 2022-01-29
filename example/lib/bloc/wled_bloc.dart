import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:wled/wled.dart';

part 'wled_event.dart';
part 'wled_state.dart';

class WledBloc extends Bloc<WledEvent, WledState> {
  WLED? wled;
  StreamSubscription? socketSubscription;

  WledBloc() : super(const WledUnconnected()) {
    on<ConnectWled>(_connect, transformer: restartable());
    on<DisconnectWled>(_disconnect, transformer: droppable());
    on<SetWledBrightness>(_setBrightness, transformer: sequential());
    on<SetWledStatus>(_setStatus, transformer: sequential());
    on<_StateReceived>(_updateState, transformer: sequential());
  }

  @override
  Future<void> close() async {
    await socketSubscription?.cancel();
    await wled?.close();
    await super.close();
  }

  Future<void> _connect(ConnectWled event, Emitter<WledState> emit) async {
    if (state is WledConnected) {
      await _disconnect(event, emit);
    }
    emit(WledConnecting(ipAddress: event.ipAddress));
    //TODO cancel connecting
    try {
      //TODO timeout when not found
      wled = await WLED.connect(event.ipAddress);
      await socketSubscription?.cancel();
      socketSubscription = wled!.stream.listen((wledState) {
        add(_StateReceived(wledState));
      })
        ..onDone(() async {
          await socketSubscription?.cancel();
          socketSubscription = null;
          add(const DisconnectWled());
        });
    } on Exception {
      emit(const WledUnconnected());
    }
  }

  Future<void> _disconnect(WledEvent _, Emitter<WledState> emit) async {
    await socketSubscription?.cancel();
    socketSubscription = null;
    await wled?.close();
    emit(WledUnconnected());
  }

  Future<void> _updateState(_StateReceived event, Emitter<WledState> emit) async {
    final s = state;
    if (s is WledConnecting) {
      emit(WledConnected(ipAddress: s.ipAddress, state: event.state));
    } else if (s is WledConnected) {
      emit(s.copyWith(state: event.state));
    }
  }

  Future<void> _setBrightness(SetWledBrightness event, Emitter<WledState> emit) async {
    wled?.setBrightness(event.brightness);
  }

  Future<void> _setStatus(SetWledStatus event, Emitter<WledState> emit) async {
    wled?.setStatus(event.on);
  }
}
