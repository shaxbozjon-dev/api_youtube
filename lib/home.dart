import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'model.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<MyModel> currencyList = [];
  // https://fakestoreapi.com/products

  Future<List<MyModel> > getApi() async {
    final uri = Uri.parse("https://fakestoreapi.com/products");

    final request = await http.get(uri).then((value) {
      try {

        if (value.statusCode == 200) {
          var data = jsonDecode(value.body);
          data.forEach((element) {
            currencyList.add(MyModel.fromJson(element));
          });
          return currencyList;
        } else {

          throw(Exception());
        }


      } catch (e) {
        rethrow;
      }
    });

    return currencyList;

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getApi();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold
      (
      appBar: AppBar(
        title: Text("Rest API Call"),
      ),
      body: StreamBuilder<List<MyModel> >(
          stream: getApi().asStream(),
          builder: (context, AsyncSnapshot<List<MyModel> > snapshot) {
            if(snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.requireData.length,
                  itemBuilder: (context, index) {


                    return ListTile(

                      title: Text(snapshot.data?[index].title ??""),
                      trailing: Icon(Icons.account_balance),
                      leading: Image.network(snapshot.data?[index].image ?? ""),
                    );
                  });
            }
            else {
              return Center(child: CircularProgressIndicator(),);
            }
          }
      ),

    );
  }


}