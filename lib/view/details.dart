import 'package:flutter/material.dart';
import 'package:todo_app/sixeConfig.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({Key? key, required data}) : _data=data, super(key: key);

  final _data;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_data['title'], style: Theme.of(context).textTheme.headline4,),
              SizedBox(
                height: sizeConfig.mediumSize,
              ),
              Text(_data['content'], style: Theme.of(context).textTheme.bodyText1, textAlign: TextAlign.center,),
            ],
          ),
        ),
      ),
    );
  }
}
