class AppUser {
  String uid;
  String email;
  String name;
  String? photoUrl;
  String? phone;
  String? address;

  AppUser(
    this.uid,
    this.email,
    this.name, {
    this.phone,
    this.address,
    this.photoUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'photoUrl': photoUrl,
      'phone': phone,
      'address': address,
    };
  }

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      json['uid'],
      json['email'],
      json['name'],
      phone: json['phone'],
      address: json['address'],
      photoUrl: json['photoUrl'],
    );
  }
}
