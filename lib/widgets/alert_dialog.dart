import 'package:flutter/material.dart';
import 'package:todo_app/controller/formController.dart';
import 'package:todo_app/sixeConfig.dart';
import 'package:todo_app/widgets/widgets.dart';

class AlertDialogWidget extends StatelessWidget {
  const AlertDialogWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: Text("Add Todo"),
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
            height: sizeConfig.mediumSize*4,
            width: double.infinity,
            child: cWidgets.elevatedButton(
              press: () {
                if (formController.formKey.currentState!.validate()) {
                  formController.title = formController.titleController.text;
                  formController.content = formController.contentController.text;
                  formController.db.collection("tasks").add({
                    'title': formController.title,
                    'content': formController.content
                  });
                  formController.titleController.clear();
                  formController.contentController.clear();
                  Navigator.pop(context);
                }
              },
              text: "Add",
            ),
          ),
        ],
      );
}
