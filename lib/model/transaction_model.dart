class TransactionPayment {
  TransactionPayment({
    required this.id,
    required this.created,
    required this.createdBy,
    required this.updated,
    required this.updatedBy,
    required this.active,
    this.userOrder,
    required this.transcationStatus,
    required this.transcationDiscrption,
  });
  late final int id;
  late final String created;
  late final String createdBy;
  late final String updated;
  late final String updatedBy;
  late final bool active;
  late final Null userOrder;
  late final String transcationStatus;
  late final String transcationDiscrption;

  TransactionPayment.fromJson(Map<String, dynamic> json){
    id = json['id'];
    created = json['created'];
    createdBy = json['created_by'];
    updated = json['updated'];
    updatedBy = json['updated_by'];
    active = json['active'];
    userOrder = null;
    transcationStatus = json['transcation_status'];
    transcationDiscrption = json['transcation_discrption'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['created'] = created;
    _data['created_by'] = createdBy;
    _data['updated'] = updated;
    _data['updated_by'] = updatedBy;
    _data['active'] = active;
    _data['userOrder'] = userOrder;
    _data['transcation_status'] = transcationStatus;
    _data['transcation_discrption'] = transcationDiscrption;
    return _data;
  }
}