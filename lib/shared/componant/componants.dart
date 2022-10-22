import 'package:flutter/material.dart';
import 'package:to_do_app/shared/cubit/cubit.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';

//reusable component
// timing
// quality
// refactor
// clean code

Widget defaulteFormFiled({
  required TextEditingController controller,
  required TextInputType type,
  bool isPassword = false,
  var onSubmitted,
  var onChanged,
  var onTap,
  required var validation,
  required String label,
  //required IconData prefix,
  var prefix,
  IconData? suffix,
  var suffixPressed,
}) =>
    TextFormField(
      controller: controller,
      keyboardType: type,
      obscureText: isPassword,
      onFieldSubmitted: onSubmitted,
      onChanged: onChanged,
      onTap: onTap,
      validator: validation,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        prefixIcon: Icon(prefix),
        suffixIcon: suffix != null ? IconButton(
          icon: Icon(suffix),
          onPressed: suffixPressed,
        )
            : null,
        //hintText: 'Email',
      ),
    );

Widget bulidTaskItem(Map model, context) =>Dismissible(
  key: Key(model['id'].toString()),
  onDismissed: (direction)
  {
    AppCubitToDo.get(context).deleteData(id: model['id']);
  },
  child: Padding(
    padding: const EdgeInsets.all(18.0),
    child: Row(
      children: [
        Container(
          height: 40,
          width:70 ,
          decoration: BoxDecoration(
            color: Color(0xff0f4c5c),
            borderRadius: BorderRadius.circular(6.0),
          ),
          child:Center(
            child: Text('${model['time']}',
              style: const TextStyle(
                color:Colors.white ,
              ),
            ),
          ) ,
        ),
       const SizedBox(width: 20.0,),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${model['title']}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 6,),
              Text(
                '${model['date']}',
                style: TextStyle(
                    color: Colors.blueGrey
                ),
              ),
            ],
          ),
        ),
       const SizedBox(width: 20.0,),
        IconButton(
          onPressed: (){
            AppCubitToDo.get(context).UpdateData(status: 'done', id: model['id']);
          },
          icon:Icon(
            Icons.check_box,
            color: Colors.green,
          ),
        ),
        IconButton(
          onPressed: (){
            AppCubitToDo.get(context).UpdateData(status: 'Archived', id: model['id']);
          },
          icon:Icon(
            Icons.archive,
            color: Color(0xff0f4c5c),
          ),
        ),

      ],
    ),

  ),
) ;

Widget tasksOrBuilder ({
  required List<Map> tasks ,
}) => ConditionalBuilder(
  condition: tasks.length > 0 ,
  builder: (context) => ListView.separated(
    itemBuilder: (context ,index ) => bulidTaskItem(tasks[index], context) ,
    separatorBuilder: (context ,index ) => Padding(
      padding: const EdgeInsetsDirectional.only(start: 30.0),
      child: Container(
        width: double.infinity,
        height: 1.0,
        color: Colors.grey[300],
      ),
    ),
    itemCount: tasks.length,
  ),
  fallback: (context) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.menu,
          size: 100,
          color: Colors.grey,
        ),
        Text(
          'No Tasks Yet , Please Enter New Tasks',
          style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
              fontWeight: FontWeight.w600
          ),
        ),
      ],
    ),
  ),
);