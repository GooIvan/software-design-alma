class User {
  final int id;
  final String email;
  final String? name;
  final String? phone;
  final String? address;
  final String? role;
  final String? lastName;
  final String? city;

  User({
    required this.id,
    required this.email,
    this.name,
    this.phone,
    this.address,
    this.role,
    this.lastName,
    this.city,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      email: json['email'] ?? '',
      name: json['name'],
      phone: json['phone'],
      address: json['address'],
      role: json['role'],
      lastName: json['last_name'],
      city: json['city'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      if (name != null) 'name': name,
      if (phone != null) 'phone': phone,
      if (address != null) 'address': address,
      if (role != null) 'role': role,
      if (lastName != null) 'last_name': lastName,
      if (city != null) 'city': city,
    };
  }
}
