import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../models/project.dart';

const String baseUrl = 'http://localhost:2426';

class ApiService {
  static final ApiService instance = ApiService._init();
  static final Dio dio = Dio();
  var logger = Logger();

  ApiService._init();

  Future<List<String>> getProjectNames() async {
    logger.log(Level.info, 'getProjectNames');
    final response = await dio.get('$baseUrl/projects');
    logger.log(Level.info, response.data);
    if (response.statusCode == 200) {
      final result = response.data as List;
      return result.map((e) => e.toString()).toList();
    } else {
      throw Exception(response.statusMessage);
    }
  }

  Future<List<Project>> getProjectsByProjectNames(String name) async {
    logger.log(Level.info, 'getProjectsByProjectNames');
    final response = await dio.get('$baseUrl/projects/$name');
    logger.log(Level.info, response.data);
    if (response.statusCode == 200) {
      final result = response.data as List;
      return result.map((e) => Project.fromJson(e)).toList();
    } else {
      throw Exception(response.statusMessage);
    }
  }

  Future<List<Project>> getInProgressProjects() async {
    logger.log(Level.info, 'getInProgressProjects');
    final response = await dio.get('$baseUrl/inProgress');
    logger.log(Level.info, response.data);
    if (response.statusCode == 200) {
      final result = response.data as List;
      var projects = result.map((e) => Project.fromJson(e)).toList();
      List<Project> inProgressEntities = projects.where((project) => project.status == "in progress").toList();
      // return projects that are in progress
      return inProgressEntities;
    } else {
      throw Exception(response.statusMessage);
    }
  }

  Future<List<Project>> getTop5Projects() async {
    logger.log(Level.info, 'getTop5Projects');
    final response = await dio.get('$baseUrl/allProjects');
    logger.log(Level.info, response.data);
    if (response.statusCode == 200) {
      final result = response.data as List;
      var projects = result.map((e) => Project.fromJson(e)).toList();
      /* // return top 5 projects sorted descending by nr of members and ascending by status

      projects.sort((a, b) => b.members.compareTo(a.members));
      return projects.sublist(0, 5); */

      projects.sort((a, b) {
        // Define the order of statuses
        Map<String, int> statusOrder = {
          "planning": 0,
          "in progress": 1,
          "completed": 2,
          "on hold": 3,
        };

        // Compare statuses in ascending order
        int statusComparison = statusOrder[a.status]!.compareTo(statusOrder[b.status]!);

        // If statuses are equal, sort by members in descending order
        return statusComparison == 0 ? b.members.compareTo(a.members) : statusComparison;
      });

      // Get the top 5 projects
      return projects.take(5).toList();
    } else {
      throw Exception(response.statusMessage);
    }
  }

  Future<Project> addProject(Project project) async {
    logger.log(Level.info, 'addProject: $project');
    final response =
        await dio.post('$baseUrl/project', data: project.toJsonWithoutId());
    logger.log(Level.info, response.data);
    if (response.statusCode == 200) {
      return Project.fromJson(response.data);
    } else {
      throw Exception(response.statusMessage);
    }
  }

  void updateMembers(int id, int members) async {
    logger.log(Level.info, 'updateMembers: $id, $members');
    final response =
        await dio.put('$baseUrl/enroll', data: {'id': id, 'members': members});
    logger.log(Level.info, response.data);
    if (response.statusCode != 200) {
      throw Exception(response.statusMessage);
    }
  }
}
