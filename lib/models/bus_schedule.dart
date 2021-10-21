import 'package:student/handlers/string_handlers.dart';

class BusSchedule {
  String point_name;
  DateTime in_time;
  DateTime out_time;



  BusSchedule({this.point_name, this.in_time, this.out_time});

  BusSchedule.fromMap(Map<String, dynamic> map) {
    point_name = map[BusScheduleFieldNames.point_name]  ?? StringHandlers.NotAvailable;
    in_time = DateTime.parse(map[BusScheduleFieldNames.in_time ]) != null &&
        map[BusScheduleFieldNames.in_time].toString().trim() != ''
        ? DateTime.parse(map[BusScheduleFieldNames.in_time])
        : null;

    out_time = DateTime.parse(map[BusScheduleFieldNames.out_time ]) != null &&
        map[BusScheduleFieldNames.out_time].toString().trim() != ''
        ? DateTime.parse(map[BusScheduleFieldNames.out_time])
        : null;
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    BusScheduleFieldNames.point_name: point_name,
    BusScheduleFieldNames.in_time :
    in_time == null ? null : in_time.toIso8601String(),
    BusScheduleFieldNames.out_time :
    out_time == null ? null : out_time.toIso8601String()
      };
}

class BusScheduleFieldNames {
  static const String point_name = "point_name";
  static const String in_time = "in_time";
  static const String out_time = "out_time";
}

class  BusScheduleUrls {
  static const String GetBUSSCHEDULE = 'Bus/GetStudentBusSchedule';
}
