import 'package:app_usage/app_usage.dart';
import 'package:ascetic_launcher/bloc/all_apps/bloc.dart';
import 'package:ascetic_launcher/bloc/app_usage/bloc.dart';
import 'package:ascetic_launcher/bloc/weather/bloc.dart';
import 'package:ascetic_launcher/bloc/weather_settings/bloc.dart';
import 'package:ascetic_launcher/pages/main/ascetic_launcher_page.dart';
import 'package:ascetic_launcher/provider/dynamic_theme.dart';
import 'package:ascetic_launcher/repositories/all_apps/all_apps_data_provider.dart';
import 'package:ascetic_launcher/repositories/all_apps/all_apps_repository.dart';
import 'package:ascetic_launcher/repositories/app_usage/app_usage_data_provider.dart';
import 'package:ascetic_launcher/repositories/app_usage/app_usage_repository.dart';
import 'package:ascetic_launcher/repositories/weather/weather_api_client.dart';
import 'package:ascetic_launcher/repositories/weather/weather_repository.dart';
import 'package:ascetic_launcher/repositories/weather_settings/weather_settings_repository.dart';
import 'package:ascetic_launcher/repositories/weather_settings/weather_settings_shared_preferences.dart';
import 'package:ascetic_launcher/themes/blue_theme.dart';
import 'package:ascetic_launcher/themes/dark_theme.dart';
import 'package:ascetic_launcher/themes/green_theme.dart';
import 'package:ascetic_launcher/themes/grey_theme.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'bloc/favorite_apps/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'repositories/favorite_apps/favorite_apps_repository.dart';
import 'repositories/favorite_apps/favorite_apps_shared_preferences.dart';

void main() {
  final FavoriteAppsRepository favoriteAppsRepository = FavoriteAppsRepository(
    favoriteAppsSharedPreferences: FavoriteAppsSharedPreferences(),
  );

  final AllAppsRepository allAppsRepository = AllAppsRepository(
    allAppsDataProvider: AllAppsDataProvider(),
  );

  final WeatherRepository weatherRepository = WeatherRepository(
    weatherApiClient: WeatherApiClient(
      httpClient: http.Client(),
    ),
  );

  final AppUsageRepository appUsageRepository = AppUsageRepository(
    appUsageDataProvider: AppUsageDataProvider(
      appUsage: AppUsage(),
    ),
  );

  final WeatherSettingsRepository weatherSettingsRepository =
      WeatherSettingsRepository(
    weatherSettingsSharedPreferences: WeatherSettingsSharedPreferences(),
  );

  runApp(ChangeNotifierProvider<DynamicTheme>(
    builder: (_) => DynamicTheme(),
    child: MyApp(
      favoriteAppsRepository: favoriteAppsRepository,
      allAppsRepository: allAppsRepository,
      weatherRepository: weatherRepository,
      appUsageRepository: appUsageRepository,
      weatherSettingsRepository: weatherSettingsRepository,
    ),
  ));
}

class MyApp extends StatelessWidget {
  final FavoriteAppsRepository favoriteAppsRepository;
  final AllAppsRepository allAppsRepository;
  final WeatherRepository weatherRepository;
  final AppUsageRepository appUsageRepository;
  final WeatherSettingsRepository weatherSettingsRepository;

  const MyApp({
    Key key,
    @required this.favoriteAppsRepository,
    @required this.allAppsRepository,
    @required this.weatherRepository,
    @required this.appUsageRepository,
    @required this.weatherSettingsRepository,
  })  : assert(favoriteAppsRepository != null),
        assert(allAppsRepository != null),
        assert(weatherRepository != null),
        assert(appUsageRepository != null),
        assert(weatherSettingsRepository != null),
        super(key: key);

  ThemeData getTheme(MyThemesKeys themeKey) {
    switch (themeKey) {
      case MyThemesKeys.GREY:
        return greyTheme;
        break;
      case MyThemesKeys.GREEN:
        return greenTheme;
        break;
      case MyThemesKeys.BLUE:
        return blueTheme;
        break;
      case MyThemesKeys.DARK_GREY:
        return darkTheme;
        break;
      default:
        return greyTheme;
    }
  }

  @override
  Widget build(BuildContext context) {
    final DynamicTheme themeProvider = Provider.of<DynamicTheme>(context);
    return MultiBlocProvider(
      providers: [
        BlocProvider<FavoriteAppsBloc>(
          builder: (context) => FavoriteAppsBloc(
            favoriteAppsRepository: favoriteAppsRepository,
          ),
        ),
        BlocProvider<AllAppsBloc>(
          builder: (context) => AllAppsBloc(
            allAppsRepository: allAppsRepository,
          ),
        ),
        BlocProvider<WeatherBloc>(
          builder: (context) => WeatherBloc(
            weatherRepository: weatherRepository,
          ),
        ),
        BlocProvider<AppUsageBloc>(
          builder: (context) => AppUsageBloc(
            appUsageRepository: appUsageRepository,
          ),
        ),
        BlocProvider<WeatherSettingsBloc>(
          builder: (context) => WeatherSettingsBloc(
            weatherSettingsRepository: weatherSettingsRepository,
          ),
        )
      ],
      child: MaterialApp(
        title: 'Ascetic Launcher',
        theme: getTheme(themeProvider.currentTheme),
        home: AsceticLauncherPage(),
      ),
    );
  }
}
