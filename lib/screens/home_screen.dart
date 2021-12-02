import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:revup/forms/lead_form.dart';
import 'package:revup/models/lead.dart';
import 'package:revup/services/auth_service.dart';
import 'package:revup/services/cloud_firestore_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final cloudFirestoreService = Provider.of<CloudFirestoreService>(context);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
        ),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
            const Text('Read data from firestore'),
        Container(
          height: 250,
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: StreamBuilder(
              stream: cloudFirestoreService.leads,
              builder: (context, AsyncSnapshot<List<Lead>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return const Text('An error has occured');
                } else {
                  return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (_, index) {
                        return Text(snapshot.data![index].name);
                      });
                }
              }),
        ),
        const LeadForm(),
        Center(
        child: ElevatedButton(
        child: const Text('Logout'),
    onPressed: () async {
    await authService.signOut();
    },
    ),
    ),
    ],
    ),
    );
  }
}
