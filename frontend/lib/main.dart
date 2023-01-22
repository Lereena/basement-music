import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sizer/sizer.dart';
import 'package:url_strategy/url_strategy.dart';

import 'bloc/settings_bloc/settings_bloc.dart';
import 'bloc_provider_wrapper.dart';
import 'firebase_options.dart';
import 'pages/home_page.dart';
import 'routes.dart';
import 'theme/custom_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);

  FirebaseUIAuth.configureProviders([
    EmailAuthProvider(),
  ]);

  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  final storage = await HydratedStorage.build(
    storageDirectory: kIsWeb ? HydratedStorage.webStorageDirectory : await getApplicationDocumentsDirectory(),
  );

  setPathUrlStrategy();

  HydratedBlocOverrides.runZoned(
    () => runApp(BasementMusic()),
    storage: storage,
  );
}

class BasementMusic extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProviderWrapper(
      child: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, settingsState) {
          return Sizer(
            builder: (context, orientation, deviceType) => MaterialApp(
              title: 'Basement',
              theme: CustomTheme.lightTheme,
              darkTheme: CustomTheme.darkTheme,
              themeMode: settingsState.darkTheme ? ThemeMode.dark : ThemeMode.light,
              initialRoute: NavigationRoute.signIn.name,
              onGenerateRoute: onGenerateRoute,
              home: const Material(child: HomePage()),
            ),
          );
        },
      ),
    );
  }
}
