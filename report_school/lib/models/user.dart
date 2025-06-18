class User {
  
  final String username;
  final double? rating;

  User({
    required this.username,
    this.rating,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'] ?? '',
      rating: json['rating'] != null ? (json['rating'] as num).toDouble() : null,
    );
  }
}
