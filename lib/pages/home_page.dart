import 'package:flutter/material.dart';
import 'package:flutter_nodejs/services/api_services.dart';
import 'package:flutter_nodejs/services/shared_service.dart';
class HomePage extends StatefulWidget {
  const HomePage({ Key? key }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FLUTTER JWT NODE'),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              SharedService.logout(context);
            },
            icon: const Icon(Icons.logout),
            color: Colors.black,
            )
        ],
      ),
      backgroundColor: Colors.grey[200],
      body: userProfile(),
    );
  }

  Widget userProfile(){
    return FutureBuilder(
      future: APIService.getUserProfile(),
      builder: (BuildContext context, AsyncSnapshot<String> model){
        if(model.hasData){
          return Center(
            child: Text(model.data!),
          );
        }

        return const Center(
          child: CircularProgressIndicator(),
        );
      }
      );
  }
}