import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nba_teams/teams.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  List<Team> teams = [];

  Future getTeam() async {
    var respond = await http.get(Uri.parse('https://www.balldontlie.io/api/v1/teams'));
    var jsonData = jsonDecode(respond.body);

    for(var eachTeam in jsonData['data']) {
      final team = Team(abb: eachTeam['abbreviation'], cit: 'city');
      teams.add(team);
    }

    print(teams.length);
  }

  @override
  Widget build(BuildContext context) {
    getTeam();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 27, 120, 196),
        toolbarHeight: 70,
        title: Text(
          'NBA TEAMS',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: getTeam(),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.done){
            return ListView.builder(
              itemCount: teams.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: ListTile(
                      title: Text(teams[index].abb),
                      subtitle: Text(teams[index].cit),
                    ),
                  ),
                );
              },
            );
          }
          else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      )
    );
  }
}