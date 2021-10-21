import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:student/app_data.dart';
import 'package:student/components/custom_app_bar.dart';
import 'package:student/components/custom_progress_handler.dart';
import 'package:student/components/flushbar_message.dart';
import 'package:student/constants/http_status_codes.dart';
import 'package:student/constants/menu_constants.dart';
import 'package:student/constants/message_types.dart';
import 'package:student/constants/project_settings.dart';
import 'package:student/handlers/database_handler.dart';
import 'package:student/handlers/network_handler.dart';
import 'package:student/handlers/string_handlers.dart';
import 'package:student/localization/app_translations.dart';
import 'package:student/models/menu.dart';
import 'package:student/models/student.dart';
import 'package:student/pages/add_review_page.dart';
import 'package:student/pages/library_page.dart';
import 'package:student/pages/albums_page.dart';
import 'package:student/pages/attendance_page.dart';
import 'package:student/pages/available_exam_page.dart';
import 'package:student/pages/bus_tracking_page.dart';
import 'package:student/pages/calendar_page.dart';
import 'package:student/pages/circular_page.dart';
import 'package:student/pages/class_test_page.dart';
import 'package:student/pages/digital_chapters_page.dart';
import 'package:student/pages/downloads_page.dart';
import 'package:student/pages/feedback_page.dart';
import 'package:student/pages/fees_page.dart';
import 'package:student/pages/fees_receipt_page.dart';
import 'package:student/pages/homework_page.dart';
import 'package:student/pages/messages_page.dart';
import 'package:student/pages/result_page.dart';
import 'package:student/pages/syllabus_page.dart';
import 'package:student/pages/time_table_page.dart';
import 'package:student/pages/videos_page.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLoading;
  String _loadingText;
  int index = 0;
  int unreadNotification = 0;
  String menuType;
  List<Menu> menus = [];
  Widget w;
  Random random = new Random();
  GlobalKey<ScaffoldState> _homePageGK;

  List menuColors = [
    Colors.brown[800],
    Colors.deepPurple[800],
    Colors.orange[800],
    Colors.lightBlue[800],
    Colors.amber[800],
    Colors.grey[800],
    Colors.lime[800],
    Colors.lightGreen[800],
    Colors.red[800],
    Colors.green[800],
    Colors.yellow[800],
    Colors.teal[800],
    Colors.deepOrange[800],
    Colors.cyan[800],
    Colors.blue[800],
    Colors.indigo[800],
    Colors.purple[800],
    Colors.pink[800],
    Colors.blueGrey[800],
  ];
  @override
  void initState() {
    // TODO: implement initState

    _homePageGK = GlobalKey<ScaffoldState>();
    super.initState();
    this._isLoading = false;
    this._loadingText = 'Loading . . .';
    fetchMenus().then((result) {
      menus = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    menuType = AppData.current.preferences != null
        ? AppData.current.preferences.getString('menuType')
        : "grid";

    this._loadingText = AppTranslations.of(context).text("key_loading");
    return CustomProgressHandler(
      isLoading: this._isLoading,
      loadingText: this._loadingText,
      child: Scaffold(
        key: _homePageGK,
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: CustomAppBar(
              title: AppTranslations.of(context).text("key_hi") +
                  ' ' +
                  StringHandlers.capitalizeWords(
                      AppData.current.student.student_name),
              subtitle: AppTranslations.of(context).text("key_welcometo") +
                      " " +
                      AppData.current.user.clientName ??
                  "",
            ),
            elevation: 0.0,
          ),
          body: SafeArea(
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                RefreshIndicator(
                  onRefresh: () async {
                    fetchMenus().then((result) {
                      menus = result;
                    });
                  },
                  child:
                      this.menuType == 'list' ? getListMenu() : getGridMenu(),
                )
              ],
            ),
          )),
    );
  }

  Widget getListMenu() {
    var list = new List<int>.generate(menuColors.length, (int i) => i);

    list.shuffle();

    return Container(
      padding: EdgeInsets.all(3.0),
      color: Colors.grey[50],
      child: ListView.builder(
        itemCount: menus.length,
        itemBuilder: (BuildContext context, int index) {
          int i = random.nextInt(menuColors.length);
          Color mBg = menuColors[list[i]];
          mBg = mBg.withOpacity(0.2);

          String str = menus[index].MenuName.replaceAll(' ', '_');

          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(3.0),
                topLeft: Radius.circular(30.0),
                bottomRight: Radius.circular(3.0),
                bottomLeft: Radius.circular(30.0),
              ),
            ),
            elevation: 1.0,
            child: ListTile(
              contentPadding: EdgeInsets.all(5.0),
              onTap: () {
                openMenu(index);
              },
              leading: Padding(
                padding: const EdgeInsets.only(
                  left: 8.0,
                ),
                child: CircleAvatar(
                  backgroundColor: mBg,
                  child: Image.asset(
                    "assets/images/${getIconImage(menus[index].MenuName)}",
                    color: menuColors[list[i]],
                  ),
                ),
              ),
              title: Text(
                AppTranslations.of(context).text(str),
                style: Theme.of(context).textTheme.bodyText1.copyWith(
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1.2,
                    ),
              ),
              trailing: Icon(
                Icons.navigate_next,
                color: Colors.black45,
              ),
            ),
          );
        },
      ),
    );
  }

  String getIconImage(String menu) {
    switch (menu) {
      case MenuNameConst.StudentAttendance:
        return MenuIconConst.StudentAttendanceIcon;
        break;
      case MenuNameConst.FrequentAbsentees:
        return MenuIconConst.FrequentAbsenteesIcon;
        break;
      case MenuNameConst.HomeworkStatus:
        return MenuIconConst.HomeworkStatusIcon;
        break;
      case MenuNameConst.StaffAttendance:
        return MenuIconConst.StaffAttendanceIcon;
        break;
      case MenuNameConst.TeacherLoad:
        return MenuIconConst.TeacherLoadIcon;
        break;
      case MenuNameConst.TeacherTimeTable:
        return MenuIconConst.TeacherTimeTableIcon;
        break;
      case MenuNameConst.PendingFees:
        return MenuIconConst.PendingFeesIcon;
        break;
      case MenuNameConst.ActivityLog:
        return MenuIconConst.ActivityLogIcon;
        break;
      case MenuNameConst.AttendanceEntry:
        return MenuIconConst.AttendanceEntryIcon;
        break;
      case MenuNameConst.EmployeeLeaves:
        return MenuIconConst.EmployeeLeavesIcon;
        break;
      case MenuNameConst.Circulars:
        return MenuIconConst.CircularsIcon;
        break;
      case MenuNameConst.Balances:
        return MenuIconConst.BalancesIcon;
        break;
      case MenuNameConst.BalanceSheet:
        return MenuIconConst.BalanceSheetIcon;
        break;
      case MenuNameConst.StudentAlbums:
        return MenuIconConst.StudentAlbumsIcon;
        break;
      case MenuNameConst.AboutUs:
        return MenuIconConst.AboutUsIcon;
        break;
      case MenuNameConst.Home:
        return MenuIconConst.HomeIcon;
        break;
      case MenuNameConst.Add_Album:
        return MenuIconConst.Add_AlbumIcon;
        break;
      case MenuNameConst.Calendar:
        return MenuIconConst.CalendarIcon;
        break;
      case MenuNameConst.Gallery:
        return MenuIconConst.GalleryIcon;
        break;
      case MenuNameConst.Attendance:
        return MenuIconConst.AttendanceIcon;
        break;
      case MenuNameConst.HomeWork:
        return MenuIconConst.HomeWorkIcon;
        break;
      case MenuNameConst.Downloads:
        return MenuIconConst.DownloadsIcon;
        break;
      case MenuNameConst.Result:
        return MenuIconConst.ResultIcon;
        break;
      case MenuNameConst.StudentTest:
        return MenuIconConst.ResultIcon;
        break;
      case MenuNameConst.Messages:
        return MenuIconConst.MessagesIcon;
        break;
      case MenuNameConst.ChangePassword:
        return MenuIconConst.ChangePasswordIcon;
        break;
      case MenuNameConst.TimeTable:
        return MenuIconConst.TimeTableIcon;
        break;
      case MenuNameConst.Circular:
        return MenuIconConst.CircularIcon;
        break;
      case MenuNameConst.Confirm_Admission:
        return MenuIconConst.Confirm_AdmissionIcon;
        break;
      case MenuNameConst.Student_Fees:
        return MenuIconConst.Student_FeesIcon;
        break;
      case MenuNameConst.Fees:
        return MenuIconConst.Student_FeesIcon;
        break;
      case MenuNameConst.Videos:
        return MenuIconConst.VideoIcon;
        break;
      case MenuNameConst.Syllabus:
        return MenuIconConst.SyllabusIcon;
        break;
      case MenuNameConst.AcademicYear:
        return MenuIconConst.AcademicYearIcon;
        break;
      case MenuNameConst.Library:
        return MenuIconConst.LibraryIcon;
        break;
      case MenuNameConst.Feedback:
        return MenuIconConst.FeedbackIcon;
        break;
      case MenuNameConst.Logout:
        return MenuIconConst.LogoutIcon;
        break;
      case MenuNameConst.FeesReceipt:
        return MenuIconConst.FeesReceiptIcon;
        break;
      case MenuNameConst.DigitalChapters:
        return MenuIconConst.DigitalChaptersIcon;
        break;
      case MenuNameConst.PractiseExam:
        return MenuIconConst.ResultIcon;
        break;
      case MenuNameConst.BusTracking:
        return MenuIconConst.BusTrackingIcon;
        break;
      case MenuNameConst.Suggestion:
        return MenuIconConst.SuggestionIcon;
        break;
      default:
        return MenuIconConst.DefaultIcon;
    }
  }

  Widget getGridMenu() {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
      child: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: [
              Colors.grey[200],
              Colors.white,
            ],
            radius: 0.75,
            focal: Alignment.center,
          ),
        ),
        child: GridView(
          // Create a grid with 2 columns. If you change the scrollDirection to
          // horizontal, this produces 2 rows.
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisSpacing: 1,
            mainAxisSpacing: 1,
            crossAxisCount: 3,
          ),
          // Generate 100 widgets that display their index in the List.
          children: getGridCells(),
        ),
      ),
    );
  }

  List<Widget> getGridCells() {
    var list = new List<int>.generate(
        menuColors.length, (int index) => index); // [0, 1, 4]
    list.shuffle();

    List<Widget> cells = List.generate(menus.length, (index) {
      int indx = random.nextInt(menuColors.length);
      Color mBg = menuColors[list[indx]];
      mBg = mBg.withOpacity(0.2);
      String str = menus[index].MenuName.replaceAll(' ', '_');

      return GestureDetector(
        onTap: () {
          openMenu(index);
        },
        child: GestureDetector(
          onTap: () {
            openMenu(index);
          },
          child: Container(
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: Center(
                    child: CircleAvatar(
                      backgroundColor: mBg,
                      child: Image.asset(
                        "assets/images/${getIconImage(menus[index].MenuName)}",
                        color: menuColors[list[indx]],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    AppTranslations.of(context).text(str),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1.2,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });

    int exItems = 3 - (menus.length % 3);
    if (exItems != 0 && exItems != 3) {
      for (int i = 0; i < exItems; i++) {
        cells.add(
          Container(
            color: Colors.white,
          ),
        );
      }
    }
    return cells;
  }
  openMenu(int index) {
    if (menus[index].MenuName == MenuNameConst.Library) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => LibraryPage(),
        ),
      );
    } else if (menus[index].MenuName == MenuNameConst.Gallery) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => AlbumsPage(),
        ),
      );
    } else if (menus[index].MenuName == MenuNameConst.FeesReceipt) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => FeesReceiptPage(),
        ),
      );
    } else if (menus[index].MenuName == MenuNameConst.Attendance) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => AttendancePage(),
        ),
      );
    } else if (menus[index].MenuName == MenuNameConst.Videos) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => VideosPage(),
        ),
      );
    } else if (menus[index].MenuName == MenuNameConst.Fees) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => FeesPage(),
        ),
      );
    } else if (menus[index].MenuName == MenuNameConst.Syllabus) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => SyllabusPage(),
        ),
      );
    } else if (menus[index].MenuName == MenuNameConst.Downloads) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => DownloadsPage(),
        ),
      );
    } else if (menus[index].MenuName == MenuNameConst.TimeTable) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => TimeTablePage(),
        ),
      );
    } else if (menus[index].MenuName == MenuNameConst.Messages) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => MessagesPage(),
        ),
      );
    } else if (menus[index].MenuName == MenuNameConst.StudentTest) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ClassTestPage(),
        ),
      );
    } else if (menus[index].MenuName == MenuNameConst.Calendar) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CalendarPage(),
        ),
      );
    } else if (menus[index].MenuName == MenuNameConst.Circular) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CircularPage(),
        ),
      );
    } else if (menus[index].MenuName == MenuNameConst.HomeWork) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => HomeworkPage(),
        ),
      );
    } else if (menus[index].MenuName == MenuNameConst.Result) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ResultPage(),
        ),
      );
    } else if (menus[index].MenuName == MenuNameConst.DigitalChapters) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => DigitalChaptersPage(),
        ),
      );
    } else if (menus[index].MenuName == MenuNameConst.Feedback) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => FeedbackPage(),
        ),
      );
    } else if (menus[index].MenuName == MenuNameConst.PractiseExam) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => AvailableExamPage(),
        ),
      );
    } else if (menus[index].MenuName == MenuNameConst.BusTracking) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BusTrackingPage(),
        ),
      );
    }else if (menus[index].MenuName == MenuNameConst.Suggestion) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => AddReviewPage(),
        ),
      );
    }
  }
  Future<List<Menu>> fetchMenus() async {
    List<Menu> menus;
    try {
      setState(() {
        this._isLoading = true;
      });

      String connectionServerMsg = await NetworkHandler.getServerWorkingUrl();
      if (connectionServerMsg != "key_check_internet") {
        Map<String, dynamic> params = {
          StudentFieldNames.stud_no: AppData.current.student.stud_no.toString(),
          'user_no': AppData.current.user.userNo.toString(),
          MenuFieldNames.MenuFor: 'Student',
          StudentFieldNames.brcode: AppData.current.student.brcode,
          StudentFieldNames.yr_no: AppData.current.student.yr_no.toString(),
        };

        Uri fetchSchoolsUri = NetworkHandler.getUri(
          connectionServerMsg + ProjectSettings.rootUrl + MenuUrls.GET_MENUS,
          params,
        );

        http.Response response = await http.get(fetchSchoolsUri);
        if (response.statusCode != HttpStatusCodes.OK) {
          FlushbarMessage.show(
            context,
            null,
            response.body,
            MessageTypes.ERROR,
          );
          menus = null;
        } else {
          setState(() {
            List responseData = json.decode(response.body);
            menus = responseData
                .map(
                  (item) => Menu.fromMap(item),
                )
                .toList();
          });

          await DBHandler().deleteMenu(AppData.current.student.stud_no);
          await DBHandler().saveMenu(menus, AppData.current.student.stud_no);
        }
      } else {
        await DBHandler().getMenus(AppData.current.student.stud_no).then((res) {
          setState(() {
            menus = res;
          });
        });
        print(menus);
      }
    } catch (e) {
      FlushbarMessage.show(
        context,
        null,
        AppTranslations.of(context).text("key_api_error"),
        MessageTypes.ERROR,
      );
      menus = null;
    }

    setState(() {
      this._isLoading = false;
    });

    return menus != null ? menus : [];
  }
  Future<bool> _onBackPressed() {
    exit(1);
  }

}
