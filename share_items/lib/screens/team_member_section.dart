import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:logger/logger.dart';
import 'package:share_items/api/api.dart';
import 'package:share_items/models/project.dart';
import 'package:share_items/screens/edit_project.dart';
import 'package:share_items/widgets/message.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../api/network.dart';
import '../services/database_helper.dart';

class TeamMembersSection extends StatefulWidget {
  @override
  _TeamMembersSectionState createState() => _TeamMembersSectionState();
}

class _TeamMembersSectionState extends State<TeamMembersSection> {
  var logger = Logger();
  bool online = true;
  late List<Project> inProgressProjects = [];
  bool isLoading = false;
  Map _source = {ConnectivityResult.none: false};
  final NetworkConnectivity _connectivity = NetworkConnectivity.instance;
  String string = '';

  @override
  void initState() {
    super.initState();
    connection();
  }

  void connection() {
    _connectivity.initialize();
    _connectivity.myStream.listen((source) {
      _source = source;
      var newStatus = true;
      switch (_source.keys.toList()[0]) {
        case ConnectivityResult.mobile:
          string =
          _source.values.toList()[0] ? 'Mobile: online' : 'Mobile: offline';
          break;
        case ConnectivityResult.wifi:
          string =
          _source.values.toList()[0] ? 'Wifi: online' : 'Wifi: offline';
          newStatus = _source.values.toList()[0] ? true : false;
          break;
        case ConnectivityResult.none:
        default:
          string = 'Offline';
          newStatus = false;
      }
      if (online != newStatus) {
        online = newStatus;
      }
      getInProgressProjects();
    });
  }

  getInProgressProjects() async {
    if (!mounted) return;
    setState(() {
      isLoading = true;
    });
    logger.log(Level.info, 'getInProgressProjects');
    try {
      if (online) {
        inProgressProjects = await ApiService.instance.getInProgressProjects();
      } else {
        message(context, "No internet connection", "Error");
      }
    } catch (e) {
      logger.log(Level.error, e.toString());
      message(context, "Error loading items from server", "Error");
    }
    setState(() {
      isLoading = false;
    });
  }

  updateMembers(Project project) async {
    if (!mounted) return;
    setState(() {
      isLoading = true;
    });
    logger.log(Level.info, 'updateMembers');
    try {
      if (online) {
        ApiService.instance.updateMembers(project.id!, project.members);
      } else {
        message(context, "No internet connection", "Error");
      }
    } catch (e) {
      logger.log(Level.error, e.toString());
      message(context, "Error updating members", "Error");
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Team Member section'),
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Center(
            child: ListView(children: [
              ListView.builder(
                itemCount: inProgressProjects.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(inProgressProjects[index].name),
                    subtitle: Text(
                        '${inProgressProjects[index].team}, ${inProgressProjects[index].details}, ${inProgressProjects[index].status}, members: ${inProgressProjects[index].members}, type: ${inProgressProjects[index].type}'),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: const BorderSide(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditProjectPage(
                                  project: inProgressProjects[index])))
                          .then((value) {
                        if (value != null) {
                          setState(() {
                            updateMembers(value);
                          });
                        }
                      });
                    },
                  );
                },
                physics: ScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                padding: const EdgeInsets.all(10),
              )
            ])));
  }

  @override
  void dispose() {
    super.dispose();
  }
}
