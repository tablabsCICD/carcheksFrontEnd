import 'garage_model.dart';
import 'user_table_model.dart';

class ReviewModel {
  String? message;
  List<Review>? data;
  bool? success;

  ReviewModel({this.message, this.data, this.success});

  ReviewModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <Review>[];
      json['data'].forEach((v) {
        data!.add(new Review.fromJson(v));
      });
    }
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['success'] = this.success;
    return data;

  }
}

class Review {
  int? id;
  String? created;
  String? createdBy;
  String? updated;
  String? updatedBy;
  bool? active;
  int? rating;
  String? comments;
  bool? verified;
  User? userTable;
  Garage? garrageCr;

  Review(
      {this.id,
        this.created,
        this.createdBy,
        this.updated,
        this.updatedBy,
        this.active,
        this.rating,
        this.comments,
        this.verified,
        this.userTable,
        this.garrageCr,
      });

  Review.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    created = json['created'];
    createdBy = json['createdBy'];
    updated = json['updated'];
    updatedBy = json['updatedBy'];
    active = json['active'];
    rating = json['rating'];
    comments = json['comments'];
    verified = json['verified'];
    userTable = json['userTable'] != null
        ? new User.fromJson(json['userTable'])
        : null;
    garrageCr = json['garrageCr'] != null
        ? new Garage.fromJson(json['garrageCr'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created'] = this.created;
    data['createdBy'] = this.createdBy;
    data['updated'] = this.updated;
    data['updatedBy'] = this.updatedBy;
    data['active'] = this.active;
    data['rating'] = this.rating;
    data['comments'] = this.comments;
    data['verified'] = this.verified;
    if (this.userTable != null) {
      data['userTable'] = this.userTable!.toJson();
    }
    if (this.garrageCr != null) {
      data['garrageCr'] = this.garrageCr!.toJson();
    }
    return data;
  }
}

