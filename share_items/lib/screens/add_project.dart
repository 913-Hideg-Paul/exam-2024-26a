import 'package:flutter/material.dart';
import 'package:share_items/models/project.dart';
import 'package:share_items/widgets/message.dart';
import 'package:share_items/widgets/text_box.dart';

class AddProject extends StatefulWidget {
  const AddProject({super.key});

  @override
  State<StatefulWidget> createState() => _AddProjectState();
}

class _AddProjectState extends State<AddProject> {
  late TextEditingController nameController;
  late TextEditingController teamController;
  late TextEditingController detailsController;
  late TextEditingController statusController;
  late TextEditingController membersController;
  late TextEditingController typeController;

  @override
  void initState() {
    nameController = TextEditingController();
    teamController = TextEditingController();
    detailsController = TextEditingController();
    statusController = TextEditingController();
    membersController = TextEditingController();
    typeController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Item'),
      ),
      body: ListView(
        children: [
          TextBox(nameController, 'Name'),
          TextBox(teamController, 'Team'),
          TextBox(detailsController, 'Details'),
          TextBox(statusController, 'Status'),
          TextBox(membersController, 'Members'),
          TextBox(typeController, 'Type'),
          ElevatedButton(
              onPressed: () {
                String name = nameController.text;
                String team = teamController.text;
                String details = detailsController.text;
                String status = statusController.text;
                int? members = int.tryParse(membersController.text);
                String type = typeController.text;
                if (name.isNotEmpty &&
                    team.isNotEmpty &&
                    details.isNotEmpty &&
                    status.isNotEmpty &&
                    members != null &&
                    type.isNotEmpty) {
                  Navigator.pop(
                      context,
                      Project(
                          name: name,
                          team: team,
                          details: details,
                          status: status,
                          members: members,
                          type: type));
                } else {
                  if (name.isEmpty) {
                    message(context, 'Name is required', "Error");
                  } else if (team.isEmpty) {
                    message(context, 'Team is required', "Error");
                  } else if (details.isEmpty) {
                    message(context, 'Details is required', "Error");
                  } else if (status.isEmpty) {
                    message(context, 'Status is required', "Error");
                  } else if (members == null) {
                    message(context, 'Members must be an integer', "Error");
                  } else if (type.isEmpty) {
                    message(context, 'Type is required', "Error");
                  }
                }
              },
              child: const Text('Save'))
        ],
      ),
    );
  }
}
