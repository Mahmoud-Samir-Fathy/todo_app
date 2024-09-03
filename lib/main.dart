import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_application/shared/bloc_observer/bloc_observer.dart';
import 'package:todo_application/todo_app_layout/todo_app/todo_app_layout.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  runApp(const Myapp());
}
class Myapp extends StatelessWidget{
  const Myapp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
               debugShowCheckedModeBanner: false,
              home:TodoAppLayout()
          );
        }

  }
