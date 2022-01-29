import 'package:example/bloc/wled_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WledBrightnessSlider extends StatefulWidget {
  const WledBrightnessSlider({
    Key? key,
  }) : super(key: key);

  @override
  State<WledBrightnessSlider> createState() => _WledBrightnessSliderState();
}

class _WledBrightnessSliderState extends State<WledBrightnessSlider> {
  double value = 128;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.brightness_5),
        Expanded(
          child: Slider(
            min: 0,
            max: 256,
            value: value,
            divisions: 256,
            label: value.toInt().toString(),
            onChanged: (value) {
              context.read<WledBloc>().add(SetWledBrightness(value.toInt()));
              setState(() {
                this.value = value;
              });
            },
          ),
        ),
      ],
    );
  }
}
