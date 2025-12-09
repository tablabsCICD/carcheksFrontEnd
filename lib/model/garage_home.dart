class Guarage_home {
  int? workInProgress;
  int? pending;
  int? newAppointment;
  int? numberOfRequest;
  int? completed;
  int? cancled;
  int? delivered;

  Guarage_home(
      {this.workInProgress,
        this.pending,
        this.newAppointment,
        this.numberOfRequest,
        this.completed,
        this.cancled,
        this.delivered});

  Guarage_home.fromJson(Map<String, dynamic> json) {
    workInProgress = json['workInProgress'];
    pending = json['pending'];
    newAppointment = json['newAppointment'];
    numberOfRequest = json['numberOfRequest'];
    completed = json['completed'];
    cancled = json['cancled'];
    delivered = json['delivered'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['workInProgress'] = this.workInProgress;
    data['pending'] = this.pending;
    data['newAppointment'] = this.newAppointment;
    data['numberOfRequest'] = this.numberOfRequest;
    data['completed'] = this.completed;
    data['cancled'] = this.cancled;
    data['delivered'] = this.delivered;
    return data;
  }
}