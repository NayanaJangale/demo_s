import 'package:student/handlers/string_handlers.dart';

class Student {
  int stud_no;
  String student_name;
  String stud_fullname;
  String student_mname;
  String mother_name;
  String gender;
  DateTime birth_date;
  int section_id;
  int class_id;
  String class_name;
  int division_id;
  String division_name;
  int yr_no;
  String academic_year;
  String mobile_no;
  String mobile_no_1;
  String brcode;
  String client_code;
  String email_id ;
  String city;
  String dist;
  String taluka;
  String bgroup;
  String stud_address;
  String aadhar_no;
  String bankCode;
  String reg_no;

  Student({
    this.stud_no,
    this.student_name,
    this.stud_fullname,
    this.student_mname,
    this. mother_name,
    this.gender,
    this.birth_date,
    this.section_id,
    this.class_id,
    this.class_name,
    this.division_id,
    this.division_name,
    this.yr_no,
    this.academic_year,
    this.mobile_no,
    this.mobile_no_1,
    this.brcode,
    this.client_code,
    this.email_id ,
    this.city,
    this.dist,
    this.taluka,
    this. bgroup,
    this.stud_address,
    this.aadhar_no,
    this.bankCode,
    this.reg_no,
  });

  Student.fromMap(Map<String, dynamic> map) {
    stud_no = map[StudentFieldNames.stud_no] ?? 0;
    student_name = map[StudentFieldNames.student_name] ?? StringHandlers.NotAvailable;
    stud_fullname = map[StudentFieldNames.stud_fullname] ?? StringHandlers.NotAvailable;
    student_mname = map[StudentFieldNames.student_mname] ?? StringHandlers.NotAvailable;
    mother_name = map[StudentFieldNames.mother_name] ?? StringHandlers.NotAvailable;
    gender = map[StudentFieldNames.gender] ?? StringHandlers.NotAvailable;
    birth_date = map[StudentFieldNames.birth_date] != null && map[StudentFieldNames.birth_date].toString().trim() != ''? DateTime.parse(map[StudentFieldNames.birth_date]):null;
    section_id = map[StudentFieldNames.section_id] ?? 0;
    class_id = map[StudentFieldNames.class_id] ?? 0;
    class_name = map[StudentFieldNames.class_name] ?? StringHandlers.NotAvailable;
    division_id = map[StudentFieldNames.division_id] ?? 0;
    division_name = map[StudentFieldNames.division_name] ?? StringHandlers.NotAvailable;
    yr_no = map[StudentFieldNames.yr_no] ?? 0;
    academic_year = map[StudentFieldNames.academic_year]  ?? StringHandlers.NotAvailable;
    mobile_no = map[StudentFieldNames.mobile_no]  ?? StringHandlers.NotAvailable;
    brcode = map[StudentFieldNames.brcode] ?? StringHandlers.NotAvailable;
    client_code = map[StudentFieldNames.client_code] ?? StringHandlers.NotAvailable;
    email_id = map[StudentFieldNames.email_id] ?? StringHandlers.NotAvailable;
    city = map[StudentFieldNames.city] ?? StringHandlers.NotAvailable;
    dist = map[StudentFieldNames.dist] ?? StringHandlers.NotAvailable;
    bgroup = map[StudentFieldNames.bgroup] ?? StringHandlers.NotAvailable;
    stud_address = map[StudentFieldNames.stud_address] ?? StringHandlers.NotAvailable;
    aadhar_no = map[StudentFieldNames.aadhar_no] ?? StringHandlers.NotAvailable;
    bankCode = map[StudentFieldNames.bankCode] ?? StringHandlers.NotAvailable;
    reg_no = map[StudentFieldNames.reg_no] ?? StringHandlers.NotAvailable;
  }
  Student.fromMapProfile(Map<String, dynamic> map) {
    stud_no = map[StudentFieldNames.stud_no] ?? 0;
    student_name = map[StudentFieldNames.student_name] ?? StringHandlers.NotAvailable;
    stud_fullname = map[StudentFieldNames.stud_fullname] ?? StringHandlers.NotAvailable;
    student_mname = map[StudentFieldNames.student_mname] ?? StringHandlers.NotAvailable;
    mother_name = map[StudentFieldNames.mother_name] ?? StringHandlers.NotAvailable;
    gender = map[StudentFieldNames.gender] ?? StringHandlers.NotAvailable;
    birth_date = map[StudentFieldNames.birth_date] != null && map[StudentFieldNames.birth_date].toString().trim() != ''? DateTime.parse(map[StudentFieldNames.birth_date]):null;
    section_id = map[StudentFieldNames.section_id] ?? 0;
    class_id = map[StudentFieldNames.class_id] ?? 0;
    class_name = map[StudentFieldNames.class_name] ?? StringHandlers.NotAvailable;
    division_id = map[StudentFieldNames.division_id] ?? 0;
    division_name = map[StudentFieldNames.division_name] ?? StringHandlers.NotAvailable;
    yr_no = map[StudentFieldNames.yr_no] ?? 0;
    academic_year = map[StudentFieldNames.academic_year]  ?? StringHandlers.NotAvailable;
    mobile_no = map[StudentFieldNames.mobile_no]  ?? StringHandlers.NotAvailable;
    mobile_no_1 = map[StudentFieldNames.mobile_no_1]  ?? StringHandlers.NotAvailable;
    brcode = map[StudentFieldNames.brcode] ?? StringHandlers.NotAvailable;
    client_code = map[StudentFieldNames.client_code] ?? StringHandlers.NotAvailable;
    email_id = map[StudentFieldNames.email_id] ?? StringHandlers.NotAvailable;
    city = map[StudentFieldNames.city] ?? StringHandlers.NotAvailable;
    dist = map[StudentFieldNames.dist] ?? StringHandlers.NotAvailable;
    taluka = map[StudentFieldNames.taluka] ?? StringHandlers.NotAvailable;
    bgroup = map[StudentFieldNames.bgroup] ?? StringHandlers.NotAvailable;
    stud_address = map[StudentFieldNames.stud_address] ?? StringHandlers.NotAvailable;
    aadhar_no = map[StudentFieldNames.aadhar_no] ?? StringHandlers.NotAvailable;
    bankCode = map[StudentFieldNames.bankCode] ?? StringHandlers.NotAvailable;
    reg_no = map[StudentFieldNames.reg_no] ?? StringHandlers.NotAvailable;
  }


  Map<String, dynamic> toJson() =>
      <String, dynamic>{
        StudentFieldNames.stud_no: stud_no,
        StudentFieldNames.student_name: student_name,
        StudentFieldNames.stud_fullname: stud_fullname,
        StudentFieldNames.student_mname: student_mname,
        StudentFieldNames.mother_name: mother_name,
        StudentFieldNames.gender: gender,
        StudentFieldNames.birth_date: birth_date == null ? null : birth_date.toIso8601String(),
        StudentFieldNames.section_id: section_id,
        StudentFieldNames.class_id: class_id,
        StudentFieldNames.class_name: class_name,
        StudentFieldNames.division_id: division_id,
        StudentFieldNames.division_name: division_name,
        StudentFieldNames.yr_no: yr_no,
        StudentFieldNames.academic_year: academic_year,
        StudentFieldNames.mobile_no: mobile_no,
        StudentFieldNames.brcode: brcode,
        StudentFieldNames.client_code: client_code,
        StudentFieldNames.email_id: email_id,
        StudentFieldNames.city: city,
        StudentFieldNames.dist: dist,
        StudentFieldNames.bgroup: bgroup,
        StudentFieldNames.stud_address: stud_address,
        StudentFieldNames.aadhar_no: aadhar_no,
        StudentFieldNames.bankCode: bankCode,
        StudentFieldNames.reg_no: reg_no,
      };
}

class StudentFieldNames {
  static const String stud_no = "stud_no";
  static const String student_name = "student_name";
  static const String stud_fullname = "stud_fullname";
  static const String student_mname = "student_mname";
  static const String mother_name = "mother_name";
  static const String gender = "gender";
  static const String birth_date = "birth_date";
  static const String section_id = "section_id";
  static const String class_id = "class_id";
  static const String class_name = "class_name";
  static const String division_id = "division_id";
  static const String division_name = "division_name";
  static const String yr_no = "yr_no";
  static const String academic_year = "academic_year";
  static const String mobile_no = 'mobile_no';
  static const String mobile_no_1 = 'mobile_no_1';
  static const String brcode = "brcode";
  static const String client_code = "client_code";
  static const String email_id = "email_id";
  static const String city = "city";
  static const String dist = "dist";
  static const String taluka = "taluka";
  static const String bgroup = "bgroup";
  static const String stud_address = "stud_address";
  static const String aadhar_no = "aadhar_no";
  static const String bankCode = "bankCode";
  static const String reg_no = "reg_no";
}

class StudentUrls {
  static const String GET_WARDS = 'Students/GetStudentsByParentNo';
  static const String Get_student_status = 'Students/GetStudentStatus';
  static const String GET_STUDENT_IMAGE = 'Students/GetStudentImage';
  static const String GET_STUDENT_PROFILE = 'Students/GetStudentProfileByStudNo';
  static const String UPDATE_STUDENT_PROFILE = 'Students/UpdateStudentProfile';
}