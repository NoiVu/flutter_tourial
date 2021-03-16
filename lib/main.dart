import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod_tutorial/timer.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  runApp(
    ProviderScope(child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('My Timer App'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TimerTextWidget(),
              SizedBox(height: 20),
              ButtonsContainer(),
            ],
          ),
        ));
  }
}

class ButtonsContainer extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final state = useProvider(buttonProvider);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        if (state == ButtonState.initial) ...[
          StartButton(),
        ],
        if (state == ButtonState.started) ...[
          PauseButton(),
          SizedBox(width: 20),
          ResetButton()
        ],
        if (state == ButtonState.paused) ...[
          StartButton(),
          SizedBox(width: 20),
          ResetButton()
        ],
        if (state == ButtonState.finished) ...[
          ResetButton(),
        ]
      ],
    );
  }
}

class ResetButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        context.read(timerProvider).reset();
      },
      child: Icon(Icons.replay),
    );
  }
}

class PauseButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        context.read(timerProvider).pause();
      },
      child: Icon(Icons.pause),
    );
  }
}

class StartButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        context.read(timerProvider).start();
      },
      child: Icon(Icons.play_arrow),
    );
  }
}

class TimerTextWidget extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final timeLeft = useProvider(timeLeftProvider);
    return Text(
      timeLeft,
      style: Theme.of(context).textTheme.headline2,
    );
  }
}

final timerProvider =
    StateNotifierProvider<TimerNotifier>((ref) => TimerNotifier());

final _timeLeftProvider = Provider<String>((ref) {
  return ref.watch(timerProvider.state).timeLeft;
});

final timeLeftProvider = Provider<String>((ref) {
  return ref.watch(_timeLeftProvider);
});

final _buttonState = Provider<ButtonState>((ref) {
  return ref.watch(timerProvider.state).buttonState;
});

final buttonProvider = Provider<ButtonState>((ref) {
  return ref.watch(_buttonState);
});
