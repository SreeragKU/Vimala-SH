class Members {
  int user_id;
  int log_id;
  String user_name;
  String official_name;
  String baptism_name;
  String pet_name;
  String school_name;
  String church_dob;
  String school_dob;
  String birth_place;
  String baptism_place;
  String baptism_date;
  String confirmation_date;
  String confirmation_place;
  String img_url;
  String ph_no;
  String date_first_profession;
  String date_final_profession;
  String date_begin_service;
  String date_retire;
  int role_id;
  int con_id;
  String position;
  String tdate;
  String dod;
  int status;

  Members(
      this.user_id,
      this.log_id,
      this.user_name,
      this.official_name,
      this.baptism_name,
      this.pet_name,
      this.school_name,
      this.church_dob,
      this.school_dob,
      this.birth_place,
      this.baptism_place,
      this.baptism_date,
      this.confirmation_date,
      this.confirmation_place,
      this.img_url,
      this.ph_no,
      this.date_first_profession,
      this.date_final_profession,
      this.date_begin_service,
      this.date_retire,
      this.role_id,
      this.con_id,
      this.position,
      this.tdate,
      this.dod,
      this.status,
      );

  factory Members.fromJson(Map<String, dynamic> json) => Members(
    int.parse(json['user_id']),
    int.parse(json['log_id']),
    json['user_name'],
    json['official_name'],
    json['baptism_name'],
    json['pet_name'],
    json['school_name'],
    json['church_dob'],
    json['school_dob'],
    json['birth_place'],
    json['baptism_place'],
    json['baptism_date'],
    json['confirmation_date'],
    json['confirmation_place'],
    json['img_url'],
    json['ph_no'],
    json['date_first_profession'],
    json['date_final_profession'],
    json['date_begin_service'],
    json['date_retire'],
    int.parse(json['role_id']),
    int.parse(json['con_id']),
    json['position'],
    json['tdate'],
    json['dod'],
    int.parse(json['status']),
  );

  Map<String, dynamic> toJson() => {
    'user_id': user_id.toString(),
    'log_id': log_id.toString(),
    'user_name': user_name,
    'official_name': official_name,
    'baptism_name': baptism_name,
    'pet_name': pet_name,
    'school_name': school_name,
    'church_dob': church_dob,
    'school_dob': school_dob,
    'birth_place': birth_place,
    'baptism_place': baptism_place,
    'baptism_date': baptism_date,
    'confirmation_date': confirmation_date,
    'confirmation_place': confirmation_place,
    'img_url': img_url,
    'ph_no': ph_no,
    'date_first_profession': date_first_profession,
    'date_final_profession': date_final_profession,
    'date_begin_service': date_begin_service,
    'date_retire': date_retire,
    'role_id': role_id.toString(),
    'con_id': con_id.toString(),
    'position': position,
    'tdate': tdate,
    'dod': dod,
    'status': status.toString(),
  };
}
