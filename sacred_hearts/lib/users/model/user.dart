class User {
  int log_id;
  String user_name;
  String email;
  String pword;
  int con_id;
  int province_id;

  User(this.log_id, this.user_name, this.email, this.pword, this.con_id, this.province_id);

  factory User.fromJson(Map<String, dynamic> json) => User(
    int.parse(json['log_id']),
    json['user_name'],
    json['email'],
    json['pword'],
    int.parse(json['con_id']),
    int.parse(json['province_id']),
  );
  Map<String, dynamic> toJson() => {
    'log_id' : log_id.toString(),
    'user_name' : user_name,
    'email' : email,
    'pword' : pword,
    'con_id' : con_id.toString(),
    'province_id' : province_id.toString(),
  };
}
