class Project {
  int? id;
  String name;
  String team;
  String details;
  String status;
  int members;
  String type;

  Project({
    this.id,
    required this.name,
    required this.team,
    required this.details,
    required this.status,
    required this.members,
    required this.type,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
        id: json['id'] as int?,
        name: json['name'] as String,
        team: json['team'] as String,
        details: json['details'] as String,
        status: json['status']  as String,
        members: json['members'] as int,
        type: json['type'] as String);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'team': team,
      'details': details,
      'status': status,
      'members': members,
      'type': type
    };
  }

  Map<String, dynamic> toJsonWithoutId() {
    return {
      'name': name,
      'team': team,
      'details': details,
      'status': status,
      'members': members,
      'type': type
    };
  }

  Project copy({
    int? id,
    String? name,
    String? team,
    String? details,
    String? status,
    int? members,
    String? type,
  }) {
    return Project(
      id: id ?? this.id,
      name: name ?? this.name,
      team: team ?? this.team,
      details: details ?? this.details,
      status: status ?? this.status,
      members: members ?? this.members,
      type: type ?? this.type
    );
  }

  @override
  String toString() {
    return 'Project with name: $name, team: $team, details: $details, status: $status, members: $members, type: $type';
  }
}
