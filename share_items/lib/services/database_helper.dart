import 'dart:io';

import 'package:logger/logger.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../models/project.dart';

class DatabaseHelper {
  static const int _version = 1;
  static const String _databaseName = 'project_manage.db';
  static Logger logger = Logger();

  static Future<Database> _getDB() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, _databaseName);
    return await openDatabase(path, version: _version,
        onCreate: (db, version) async {
      await db.execute(
          'CREATE TABLE projects(id INTEGER PRIMARY KEY, name TEXT, team TEXT, details TEXT, status TEXT, members INTEGER, type TEXT)');
      await db.execute(
          'CREATE TABLE project_names(id INTEGER PRIMARY KEY, name TEXT)');
    });
  }

  // get all projects
  static Future<List<Project>> getProjects() async {
    final db = await _getDB();
    final result = await db.query('projects');
    logger.log(Level.info, "getProjects: $result");
    return result.map((e) => Project.fromJson(e)).toList();
  }

  // get all projects names
  static Future<List<String>> getProjectsNames() async {
    final db = await _getDB();
    final result = await db.query('project_names');
    logger.log(Level.info, "getProjectsNames: $result");
    return result.map((e) => e['name'].toString()).toList();
  }

  // get projects by name
  static Future<List<Project>> getProjectsByName(String name) async {
    final db = await _getDB();
    final result =
        await db.query('projects', where: 'name = ?', whereArgs: [name]);
    logger.log(Level.info, "getProjectsByName: $result");
    return result.map((e) => Project.fromJson(e)).toList();
  }

  // add project
  static Future<Project> addProject(Project project) async {
    final db = await _getDB();
    final id = await db.insert('projects', project.toJsonWithoutId(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    logger.log(Level.info, "addProject: $id");
    return project.copy(id: id);
  }

  // update members if a project
  static Future<int> updateProject(int id, int members) async {
    final db = await _getDB();
    final result = await db.update('projects', {'members': members},
        where: 'id = ?', whereArgs: [id]);
    logger.log(Level.info, "updateProject: $result");
    return result;
  }

  // update project_names in database
  static Future<void> updateProjectNames(List<String> project_names) async {
    final db = await _getDB();
    await db.delete('project_names');
    for (var i = 0; i < project_names.length; i++) {
      await db.insert('project_names', {'name': project_names[i]});
    }
    logger.log(Level.info, "updateProjectNames: $project_names");
  }

  // update a project_names's project
  static Future<void> updateProjectNamesProject(
      String project_names, List<Project> projects) async {
    final db = await _getDB();
    await db.delete('projects', where: 'name = ?', whereArgs: [project_names]);
    for (var i = 0; i < projects.length; i++) {
      await db.insert('projects', projects[i].toJsonWithoutId());
    }
    logger.log(Level.info, "updateProjectNamesProject: $project_names, $projects");
  }

  // close database
  static Future<void> close() async {
    final db = await _getDB();
    await db.close();
  }
}
