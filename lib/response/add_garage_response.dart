class AutoGenerate {
  AutoGenerate({
    required this.message,
    required this.data,
    required this.success,
  });
  late final String message;
  late final Data data;
  late final bool success;

  AutoGenerate.fromJson(Map<String, dynamic> json){
    message = json['message'];
    data = Data.fromJson(json['data']);
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['message'] = message;
    _data['data'] = data.toJson();
    _data['success'] = success;
    return _data;
  }
}

class Data {
  Data({
    required this.id,
    required this.created,
    required this.createdBy,
    required this.updated,
    required this.updatedBy,
    required this.active,
    required this.name,
    required this.emailId,
    required this.contactNumber,
    required this.location,
    required this.imageUrl,
    required this.photos,
    required this.userId,
    required this.addressId,
    required this.verified,
    required this.verificatiionId,
    required this.websiteUrl,
    required this.password,
    required this.openingTime,
    required this.closingTime,
    required this.latitude,
    required this.longitude,
    required this.rating,
    required this.noOfRating,
    required this.discription,
    required this.populer,
  });
  late final int id;
  late final String created;
  late final String createdBy;
  late final String updated;
  late final String updatedBy;
  late final bool active;
  late final String name;
  late final String emailId;
  late final String contactNumber;
  late final int location;
  late final String imageUrl;
  late final String photos;
  late final int userId;
  late final int addressId;
  late final bool verified;
  late final String verificatiionId;
  late final String websiteUrl;
  late final String password;
  late final String openingTime;
  late final String closingTime;
  late final String latitude;
  late final String longitude;
  late final double rating;
  late final int noOfRating;
  late final String discription;
  late final bool populer;

  Data.fromJson(Map<String, dynamic> json){
    id = json['id'];
    created = json['created'];
    createdBy = json['createdBy'];
    updated = json['updated'];
    updatedBy = json['updatedBy'];
    active = json['active'];
    name = json['name'];
    emailId = json['emailId'];
    contactNumber = json['contactNumber'];
    location = json['location'];
    imageUrl = json['imageUrl'];
    photos = json['photos'];
    userId = json['userId'];
    addressId = json['addressId'];
    verified = json['verified'];
    verificatiionId = json['verificatiionId'];
    websiteUrl = json['websiteUrl'];
    password = json['password'];
    openingTime = json['openingTime'];
    closingTime = json['closingTime'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    rating = json['rating'];
    noOfRating = json['noOfRating'];
    discription = json['discription'];
    populer = json['populer'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['created'] = created;
    _data['createdBy'] = createdBy;
    _data['updated'] = updated;
    _data['updatedBy'] = updatedBy;
    _data['active'] = active;
    _data['name'] = name;
    _data['emailId'] = emailId;
    _data['contactNumber'] = contactNumber;
    _data['location'] = location;
    _data['imageUrl'] = imageUrl;
    _data['photos'] = photos;
    _data['userId'] = userId;
    _data['addressId'] = addressId;
    _data['verified'] = verified;
    _data['verificatiionId'] = verificatiionId;
    _data['websiteUrl'] = websiteUrl;
    _data['password'] = password;
    _data['openingTime'] = openingTime;
    _data['closingTime'] = closingTime;
    _data['latitude'] = latitude;
    _data['longitude'] = longitude;
    _data['rating'] = rating;
    _data['noOfRating'] = noOfRating;
    _data['discription'] = discription;
    _data['populer'] = populer;
    return _data;
  }
}