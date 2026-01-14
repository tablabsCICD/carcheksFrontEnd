class Guarage_home {
  int? workInProgress;
  int? newAppointment;
  int? numberOfRequest;
  int? completed;
  int? cancled;

  Guarage_home({
    this.workInProgress,
    this.newAppointment,
    this.numberOfRequest,
    this.completed,
    this.cancled,
  });

  Guarage_home.fromJson(Map<String, dynamic> json) {
    workInProgress = json['workInProgress'];
    newAppointment = json['newAppointment'];
    numberOfRequest = json['numberOfRequest'];
    completed = json['completed'];
    cancled = json['cancled'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['workInProgress'] = this.workInProgress;
    data['newAppointment'] = this.newAppointment;
    data['numberOfRequest'] = this.numberOfRequest;
    data['completed'] = this.completed;
    data['cancled'] = this.cancled;
    return data;
  }
}
