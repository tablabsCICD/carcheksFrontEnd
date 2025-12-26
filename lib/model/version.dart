class Version {
  int? id;
  String? version;

  Version({this.id, this.version});

  Version.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    version = json['version'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['version'] = version;
    return data;
  }
}
