import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app/shared/componant/componants.dart';
import 'package:to_do_app/shared/cubit/cubit.dart';
import 'package:to_do_app/shared/cubit/states.dart';

class NewTasks extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return BlocConsumer <AppCubitToDo , AppStatesToDo>(
      listener: (context , state){ },
      builder:(context,state) {
        var tasks = AppCubitToDo.get(context).newTasks;
        return tasksOrBuilder(
          tasks: tasks,
        );
      },
    );
  }
}