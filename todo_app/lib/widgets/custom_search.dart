import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:todo_app/widgets/task_list_item.dart';

import '../data/local_storage.dart';
import '../main.dart';
import '../models/task_model.dart';

class CustomSearchDelegate extends SearchDelegate{

  final List<Task> allTasks;

  CustomSearchDelegate({required this.allTasks});

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(onPressed: (){
        query.isEmpty ? null : query = '';

        },
          icon: Icon(Icons.clear)),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return GestureDetector(
        onTap: (){
          close(context,null);
        },
        child: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: 24));
  }

  @override
  Widget buildResults(BuildContext context) {
    List<Task> filteredList = allTasks.where(
            (gorev) => gorev.name.toLowerCase().contains(query.toLowerCase())).toList();
    return filteredList.length > 0 ? ListView.builder(itemBuilder: (context,index){
      var _oankiListeElemani = filteredList[index];
      return Dismissible(
          background: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:  [
                const Icon(Icons.delete,color: Colors.grey,),
                const SizedBox(width: 8,),
                Text('remove_task').tr(),
              ]
          ),
          key: Key(_oankiListeElemani.id),
          onDismissed: (direction) async{
            filteredList.removeAt(index);
            await locator<LocalStorage>().deleteTask(task: _oankiListeElemani);

          },
          child: TaskItem(task: _oankiListeElemani,)
      );
    }, itemCount: filteredList.length,
    ) : Center(child: Text('search_not_found').tr(),);

  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }

}