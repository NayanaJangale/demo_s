import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:student/models/menu.dart';
import 'package:student/models/notification.dart';
import 'package:student/models/student.dart';
import 'package:student/models/user.dart';

class DBHandler {
  static const int DB_VERSION = 7;
  static Database _db;

  static const String DB_NAME = 'softcampus_student.db';
  static const String TABLE_USER_MASTER = 'UserMaster';
  static const String TABLE_WARD_MASTER = 'WardMaster';
  static const String TABLE_MENU_MASTER = 'MenuMaster';
  static const String TABLE_NOTIFICATION_MASTER = 'NotificationMaster';

  static const String CREATE_USER_MASTER_TABLE =
      'CREATE TABLE $TABLE_USER_MASTER ('
          '${UserFieldNames.UserNo} INTEGER, ' +
          '${UserFieldNames.LoginID} TEXT, ' +
          '${UserFieldNames.DisplayName} TEXT, ' +
          '${UserFieldNames.LoginPassword} TEXT, ' +
          '${UserFieldNames.MobileNo} TEXT, ' +
          '${UserFieldNames.UserStatus} TEXT, ' +
          '${UserFieldNames.clientCode} TEXT, ' +
          '${UserFieldNames.clientName} TEXT, ' +
          '${UserFieldNames.IsLoggedIn} INTEGER, ' +
          '${UserFieldNames.remember_me} INTEGER)';

  static const String CREATE_MENU_MASTER_TABLE =
      'CREATE TABLE $TABLE_MENU_MASTER (' +
          '${MenuFieldNames.MenuNo} INTEGER,' +
          '${MenuFieldNames.MenuFor} TEXT,' +
          '${MenuFieldNames.MenuName} TEXT,' +
          '${MenuFieldNames.MenuType} TEXT,' +
          '${MenuFieldNames.Status} TEXT,' +
          '${MenuFieldNames.StudNo} INTEGER)';

  static const String CREATE_WARD_MASTER_TABLE =
      'CREATE TABLE $TABLE_WARD_MASTER ('
          '${StudentFieldNames.stud_no} INTEGER, ' +
          '${StudentFieldNames.student_name} TEXT, ' +
          '${StudentFieldNames.stud_fullname} TEXT, ' +
          '${StudentFieldNames.student_mname} TEXT, ' +
          '${StudentFieldNames.mother_name} TEXT, ' +
          '${StudentFieldNames.gender} TEXT, ' +
          '${StudentFieldNames.birth_date} TEXT, ' +
          '${StudentFieldNames.section_id} INTEGER, ' +
          '${StudentFieldNames.class_id} INTEGER, ' +
          '${StudentFieldNames.class_name} TEXT, ' +
          '${StudentFieldNames.division_id} INTEGER, ' +
          '${StudentFieldNames.division_name} TEXT, ' +
          '${StudentFieldNames.yr_no} INTEGER, ' +
          '${StudentFieldNames.academic_year} TEXT, ' +
          '${StudentFieldNames.mobile_no} TEXT, ' +
          '${StudentFieldNames.brcode} TEXT, ' +
          '${StudentFieldNames.client_code} TEXT, ' +
          '${StudentFieldNames.email_id} TEXT, ' +
          '${StudentFieldNames.bgroup} TEXT, ' +
          '${StudentFieldNames.city} TEXT, ' +
          '${StudentFieldNames.dist} TEXT, ' +
          '${StudentFieldNames.stud_address} TEXT, ' +
          '${StudentFieldNames.aadhar_no} TEXT)';

  static const String CREATE_NOTIFICATION_TABLE =
      'CREATE TABLE $TABLE_NOTIFICATION_MASTER (' +
          '${SoftCampusNotificationFieldNames.NotificationDateTime} DATETIME,' +
          '${SoftCampusNotificationFieldNames.Title} TEXT,' +
          '${SoftCampusNotificationFieldNames.Content} TEXT,' +
          '${SoftCampusNotificationFieldNames.StudNo} TEXT,' +
          '${SoftCampusNotificationFieldNames.BranchCode} TEXT,' +
          '${SoftCampusNotificationFieldNames.ClientCode} TEXT,' +
          '${SoftCampusNotificationFieldNames.NotificationFor} TEXT,' +
          '${SoftCampusNotificationFieldNames.Topic} TEXT,' +
          '${SoftCampusNotificationFieldNames.isRead} TEXT)';

  Future<Database> get db async {
    if (_db == null) {
      _db = await _initDatabase();
    }
    return _db;
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DB_NAME);
    var db = await openDatabase(path, version: DB_VERSION, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute(CREATE_USER_MASTER_TABLE);
    await db.execute(CREATE_WARD_MASTER_TABLE);
    await db.execute(CREATE_MENU_MASTER_TABLE);
    await db.execute(CREATE_NOTIFICATION_TABLE);
  }
  /*_onUpgrade(Database db,  int oldVersion, int newVersion) async {
    await db.execute("DROP TABLE IF EXISTS $TABLE_USER_MASTER");
    await db.execute("DROP TABLE IF EXISTS $TABLE_MENU_MASTER");
    await db.execute("DROP TABLE IF EXISTS $TABLE_WARD_MASTER");
    await db.execute("DROP TABLE IF EXISTS $TABLE_NOTIFICATION_MASTER");
    _onCreate(db, newVersion);
  }*/

  Future<User> saveUser(User user) async {
    try {
      user.IsLoggedIn = 0;
      var dbClient = await db;
      int a = await dbClient.insert(
        TABLE_USER_MASTER,
        user.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return user;
    } catch (e) {
      print('Save user : ' + e.toString());
      return null;
    }
  }

  Future<User> updateUser(User user) async {
    try {
      var dbClient = await db;
      await dbClient.update(
        TABLE_USER_MASTER,
        user.toJson(),
        where: '${UserFieldNames.LoginID} = ?',
        whereArgs: [
          user.loginID,
        ],
      );
      return user;
    } catch (e) {
      return null;
    }
  }

  Future<User> login(User user) async {
    try {
      var dbClient = await db;
      user.IsLoggedIn = 1;
      await dbClient.update(
        TABLE_USER_MASTER,
        user.toJson(),
        where:
        '${UserFieldNames.UserNo} = ?',
        whereArgs: [
          user.userNo,
        ],
      );
      return user;
    } catch (e) {
      return null;
    }
  }

  Future<User> logout(User user) async {
    try {
      var dbClient = await db;

        await dbClient.delete(
          TABLE_USER_MASTER,
          where: "${UserFieldNames.UserNo} = ?",
          whereArgs: [user.userNo.toString()],
        );

    /*  await dbClient.rawUpdate(
        'UPDATE $TABLE_USER_MASTER set ${UserFieldNames.IsLoggedIn} = 0 where ${UserFieldNames.UserNo} = ?',
        [
          user.userNo.toString(),
        ],
      );
      await dbClient.rawUpdate(
        'UPDATE $TABLE_USER_MASTER set ${UserFieldNames.remember_me} = 0 where ${UserFieldNames.UserNo} = ?',
        [
          user.userNo.toString(),
        ],
      );*/

      List<Map> maps = await dbClient.rawQuery(
        "SELECT * FROM $TABLE_USER_MASTER WHERE ${UserFieldNames.UserNo} = ?",
        [
          user.userNo.toString(),
        ],
      );
      return User.fromMap(maps[0]);
    } catch (e) {
      return null;
    }
  }

  Future<List<User>> getUsers() async {
    try {
      var dbClient = await db;
      List<Map> maps =
      await dbClient.rawQuery("SELECT * FROM $TABLE_USER_MASTER");
      List<User> lst;
      lst = maps
          .map(
            (item) => User.fromMap(item),
      )
          .toList();
      return lst;
    } catch (e) {
      print('Get user : ' + e.toString());
      return null;
    }
  }

  Future<User> getUser(String userID, String userPassword) async {
    try {
      var dbClient = await db;
      List<Map> maps = await dbClient.rawQuery(
        "SELECT * FROM $TABLE_USER_MASTER WHERE ${UserFieldNames.LoginID} = ? AND ${UserFieldNames.LoginPassword} = ?",
        [
          userID,
          userPassword,
        ],
      );

      return User.fromMap(maps[0]);
    } catch (e) {
      print('Get user : ' + e.toString());
      return null;
    }
  }

  Future<List<User>> getUsersList() async {
    try {
      var dbClient = await db;
      final List<Map<String, dynamic>> maps =
      await dbClient.query(TABLE_USER_MASTER);

      List<User> users = [];
      users = maps
          .map(
            (item) => User.fromMap(item),
      )
          .toList();

      return users;
    } catch (e) {
      return null;
    }
  }

  Future<User> getLoggedInUser() async {
    try {
      var dbClient = await db;
      List<Map> maps = await dbClient.rawQuery(
        "SELECT * FROM $TABLE_USER_MASTER WHERE ${UserFieldNames.IsLoggedIn} = 1",
        null,
      );
      User u = User.fromMap(maps[0]);
      return u;
    } catch (e) {
      print('Logged In user : ' + e.toString());
      return null;
    }
  }

  Future<void> deleteUser() async {
    try {
      var dbClient = await db;
      await dbClient.delete(TABLE_USER_MASTER);
    } catch (e) {}
  }

  Future<void> saveNotification(SoftCampusNotification notification) async {
    try {
      var dbClient = await db;
      int a = await dbClient.insert(
        TABLE_NOTIFICATION_MASTER,
        notification.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      print(a);
    } catch (e) {
      print('Save notification : ' + e.toString());
      return null;
    }
  }

  Future<void> updateNotificationsByTopic(String notificationFor) async {
    try {
      var dbClient = await db;
      await dbClient.rawUpdate(
        'UPDATE $TABLE_NOTIFICATION_MASTER set ${SoftCampusNotificationFieldNames.isRead} = 1 where ${SoftCampusNotificationFieldNames.NotificationFor} = ?',
        [
          notificationFor,
        ],
      );
    } catch (e) {
      return null;
    }
  }

  Future<void> updateListNotifications(List<SoftCampusNotification> notification) async {
    try {
      for(int i=0;i<notification.length;i++){
        notification[i].isRead = "1";
        var dbClient = await db;
        await dbClient.update(
          TABLE_NOTIFICATION_MASTER,
          notification[i].toJson(),
        );
      }
    } catch (e) {
      return null;
    }
  }

  Future<List<SoftCampusNotification>> getNotifications(
      String studentNo, String brcode, String clientCode) async {
    try {
      var dbClient = await db;
      List<
          Map> maps = await dbClient.rawQuery("SELECT * FROM $TABLE_NOTIFICATION_MASTER "
          " WHERE ${SoftCampusNotificationFieldNames.StudNo} = '$studentNo'"
          " AND ${SoftCampusNotificationFieldNames.BranchCode} = '$brcode'"
          " AND ${SoftCampusNotificationFieldNames.ClientCode} = '$clientCode'"
          " ORDER BY " +
          SoftCampusNotificationFieldNames.NotificationDateTime +
          " DESC LIMIT 20");
      List<SoftCampusNotification> notifications = maps
          .map(
            (item) => SoftCampusNotification.fromMap(item),
      )
          .toList();
      return notifications;
    } catch (e) {
      print('Get notification : ' + e.toString());
      return null;
    }
  }

  Future<int> getUnReadNotifications(
      String studentNo, String brcode, String clientCode) async {
    try {
      var dbClient = await db;
      String q ="SELECT * FROM "+TABLE_NOTIFICATION_MASTER +" WHERE ${SoftCampusNotificationFieldNames.StudNo} = '${studentNo.toString()}' AND ${SoftCampusNotificationFieldNames.BranchCode} = '${brcode.toString()}' AND ${SoftCampusNotificationFieldNames.isRead} = '0' AND ${SoftCampusNotificationFieldNames.ClientCode} = '${clientCode.toString()}'";

      List<Map> maps = await dbClient.rawQuery(
        q,
        null,
      );

      return maps.length;
    } catch (e) {
      print('Get notification : ' + e.toString());
      return null;
    }
  }

  Future<void> saveStudent(List<Student> students) async {
    try {
      var dbClient = await db;
      for (var student in students) {
        await dbClient.insert(
          TABLE_WARD_MASTER,
          student.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    } catch (e) {
      print(e);
    }
  }

  Future<List<Student>> getStudentsInBranch(
      String branchCode, String clientCode) async {
    try {
      var dbClient = await db;

      final List<Map> maps = await dbClient.query(
        TABLE_WARD_MASTER,
        where:
        '${StudentFieldNames.brcode} = ? AND ${StudentFieldNames.client_code} = ?',
        whereArgs: [
          branchCode,
          clientCode,
        ],
      );
      List<Student> s;
      s = maps
          .map(
            (item) => Student.fromMap(item),
      )
          .toList();
      return s;
    } catch (e) {
      return null;
    }
  }

  Future<List<Student>> getStudentsInSection(
      String sectionID, String branchCode, String clientCode) async {
    try {
      var dbClient = await db;

      final List<Map> maps = await dbClient.query(
        TABLE_WARD_MASTER,
        where:
        '${StudentFieldNames.section_id} = ? AND ${StudentFieldNames.brcode} = ? AND ${StudentFieldNames.client_code} = ?',
        whereArgs: [
          sectionID,
          branchCode,
          clientCode,
        ],
      );
      List<Student> s;
      s = maps
          .map(
            (item) => Student.fromMap(item),
      )
          .toList();
      return s;
    } catch (e) {
      return null;
    }
  }

  Future<List<Student>> getStudentsInClass(
      String classID, String branchCode, String clientCode) async {
    try {
      var dbClient = await db;

      final List<Map> maps = await dbClient.query(
        TABLE_WARD_MASTER,
        where:
        '${StudentFieldNames.class_id} = ? AND ${StudentFieldNames.brcode} = ? AND ${StudentFieldNames.client_code} = ?',
        whereArgs: [
          classID,
          branchCode,
          clientCode,
        ],
      );
      List<Student> s;
      s = maps
          .map(
            (item) => Student.fromMap(item),
      )
          .toList();
      return s;
    } catch (e) {
      return null;
    }
  }

  Future<List<Student>> getStudentsInDivision(String classID, String divisionID,
      String branchCode, String clientCode) async {
    try {
      var dbClient = await db;

      final List<Map> maps = await dbClient.query(
        TABLE_WARD_MASTER,
        where:
        '${StudentFieldNames.class_id} = ? AND ${StudentFieldNames.division_id} = ? AND ${StudentFieldNames.brcode} = ? AND ${StudentFieldNames.client_code} = ?',
        whereArgs: [
          classID,
          divisionID,
          branchCode,
          clientCode,
        ],
      );
      List<Student> s;
      s = maps
          .map(
            (item) => Student.fromMap(item),
      )
          .toList();
      return s;
    } catch (e) {
      return null;
    }
  }

  Future<List<Student>> getStudents(String mobileNo) async {
    try {
      var dbClient = await db;

      final List<Map> maps = await dbClient.query(
        TABLE_WARD_MASTER,
        where: '${StudentFieldNames.mobile_no} = ?',
        whereArgs: [
          mobileNo,
        ],
      );
      List<Student> s;
      s = maps
          .map(
            (item) => Student.fromMap(item),
      )
          .toList();
      return s;
    } catch (e) {
      return null;
    }
  }

  Future<List<Student>> getStudentByStudNo(String studNo) async {
    try {
      var dbClient = await db;

      final List<Map> maps = await dbClient.query(
        TABLE_WARD_MASTER,
        where: '${StudentFieldNames.stud_no} = ?',
        whereArgs: [
          studNo,
        ],
      );
      List<Student> s;
      s = maps
          .map(
            (item) => Student.fromMap(item),
      )
          .toList();
      return s;
    } catch (e) {
      return null;
    }
  }

  Future<void> deleteStudents(String mobileNo) async {
    try {
      var dbClient = await db;
      await dbClient.delete(
        TABLE_WARD_MASTER,
        where: '${StudentFieldNames.mobile_no} = ?',
        whereArgs: [
          mobileNo,
        ],
      );
    } catch (e) {
      throw e;
    }
  }

  Future<Student> updateStudent(Student student) async {
    try {
      var dbClient = await db;
      await dbClient.update(
        TABLE_WARD_MASTER,
        student.toJson(),
        where: '${StudentFieldNames.mobile_no} = ?',
        whereArgs: [
          student.mobile_no,
        ],
      );
      return student;
    } catch (e) {
      return null;
    }
  }

  Future<void> saveMenu(List<Menu> menus, int studNo) async {
    try {
      var dbClient = await db;
      for (var menu in menus) {
        menu.StudNo = studNo;

        int a = await dbClient.insert(
          TABLE_MENU_MASTER,
          menu.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
        print('menu saved:$a');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<bool> deleteMenu(int studNo) async {
    try {
      var dbClient = await db;
      await dbClient.delete(
        TABLE_MENU_MASTER,
        where: "${MenuFieldNames.StudNo} = ?",
        whereArgs: [studNo],
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteAllMenus() async {
    try {
      var dbClient = await db;
      await dbClient.delete(TABLE_MENU_MASTER);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<Menu>> getMenus(int studNo) async {
    try {
      var dbClient = await db;
      final List<Map> maps = await dbClient.rawQuery(
        "SELECT * FROM $TABLE_MENU_MASTER WHERE ${MenuFieldNames.StudNo} = $studNo",
      );

      List<Menu> m;
      m = maps
          .map(
            (item) => Menu.fromMap(item),
      )
          .toList();
      return m;
    } catch (e) {
      return null;
    }
  }
}
