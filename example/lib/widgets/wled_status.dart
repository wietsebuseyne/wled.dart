import 'package:example/bloc/wled_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WledStatus extends StatefulWidget {
  final String ipAddress;

  const WledStatus({
    Key? key,
    required this.ipAddress,
  }) : super(key: key);

  @override
  State<WledStatus> createState() => _WledStatusState();
}

class _WledStatusState extends State<WledStatus> {
  bool on = true;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'WLED',
              style: Theme.of(context).textTheme.headline6,
            ),
            Text(widget.ipAddress, style: Theme.of(context).textTheme.subtitle1),
          ],
        ),
        Switch(
          value: on,
          onChanged: (on) {
            context.read<WledBloc>().add(SetWledStatus(on: on));
            setState(() {
              this.on = on;
            });
          },
        ),
      ],
    );
  }
}
