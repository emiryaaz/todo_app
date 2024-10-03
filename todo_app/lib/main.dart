import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:todo_app/data/local_storage.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/pages/home_page.dart';
import 'package:hive_flutter/hive_flutter.dart';

final locator = GetIt.instance;

void setup(){
  locator.registerSingleton<LocalStorage>(HiveLocalStorage());
}

Future<void> setupHive() async{
  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter());
  var taskBox = await Hive.openBox<Task>('tasks');
  for(var task in taskBox.values){
    if(task.createdAt.day != DateTime.now().day){
      taskBox.delete(task.id);
    }
  };
}

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  await setupHive();
  setup();
  runApp(
    EasyLocalization(
        child: const MyApp(),
        supportedLocales: const [Locale('en','US'),Locale('tr','TR')],
        path: 'assets/translations',
    fallbackLocale: const Locale('en','US'),)
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        appBarTheme: const AppBarTheme (
          elevation: 0,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color:Colors.black),
        )
      ),
      home: const HomePage(),
    );
  }
}

