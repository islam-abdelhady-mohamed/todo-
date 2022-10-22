import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:to_do_app/shared/stayle/cubit_observer.dart';
import 'home_layout_to_do/to_do_layout.dart';
void main() {
  Bloc.observer = MyBlocObserver();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ToDoHome(),
    );
  }
}