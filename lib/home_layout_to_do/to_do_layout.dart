import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app/shared/componant/componants.dart';
import 'package:to_do_app/shared/cubit/cubit.dart';
import 'package:to_do_app/shared/cubit/states.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';


class ToDoHome extends StatelessWidget
{

  var titelControler = TextEditingController();
  var timeControler = TextEditingController();
  var dateControler = TextEditingController();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  // @override
  // void initState() {
  //   super.initState();
  //   createDatabase();
  // }
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubitToDo()..createDatabase(),
      child: BlocConsumer <AppCubitToDo , AppStatesToDo>(
        listener: (BuildContext context, state) {
          if (state is AppInsertDatabaseState ){
            Navigator.pop(context);
          }
        },
        builder:  (BuildContext context, state)
        {
          AppCubitToDo cubit = AppCubitToDo.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              backgroundColor: Color(0xffe36414),
              title: Text(cubit.titles[cubit.currentIndex]),
            ),
            body: ConditionalBuilder(
              condition: state is! AppGetDatabaseLoadingState,
              builder:(context) =>cubit.Screens[cubit.currentIndex]  ,
              fallback: (context) => const Center(child: CircularProgressIndicator()),
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Color(0xff001d3d),
              onPressed: ()
              {
                if(cubit.isBottomSheetShown) {
                  if(formKey.currentState!.validate()){
                    cubit.insertToDatabase(
                      title: titelControler.text,
                      time: timeControler.text,
                      date: dateControler.text,
                    );
                  }

                }else
                {
                  scaffoldKey.currentState!.showBottomSheet(
                        (context) =>Container(
                      color: Colors.grey[100],
                      padding: const EdgeInsets.all(20.0),
                      child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            defaulteFormFiled(
                              controller: titelControler,
                              type: TextInputType.text,
                              validation: (value){
                                if(value!.isEmpty){
                                  return 'Title is Empty';
                                }
                                return null ;
                              },
                              label: 'Task title',
                              prefix: Icons.title,
                            ),
                            SizedBox(height: 18,),
                            defaulteFormFiled(
                              controller: timeControler ,
                              type: TextInputType.datetime,
                              onTap: (){
                                showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                ).then((value) {
                                  timeControler.text= value!.format(context).toString();
                                  print(value.format(context));
                                });
                              },
                              validation: (value){
                                if(value!.isEmpty){
                                  return 'Time is required';
                                }
                                return null ;
                              },
                              label: 'Task time',
                              prefix: Icons.watch_later_outlined,
                            ),
                           const SizedBox(height: 18,),
                            defaulteFormFiled(
                              controller: dateControler ,
                              type: TextInputType.datetime,
                              onTap: (){
                                showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime.parse('2050-01-01'),
                                ).then((value) {
                                  dateControler.text = DateFormat.yMMMd().format(value!);
                                  // print(DateFormat.yMMMd().format(value ));
                                });

                              },
                              validation: (value){
                                if(value!.isEmpty){
                                  return 'Date is required';
                                }
                                return null ;
                              },
                              label: 'Task Date',
                              prefix: Icons.calendar_today,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ).closed.then((value) {
                    cubit.ChangeBottomSheetState(
                      isShown: false,
                      icon: Icons.edit,
                    );
                  });
                  cubit.ChangeBottomSheetState(
                    isShown: true,
                    icon: Icons.add,
                  );
                }

              },
              child: Icon(cubit.floatButton),
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: cubit.currentIndex,
              onTap: (index){
                cubit.changeCurrentIndex(index);
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.menu),
                  label: 'Tasks',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.check_circle_outline),
                  label: 'Done',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.archive_outlined),
                  label: 'Archive',
                ),
              ],
            ),
          );
        },

      ),
    );
  }
// Instance of 'Future<String>' ==> because Future work background and take more time
// gave an object from method
// sol first step ==> put await before call method as like  ==> var name = getName() ; this in the body
// sol second step ==> put async before method body as like ==> onPressed: () async

//Future <String> getName() async
//{
//return 'this take more time';
//}

// create database

}