import 'dart:async';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/connectivity_status_bloc/connectivity_status_cubit.dart';

class ConnectivityStatusWrapper extends StatefulWidget {
  final Widget child;

  const ConnectivityStatusWrapper({
    super.key,
    required this.child,
  });

  @override
  State<ConnectivityStatusWrapper> createState() =>
      _ConnectivityStatusWrapperState();
}

class _ConnectivityStatusWrapperState extends State<ConnectivityStatusWrapper> {
  late final StreamSubscription _subscription;

  late final _theme = Theme.of(context);

  late final _flushbar = Flushbar(
    title: 'You are offline',
    message: kIsWeb
        ? 'Please check your network connection'
        : 'Cached tracks are available to listen',
    icon: const Icon(Icons.wifi_off, size: 32),
    margin: const EdgeInsets.all(8),
    borderRadius: BorderRadius.circular(16),
    backgroundColor: _theme.colorScheme.primaryContainer,
    titleColor: _theme.colorScheme.onSurface,
    messageColor: _theme.colorScheme.onSurface,
    forwardAnimationCurve: Curves.easeIn,
    reverseAnimationCurve: Curves.easeOut,
    dismissDirection: FlushbarDismissDirection.HORIZONTAL,
    onTap: (flushbar) => flushbar.dismiss(),
  );

  @override
  void initState() {
    super.initState();

    context.read<ConnectivityStatusCubit>().stream.listen(_handleFlushbar);
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  void _handleFlushbar(ConnectivityStatusState status) {
    if (status is NoConnectionState) {
      if (!_flushbar.isShowing()) {
        _flushbar.show(context);
      }
    } else {
      _flushbar.dismiss();
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
