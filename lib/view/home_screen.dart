import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todo_app/controller/formController.dart';
import 'package:todo_app/sixeConfig.dart';
import 'package:todo_app/view/details.dart';
import 'package:todo_app/widgets/widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void dialogShow(bool isUpdate, {dynamic ds}) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: isUpdate ? Text("Update Todo") : Text("Add Todo"),
        content: Form(
          key: formController.formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextFormField(
                  autofocus: true,
                  controller: formController.titleController,
                  validator: (_val) {
                    if (_val!.isEmpty) {
                      return formController.emptyValid;
                    }
                    return null;
                  },
                  keyboardType: cWidgets.text(),
                  decoration: cWidgets.inputDecoration(
                    lableText: 'Title',
                    hintText: 'Enter Title',
                  ),
                ),
                cWidgets.sizedBox(height: sizeConfig.mediumSize),
                TextFormField(
                  autofocus: true,
                  controller: formController.contentController,
                  validator: (_val) {
                    if (_val!.isEmpty) {
                      return formController.emptyValid;
                    }
                    return null;
                  },
                  keyboardType: cWidgets.text(),
                  decoration: cWidgets.inputDecoration(
                    lableText: 'Content',
                    hintText: 'Enter Task Content',
                  ),
                  maxLines: 5,
                ),
              ],
            ),
          ),
        ),
        actions: [
          SizedBox(
            height: sizeConfig.defaultSize,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 13),
              child: cWidgets.elevatedButton(
                press: () {
                  if (formController.formKey.currentState!.validate()) {
                    formController.title = formController.titleController.text;
                    formController.content =
                        formController.contentController.text;
                    if (isUpdate == true) {
                      formController.db.collection("tasks").doc(ds.id).update({
                        'title': formController.title,
                        'content': formController.content,
                        'time': DateTime.now(),
                      });
                    }
                    if (isUpdate == false) {
                      formController.db.collection("tasks").add({
                        'title': formController.title,
                        'content': formController.content,
                        'time': DateTime.now(),
                      });
                    }
                    formController.titleController.clear();
                    formController.contentController.clear();
                    Navigator.pop(context);
                  }
                },
                text: isUpdate ? "Update" : "Add",
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    formController.titleController.dispose();
    formController.contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<dynamic>(
        stream: formController.db.collection("tasks").snapshots(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            return SafeArea(
              child: ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final _datas = snapshot.data!.docs[index];
                    return InkWell(
                      onLongPress: () {
                        formController.db
                            .collection('tasks')
                            .doc(_datas.id)
                            .delete();
                      },
                      onTap: () => dialogShow(true, ds: _datas),
                      child: Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: sizeConfig.mediumSize,
                            vertical: sizeConfig.mediumSize),
                        height: sizeConfig.defaultSize * 3.1,
                        padding: EdgeInsets.symmetric(
                            horizontal: sizeConfig.mediumSize,
                            vertical: sizeConfig.mediumSize),
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(sizeConfig.largeSize),
                            color: Colors.blueGrey),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(_datas['title'],
                                  style: Theme.of(context).textTheme.headline4),
                              SizedBox(
                                height: sizeConfig.smallSize,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _datas['content'],
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  ),
                                  IconButton(
                                    onPressed: () => Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                DetailsScreen(data: _datas))),
                                    icon: Icon(
                                      Icons.info,
                                    ),
                                    tooltip: 'Info',
                                  )
                                ],
                              ),
                            ]),
                      ),
                    );
                  }),
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
