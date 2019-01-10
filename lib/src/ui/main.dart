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
    if (myController.text != "") bloc.getGithubUsers(myController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//        appBar: AppBar(
//          title: Text('Github search'),
//        ),
        body: new Container(
            decoration: new BoxDecoration(color: Colors.white),
            child: Padding(
                padding: const EdgeInsets.only(top: 38.0, left: 16.0, right: 16.0),
                child: Column(
                  children: <Widget>[
                    new Container(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: TextField(
                          decoration: new InputDecoration(
                              hintText: 'Search for github user.....',
                              prefixIcon: Icon(Icons.search),
                              border: null,
                              filled: true,
                              enabledBorder: new UnderlineInputBorder(
                                  borderSide:
                                      new BorderSide(color: Colors.white)),
                              focusedBorder: new UnderlineInputBorder(
                                  borderSide:
                                      new BorderSide(color: Colors.white))),
                          controller: myController,
                        )),
                    StreamBuilder(
                        stream: bloc.gitUser,
                        builder: (context, AsyncSnapshot<Response<GithubUserResponse>> snapshot) {
                          if (snapshot.hasError) {
                            return Text(snapshot.error.toString());
                          } else if (snapshot.hasData) {
                            switch (snapshot.data.state) {
                              case ViewState.LOADING:
                                {
                                  return Center(
                                      child: CircularProgressIndicator());
                                }
                              case ViewState.SUCCESS:
                                {
                                  if (myController.text.trim() == "")
                                    return new Container();
                                  else
                                    return buildList(snapshot, context);
                                  break;
                                }
                              case ViewState.ERROR:
                                {
                                  Scaffold.of(context)
                                      .showSnackBar(new SnackBar(
                                    content: new Text(
                                        "Error in fetching data for ${myController.text}"),
                                  ));
                                  return new Container();
                                }
                            }
                          }
                          return new Container();
                        })
                  ],
                ))));
  }

  Widget buildList(AsyncSnapshot<Response<GithubUserResponse>> snapshot, BuildContext context) {
    return Expanded(
        child: MediaQuery.removePadding(context: context, removeTop: true, child: ListView.builder(
            itemCount: snapshot.data.data.items.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                  child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(children: <Widget>[
                        ClipOval(
                            child: Image.network(
                                snapshot.data.data.items[index].avatarUrl,
                                width: 50,
                                height: 50)),
                        Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: Text(snapshot.data.data.items[index].login,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87))),
                        Expanded(
                            child: Text(
                              snapshot.data.data.items[index].score
                                  .toStringAsFixed(2),
                              textAlign: TextAlign.right,
                              style: TextStyle(color: Colors.black45),
                            ))
                      ])));
            })));
  }
}
