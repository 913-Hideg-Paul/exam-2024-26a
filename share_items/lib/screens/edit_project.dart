import 'package:flutter/material.dart';
import 'package:share_items/widgets/message.dart';

import '../models/project.dart';

class EditProjectPage extends StatefulWidget {
  final Project project;

  const EditProjectPage({Key? key, required this.project}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _EditProjectState();
}

class _EditProjectState extends State<EditProjectPage> {
  late TextEditingController membersController;

  @override
  void initState() {
    membersController = TextEditingController(text: widget.project.members.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Members'),
      ),
      body: ListView(
        children: [
          Text('Name: ${widget.project.name}'),
          Text('Team: ${widget.project.team}'),
          Text('Details: ${widget.project.details}'),
          Text('Status: ${widget.project.status}'),
          Text('Type: ${widget.project.type}'),
          TextField(
            controller: membersController,
            decoration: const InputDecoration(
              labelText: 'Members',
            ),
          ),
          ElevatedButton(
              onPressed: () {
                int? members = int.tryParse(membersController.text);
                if (members != null) {
                  Navigator.pop(
                      context,
                      Project(
                        id: widget.project.id,
                        name: widget.project.name,
                        team: widget.project.team,
                        details: widget.project.details,
                        status: widget.project.status,
                        members: members.toInt(),
                        type: widget.project.type,
                      ));
                } else {
                  message(context, "Project must be a int", "Error");
                }
              },
              child: const Text('Save')),
        ],
      ),
    );
  }
}
