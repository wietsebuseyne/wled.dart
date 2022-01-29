import 'package:example/bloc/wled_bloc.dart';
import 'package:example/widgets/wled_brightness_slider.dart';
import 'package:example/widgets/wled_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(DemoProviders(child: WledDemoApp()));
}

class DemoProviders extends StatelessWidget {
  final Widget child;

  const DemoProviders({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<WledBloc>(
      create: (context) => WledBloc(),
      child: child,
    );
  }
}

class WledDemoApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WLED Demo',
      theme: ThemeData(primarySwatch: Colors.pink),
      home: Scaffold(
        appBar: AppBar(
          title: Text('WLED Demo'),
        ),
        body: WledDemoBody(),
      ),
    );
  }
}

class WledDemoBody extends StatelessWidget {
  const WledDemoBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WledBloc, WledState>(
      builder: (context, state) {
        if (state is WledUnconnected) {
          return WledConnectCard();
        } else if (state is WledConnected) {
          return WledControls(state: state);
        }
        return Text('Unimplemented');
      },
    );
  }
}

class WledControls extends StatelessWidget {
  final WledConnected state;

  const WledControls({Key? key, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: DefaultTextStyle(
        style: Theme.of(context).textTheme.subtitle2!,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            WledStatus(ipAddress: state.ipAddress),
            SizedBox(height: 8.0),
            WledBrightnessSlider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () => context.read<WledBloc>().add(DisconnectWled()),
                  child: Text('Disconnect'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class WledConnectCard extends StatefulWidget {
  const WledConnectCard({Key? key}) : super(key: key);

  @override
  State<WledConnectCard> createState() => _WledConnectCardState();
}

class _WledConnectCardState extends State<WledConnectCard> {
  late TextEditingController _controller;
  bool enabled = false;

  @override
  void initState() {
    _controller = TextEditingController(text: '192.168.1.42');
    _controller.addListener(() {
      bool enabled = true;
      try {
        Uri.parseIPv4Address(_controller.text);
      } on FormatException {
        enabled = false;
      }
      if (enabled != this.enabled) {
        setState(() {
          this.enabled = enabled;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('No WLED instance connected.'),
            SizedBox(height: 16.0),
            TextField(
              controller: _controller,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(border: OutlineInputBorder(), labelText: 'IP address'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed:
                      !enabled ? null : () => context.read<WledBloc>().add(ConnectWled(ipAddress: _controller.text)),
                  child: Text('Connect'),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
