import 'package:flutter/material.dart';
import 'package:hello_flutter/src/models/models.dart';
import '../blocs/github_bloc.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final myController = TextEditingController();

  @override
  void initState() {
    super.initState();

    myController.addListener(_getGithubUsers());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Github search'),
        ),
        body: Column(
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: myController,
                )),
            new StreamBuilder(
                stream: bloc.gitUsers,
                builder: (context, AsyncSnapshot<GithubUserResponse> snapshot) {
                  if (snapshot.hasData) {
                    return buildList(snapshot);
                  } else if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  }
                  return Center(child: CircularProgressIndicator());
                })
//            new Expanded(
//                child: ListView.builder(
//                    itemCount: 10,
//                    itemBuilder: (BuildContext ctxt, int index) {
//                      return Card(child: Text("Hello"));
//                    }))
          ],
        ));
  }

  Widget buildList(AsyncSnapshot<GithubUserResponse> snapshot) {
    return Expanded(
        child: ListView.builder(
            itemCount: snapshot.data.items.length,
            itemBuilder: (BuildContext ctxt, int index) {
              return Card(
                  child: Text(snapshot.data.items[index].id.toString()));
            }));
  }

  _getGithubUsers() {
    bloc.getGithubUsers(myController.text);
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myController.dispose();
    super.dispose();
  }
}
