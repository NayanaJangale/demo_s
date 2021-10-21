class Course {
  String CourseName;
  int CourseID;
  bool isSelected = false;

  Course({
    this.CourseName,
    this.CourseID,
  });

  Course.fromMap(Map<String, dynamic> map) {
    CourseName = map[CourseConst.CourseNameConst];
    CourseID = map[CourseConst.CourseIDConst];
  }
  factory Course.fromJson(Map<String, dynamic> parsedJson) {
    return Course(
      CourseName: parsedJson['CourseName'] as String,
      CourseID: parsedJson['CourseID'],
    );
  }
  @override
  String toString() {
    // TODO: implement toString
    return CourseName;
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    CourseConst.CourseNameConst: CourseName,
    CourseConst.CourseIDConst: CourseID,
      };
}

class CourseUrls {
  static const String GET_COURSES = "MCQ/GetCourses";
}

class CourseConst {
  static const String CourseNameConst = "CourseName";
  static const String CourseIDConst = "CourseID";
}
