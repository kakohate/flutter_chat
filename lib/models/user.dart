class User {
  const User(
    this.uid,
    this.createdAt,
    this.name, {
    this.photoUrl,
    this.email,
    this.phoneNumber,
  });

  User.fromJson(Map<String, dynamic> json)
      : uid = json['uid'] as String,
        createdAt = json['created_at'] as DateTime,
        name = json['name'] as String,
        photoUrl = json['photo_url'] as String,
        email = json['email'] as String,
        phoneNumber = json['phone_number'] as String;

  final String uid;
  final DateTime createdAt;
  final String name;
  final String photoUrl;
  final String email;
  final String phoneNumber;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'uid': uid,
        'created_at': createdAt,
        'name': name,
        'photo_url': photoUrl,
        'email': email,
        'phone_number': phoneNumber,
      };
}
