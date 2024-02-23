class User {
  String name;
  int age;
  String email;

  User({
    required this.name,
    required this.age,
    required this.email,
  });

  // Fabrika yöntemi ile JSON'dan kullanıcı oluşturma
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      age: json['age'],
      email: json['email'],
    );
  }

  // Kullanıcı bilgilerini JSON formatına dönüştürme
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'age': age,
      'email': email,
    };
  }
}
