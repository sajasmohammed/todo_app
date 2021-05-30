
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/controller/formController.dart';
import 'package:todo_app/sixeConfig.dart';
import 'package:todo_app/widgets/alert_dialog.dart';
import 'package:todo_app/widgets/widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // QuerySnapshot<Object?>? get ds => null;
 // QueryDocumentSnapshot<Object?>? ds;
  // DocumentSnapshot? ds;

  void dialogShow(bool isUpdate, {dynamic ds}) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: isUpdate ? Text("Update Todo") : Text("Add Todo"),
        content: Form(
          key: formController.formKey,
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
              ),
            ],
          ),
        ),
        actions: [
          SizedBox(
            height: sizeConfig.mediumSize * 4,
            width: double.infinity,
            child: cWidgets.elevatedButton(
              press: () {
                if (formController.formKey.currentState!.validate()) {
                  formController.title = formController.titleController.text;
                  formController.content =
                      formController.contentController.text;
                  if (isUpdate == true) {
                    formController.db.collection("tasks").doc(ds.id).update({
                      'title': formController.title,
                      'content': formController.content
                    });
                  } 
                  if(isUpdate == false) {
                    formController.db.collection("tasks").add({
                      'title': formController.title,
                      'content': formController.content
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
      appBar: AppBar(
        title: Text("Todo App"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: formController.db.collection("tasks").snapshots(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot _datas = snapshot.data!.docs[index];
                  return InkWell(
                    onLongPress: () {
                      formController.db
                          .collection('tasks')
                          .doc(_datas.id)
                          .delete();
                    },
                    onTap: () => dialogShow(true, ds: _datas),
                    child: Container(
                      child: Column(children: [
                        Text(_datas['title']),
                        Text(_datas['content']),
                      ]),
                    ),
                  );
                });
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => dialogShow(false),
        child: Icon(Icons.add),
      ),
    );
  }
}
