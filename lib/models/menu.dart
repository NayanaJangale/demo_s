import 'package:student/handlers/string_handlers.dart';

class Menu {
  int MenuNo;
  String MenuFor;
  String MenuName;
  String MenuType;
  String Status;
  int StudNo;

  Menu({
    this.MenuNo,
    this.MenuFor,
    this.MenuName,
    this.MenuType,
    this.Status,
  });

  Menu.fromMap(Map<String, dynamic> map) {
    MenuNo = map[MenuFieldNames.MenuNo] ?? 0;
    MenuFor = map[MenuFieldNames.MenuFor]  ?? StringHandlers.NotAvailable;
    MenuName = map[MenuFieldNames.MenuName]  ?? StringHandlers.NotAvailable;
    MenuType = map[MenuFieldNames.MenuType]  ?? StringHandlers.NotAvailable;
    Status = map[MenuFieldNames.Status]  ?? StringHandlers.NotAvailable;
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        MenuFieldNames.MenuNo: MenuNo,
        MenuFieldNames.MenuFor: MenuFor,
        MenuFieldNames.MenuName: MenuName,
        MenuFieldNames.MenuType: MenuType,
        MenuFieldNames.Status: Status,
      };
}

class MenuFieldNames {
  static const String MenuNo = "MenuNo";
  static const String MenuFor = "MenuFor";
  static const String MenuName = "MenuName";
  static const String MenuType = "MenuType";
  static const String Status = "Status";
  static const String StudNo = "StudNo";
}

class MenuUrls {
  static const String GET_MENUS = 'Menu/GetMenus';
}
