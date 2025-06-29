import 'package:flutter/material.dart';
import 'package:werkbank/werkbank.dart';
import 'package:werkbank_werkbank/tags.dart';

WidgetBuilder knobsUseCase(UseCaseComposer c) {
  c
    ..description('''
# Knobs Use Case

A showcase of all supported knobs by the knobs addon.

## Overview

This use case demonstrates the various knobs supported by the knobs addon in the Werkbank package. Knobs allow you to dynamically adjust the properties of your widgets during development.

## Features
- **Boolean Knob**: A simple toggle switch.
- **Int Slider**: A slider for selecting integer values.
- **Double Slider**: A slider for selecting double values.
- **List Selector**: A dropdown for selecting from a list of options.
- **String Input**: A single-line text input.
- **Multi-line String Input**: A multi-line text input.
- **Milliseconds Input**: An input for duration in milliseconds.
- **Nullable Knobs**: All of the above knobs also have nullable variants.
- **Animation Controller Knob**: A knob for selecting an animation controller.
- **Interval Knob**: A knob for selecting an interval curve.
- **Curve Knob**: A knob for selecting a curve.
- **Curved Interval Knob**: A knob for selecting a curved interval curve.
- **Focus Node Knob**: A knob for selecting a focus node.
- **Focus Node Parent Knob**: A knob for selecting a focus node for a parent widget.
- **Focus Node Child Knob**: A knob for selecting a focus node for a child widget.
''')
    ..tags([Tags.knobs, Tags.useCase, Tags.addon])
    ..constraints.initial(width: 500, viewLimitedMaxHeight: false)
    ..overview.withoutThumbnail();

  final knobs = [
    // Regular
    c.knobs.boolean('Boolean', initialValue: false),
    c.knobs.intSlider('Int Slider', initialValue: 0),
    c.knobs.doubleSlider('Double Slider', initialValue: 0),
    c.knobs.list('List', options: ['A', 'B', 'C'], optionLabel: (e) => e),
    c.knobs.string('String', initialValue: 'Hello'),
    c.knobs.stringMultiLine(
      'String Multi Line',
      initialValue: 'Hello\nWorld',
    ),
    c.knobs.millis(
      'Milliseconds',
      initialValue: Durations.long1,
    ),
    c.knobs.date(
      'Date',
      initialValue: DateTime.now(),
    ),
    // Nullable
    c.knobs.nullable.boolean(
      'Nullable Boolean',
      initialValue: false,
    ),
    c.knobs.nullable.intSlider(
      'Nullable Int Slider',
      initialValue: 0,
    ),
    c.knobs.nullable.doubleSlider(
      'Nullable Double Slider',
      initialValue: 0,
    ),
    c.knobs.nullable.list(
      'Nullable List',
      options: ['A', 'B', 'C'],
      optionLabel: (e) => e,
      initialOption: 'A',
    ),
    c.knobs.nullable.string(
      'Nullable String',
      initialValue: 'Hello',
    ),
    c.knobs.nullable.stringMultiLine(
      'Nullable String Multi Line',
      initialValue: 'Hello\nWorld',
    ),
    c.knobs.nullable.millis(
      'Nullable Milliseconds',
      initialValue: Durations.long1,
    ),
    c.knobs.nullable.date(
      'Nullable Date',
      initialValue: DateTime.now(),
    ),
  ];

  final animationControllerKnob = c.knobs.animationController(
    'Animation Controller',
    // initialValue: 0,
    initialDuration: const Duration(seconds: 2),
  );

  final intervalKnob = c.knobs.interval(
    'Interval',
    initialValue: const Interval(0, .5),
  );

  final curveKnob = c.knobs.curve(
    'Curve',
    initialValue: Curves.ease,
  );

  final curvedIntervalKnob = c.knobs.curvedInterval(
    'CurvedInterval',
    initialValue: const Interval(0, 1, curve: Curves.ease),
  );

  final focusNodeKnob = c.knobs.focusNode(
    'FocusNode',
  );

  final focusNodeParentKnob = c.knobs.focusNode(
    'FocusNode Parent',
  );

  final focusNodeChildKnob = c.knobs.focusNode(
    'FocusNode Child',
  );

  c
    ..knobPreset('Focus Single Widget', () {
      focusNodeKnob.value.requestFocus();
    })
    ..knobPreset('Focus Nested Parent', () {
      focusNodeParentKnob.value.requestFocus();
    })
    ..knobPreset('Focus Nested Child', () {
      focusNodeChildKnob.value.requestFocus();
    });

  return (context) {
    final intervalAnimation = animationControllerKnob.value.drive(
      CurveTween(curve: intervalKnob.value),
    );
    final curvedAnimation = animationControllerKnob.value.drive(
      CurveTween(curve: curveKnob.value),
    );
    final curvedIntervalAnimation = animationControllerKnob.value.drive(
      CurveTween(curve: curvedIntervalKnob.value),
    );

    final text = [
      for (final knob in knobs)
        '${knob.label}: ${knob.value.toString().replaceAll('\n', r'\n')}',
    ].join('\n');

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          WTextArea(
            text: text,
          ),
          const SizedBox(height: 16),
          RotationTransition(
            turns: intervalAnimation,
            child: Container(
              width: 100,
              height: 100,
              color: Colors.red,
            ),
          ),
          RotationTransition(
            turns: curvedAnimation,
            child: Container(
              width: 100,
              height: 100,
              color: Colors.green,
            ),
          ),
          RotationTransition(
            turns: curvedIntervalAnimation,
            child: Container(
              width: 100,
              height: 100,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            focusNode: focusNodeKnob.value,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {},
            focusNode: focusNodeParentKnob.value,
            child: Switch(
              focusNode: focusNodeChildKnob.value,
              value: false,
              onChanged: (_) {},
            ),
          ),
        ],
      ),
    );
  };
}
