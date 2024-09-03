import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';

import '../../todo_app_layout/todo_app/todo_cubit.dart';


Widget defaultButton({
  double conthight=70,
  double width=double.infinity,
  double radius=5,
  Color color=Colors.blue,
  required String text,
  required Function,
  bool isUpperCase=true,
})=>Container(
  height: conthight,
  width: width,
  child:
  MaterialButton(
    onPressed: Function,
    child: Text(isUpperCase?text.toUpperCase():text,style: TextStyle(color: Colors.white),),
  ),
  decoration: BoxDecoration(borderRadius: BorderRadiusDirectional.circular(radius),
      color: color
  ),
);

Widget defaultTextFormField({
  required TextEditingController? controller,
  required TextInputType? KeyboardType,
  Function(String)? onChanged,
  Function(String)? onSubmit,
  VoidCallback?onTap,
  required String? Function(String?)? validate,
  required String? lable,
  required IconData? prefix,
  bool isPassword = false,
  IconData? suffix,
  Function()? suffixpressed,
})=>TextFormField(
  controller: controller,
  keyboardType: KeyboardType,
  obscureText: isPassword,
  onChanged:onChanged,
  onFieldSubmitted:onSubmit,
  onTap: onTap,
  validator: validate,
  decoration: InputDecoration(
    prefixIcon: Icon(prefix),
    labelText: lable,
    border: OutlineInputBorder(),
    suffixIcon: suffix !=null?IconButton(icon: Icon(suffix),onPressed: suffixpressed,):null,

  ),
);

Widget defaultTasks(Map model,context)=>Dismissible(
  key: Key(model['id'].toString()),
  onDismissed: (direction){
    todoCubit.get(context).deleteFromDatabase(id: model['id']);
  },
  child: Padding(
    padding: const EdgeInsets.all(10.0),
    child: Row(
  
      children: [
        CircleAvatar(
          radius: 40,
          child: Text('${model['time']}'),
        ),
        SizedBox(width: 20,),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${model['tittle']}',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
              Text('${model['date']}',style: TextStyle(color: Colors.grey[500],fontSize: 15),)
            ],
          ),
        ),
        SizedBox(width: 20,),
        IconButton(onPressed: (){
         todoCubit.get(context).updateDataFromDatabase(status: 'Done', id: model['id']);
        }, icon:Icon(Icons.check_box,color: Colors.green,)),
        SizedBox(width: 20,),
        IconButton(onPressed: (){
          todoCubit.get(context).updateDataFromDatabase(status: 'Archive', id: model['id']);
        }, icon:Icon(Icons.archive,color: Colors.black45,)),
      ],
    ),
  ),
);

Widget buildTask({
  required List<Map> tasks,
})=>ConditionalBuilder(
    condition: tasks.length>0,
    builder: (context)=>ListView.separated(
        itemBuilder: (context,index)=>defaultTasks(tasks[index],context),
        separatorBuilder: (context,index)=> mySeparator()
        ,itemCount: tasks.length),
    fallback: (context)=>Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.list,size: 50,color: Colors.black45,),
          Text('No Tasks Yet,Make a new one ^-^',style: TextStyle(fontSize: 20,color: Colors.black45),)
        ],
      ),
    )
);

Widget mySeparator()=>Padding(
  padding: const EdgeInsets.all(15.0),
  child: Container(
    color: Colors.grey,
    height: 1,
    width: double.infinity,
  ),
);




