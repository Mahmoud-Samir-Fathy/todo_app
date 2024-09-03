import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import '../../todo_app_layout/todo_app/todo_cubit.dart';


Widget defaultButton({
  double containerHeight=70,
  double width=double.infinity,
  double radius=5,
  Color color=Colors.blue,
  required String text,
  required function,
  bool isUpperCase=true,
})=>Container(
  height: containerHeight,
  width: width,
  decoration: BoxDecoration(borderRadius: BorderRadiusDirectional.circular(radius),
      color: color
  ),
  child:
  MaterialButton(
    onPressed: function,
    child: Text(isUpperCase?text.toUpperCase():text,style: const TextStyle(color: Colors.white),),
  ),
);

Widget defaultTextFormField({
  required TextEditingController? controller,
  required TextInputType? keyboardType,
  Function(String)? onChanged,
  Function(String)? onSubmit,
  VoidCallback?onTap,
  required String? Function(String?)? validate,
  required String? label,
  required IconData? prefix,
  bool isPassword = false,
  IconData? suffix,
  Function()? suffixpressed,
})=>TextFormField(
  controller: controller,
  keyboardType: keyboardType,
  obscureText: isPassword,
  onChanged:onChanged,
  onFieldSubmitted:onSubmit,
  onTap: onTap,
  validator: validate,
  decoration: InputDecoration(
    prefixIcon: Icon(prefix),
    labelText: label,
    border: const OutlineInputBorder(),
    suffixIcon: suffix !=null?IconButton(icon: Icon(suffix),onPressed: suffixpressed,):null,

  ),
);

Widget defaultTasks(Map model,context)=>Dismissible(
  key: Key(model['id'].toString()),
  onDismissed: (direction){
    TodoCubit.get(context).deleteFromDatabase(id: model['id']);
  },
  child: Padding(
    padding: const EdgeInsets.all(10.0),
    child: Row(
  
      children: [
        CircleAvatar(
          radius: 40,
          child: Text('${model['time']}'),
        ),
        const SizedBox(width: 20,),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${model['tittle']}',style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
              Text('${model['date']}',style: TextStyle(color: Colors.grey[500],fontSize: 15),)
            ],
          ),
        ),
        const SizedBox(width: 20,),
        IconButton(onPressed: (){
          TodoCubit.get(context).updateDataFromDatabase(status: 'Done', id: model['id']);
        }, icon:const Icon(Icons.check_box,color: Colors.green,)),
        const SizedBox(width: 20,),
        IconButton(onPressed: (){
          TodoCubit.get(context).updateDataFromDatabase(status: 'Archive', id: model['id']);
        }, icon:const Icon(Icons.archive,color: Colors.black45,)),
      ],
    ),
  ),
);

Widget buildTask({
  required List<Map> tasks,
})=>ConditionalBuilder(
    condition: tasks.isNotEmpty,
    builder: (context)=>ListView.separated(
        itemBuilder: (context,index)=>defaultTasks(tasks[index],context),
        separatorBuilder: (context,index)=> mySeparator()
        ,itemCount: tasks.length),
    fallback: (context)=>const Center(
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




