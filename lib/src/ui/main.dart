import 'package:flutter/material.dart';
import '../blocs/github_bloc.dart';
import 'package:hello_flutter/src/models/models.dart';

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
    myController.addListener(_printLatestValue);
  }

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  _printLatestValue() {
    bloc.getGithubUsers(myController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Github search'),
        ),
        body: Padding(
            padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
            child: Column(
              children: <Widget>[
                Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: TextField(
                      controller: myController,
                    )),
                StreamBuilder(
                    stream: bloc.gitUsers,
                    builder:
                        (context, AsyncSnapshot<GithubUserResponse> snapshot) {
                      if (snapshot.hasData) {
                        return buildList(snapshot);
                      } else if (snapshot.hasError) {
                        return Text(snapshot.error.toString());
                      }
                      return Center(child: CircularProgressIndicator());
                    })
              ],
            )));
  }

  Widget buildList(AsyncSnapshot<GithubUserResponse> snapshot) {
    return Expanded(
        child: ListView.builder(
            itemCount: snapshot.data.items.length,
            itemBuilder: (BuildContext ctxt, int index) {
              return Card(
                  child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(children: <Widget>[
                        ClipOval(
                            child: Image.network(
                                snapshot.data.items[index].avatarUrl,
                                width: 50,
                                height: 50)),
                        Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: Text(snapshot.data.items[index].login,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87))),
                        Expanded(
                            child: Text(
                          snapshot.data.items[index].score.toStringAsFixed(2),
                          textAlign: TextAlign.right,
                          style: TextStyle(color: Colors.black45),
                        ))
                      ])));
            }));
  }
}
