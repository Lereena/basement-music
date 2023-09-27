import 'dart:async';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/connectivity_status_bloc/connectivity_status_cubit.dart';
import '../page_title.dart';
import 'side_navigation_drawer.dart';

class NoConnectionFlushbar extends StatelessWidget {
  const NoConnectionFlushbar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Flushbar(
      title: 'You are offline',
      message: 'Cached tracks are available to listen',
      margin: const EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(16),
      backgroundColor: theme.colorScheme.primaryContainer.withOpacity(0.5),
      titleColor: theme.colorScheme.onBackground,
      messageColor: theme.colorScheme.onSurface,
    );
  }
}

class DrawerNavigationWrapper extends StatefulWidget {
  final bool drawerNavigation;
  final String pageTitle;
  final Widget child;

  const DrawerNavigationWrapper({
    super.key,
    required this.drawerNavigation,
    required this.pageTitle,
    required this.child,
  });

  @override
  State<DrawerNavigationWrapper> createState() =>
      _DrawerNavigationWrapperState();
}

class _DrawerNavigationWrapperState extends State<DrawerNavigationWrapper> {
  late StreamSubscription _subscription;

  late final _theme = Theme.of(context);
  late final _flushbar = Flushbar(
    title: 'You are offline',
    message: 'Cached tracks are available to listen',
    margin: const EdgeInsets.all(8),
    borderRadius: BorderRadius.circular(16),
    backgroundColor: _theme.colorScheme.primaryContainer,
    titleColor: _theme.colorScheme.onSurface,
    messageColor: _theme.colorScheme.onSurface,
    forwardAnimationCurve: Curves.easeIn,
    reverseAnimationCurve: Curves.easeOut,
    dismissDirection: FlushbarDismissDirection.HORIZONTAL,
  );

  @override
  void initState() {
    super.initState();

    _subscription =
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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 70,
        scrolledUnderElevation: theme.brightness == Brightness.dark ? 0 : 1,
        iconTheme: theme.iconTheme,
        title: PageTitle(text: widget.pageTitle),
        leading: widget.drawerNavigation
            ? Builder(
                builder: (context) => InkWell(
                  onTap: () => Scaffold.of(context).openDrawer(),
                  customBorder: const CircleBorder(),
                  child: const Icon(Icons.menu),
                ),
              )
            : null,
        backgroundColor: theme.colorScheme.background,
      ),
      drawer: widget.drawerNavigation ? const SideNavigationDrawer() : null,
      body: widget.child,
    );
  }
}
