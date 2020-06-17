class User {
  User(this.id, this.name, this.photoUrl, this.createdAt);

  User.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String,
        name = json['name'] as String,
        photoUrl = json['photo_url'] as String,
        createdAt = json['created_at'] as DateTime;

  String id;
  String name;
  String photoUrl;
  DateTime createdAt;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
        'photo_url': photoUrl,
        'created_at': createdAt,
      };
}
