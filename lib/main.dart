import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sanad/Features/Login/presenation/view/login_view.dart';
import 'package:sanad/Features/Moderator%20Role%20Type/Beneficiary%20Details/presenation/manger/profile/profile_cubit.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'Core/Utils/App Colors.dart';
import 'bloc_observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

const supabaseUrl = 'https://vtsoufjuwrjpxribosjg.supabase.co';
const supabaseKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZ0c291Zmp1d3JqcHhyaWJvc2pnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDIwMzY4NDUsImV4cCI6MjA1NzYxMjg0NX0.lM2VArwLzWSU4B-cpQ9H-6YDzWb5hJA2mUiQuI_c8dU";

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseKey);


  Bloc.observer = MyBlocObserver();

  Widget widget;

  runApp(MyApp(widget: LoginScreen()));
}

class MyApp extends StatelessWidget {
  final Widget widget;

  const MyApp({super.key, required this.widget});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileCubit()..fetchUserData(),
      child: MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            scaffoldBackgroundColor: AppColorsData.white,
            platform: TargetPlatform.iOS,
            primaryColor: AppColorsData.primarySwatch,
            canvasColor: Colors.transparent,
            fontFamily: "Urbanist",
            iconTheme: const IconThemeData(
                color: AppColorsData.primaryColor, size: 25),
            primarySwatch: Colors.orange,
            appBarTheme: const AppBarTheme(
              backgroundColor: AppColorsData.white,
              toolbarHeight: 50,
              elevation: 0,
              surfaceTintColor: AppColorsData.white,
              centerTitle: true,
            ),
          ),
          home: widget
      ),
    );
  }
}
