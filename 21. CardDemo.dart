import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    // 카드_Material library
    Widget _buildCard() {
      return SizedBox(
        height: 210,
        child: Card(
          child: Column(
            children: [
              ListTile(
                title: const Text(
                  '1625 Main Street',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                subtitle: const Text('My City, CA 99984'),
                leading: Icon(
                  Icons.home_filled,
                  color: Colors.blue[500],
                ),
              ),
              const Divider(),
              ListTile(
                title: const Text(
                  '(777) 777-7777',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                leading: Icon(
                  Icons.contact_phone,
                  color: Colors.blue[500],
                ),
              ),
              ListTile(
                title: const Text('Hyeok@example.com'),
                leading: Icon(
                  Icons.contact_mail,
                  color: Colors.blue[500],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return MaterialApp(
        title: 'CardDemo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          //primaryColor: Colors.white,
        ),

        home: Scaffold(
          appBar: AppBar(title: Text('Card')),
          body: _buildCard(),
        ));
  }
}
