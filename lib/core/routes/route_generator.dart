import 'package:manager_mqtt/core/routes/route_names.dart';
import 'package:flutter/material.dart';
import 'package:manager_mqtt/feature/auth/login_screen.dart';
import 'package:manager_mqtt/feature/device/device_form_screen.dart';
import 'package:manager_mqtt/feature/device/device_history_screen.dart';
import 'package:manager_mqtt/feature/device/device_real_time_screen.dart';
import 'package:manager_mqtt/feature/device/device_screen.dart';
import 'package:manager_mqtt/feature/home/home_screen.dart';
import 'package:manager_mqtt/feature/spalsh/splash_screen.dart';

Map<String, Widget Function(BuildContext)> appRoutes() {
  return {
    RouteNames.splash: (_) => const SplashScreen(),
    RouteNames.login: (_) => const LoginScreen(),
    RouteNames.home: (_) => const HomeScreen(),
    RouteNames.devices: (_) => const DeviceScreen(),
    RouteNames.deviceForm: (_) => const DeviceForm(),
    RouteNames.deviceHistory: (_) => const DeviceHistoryScreen(),
    RouteNames.deviceRealtime: (_) => const DeviceRealTimeScreen(),
  };

}