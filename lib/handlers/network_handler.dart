import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:http/http.dart';
import 'package:student/app_data.dart';
import 'package:student/constants/http_status_codes.dart';
import 'package:student/constants/internet_connection.dart';
import 'package:student/models/live_server_urls.dart';
import 'package:student/models/user.dart';

class NetworkHandler {
  static Uri getUri(String url, Map<String, dynamic> params) {
    try {
      params.addAll({
        UserFieldNames.UserNo: AppData.current.user != null
            ? AppData.current.user.userNo.toString()
            : '',
        'UserType': 'Student',
        'ApplicationType': 'Student',
        'AppVersion': '1',
        'MacAddress': 'xxxxxx',
        UserFieldNames.clientCode: AppData.current.user.clientCode,
        UserFieldNames.user_no: AppData.current.user.userNo.toString(),
      });
      Uri uri = Uri.parse(url);
      return uri.replace(queryParameters: params);
    } catch (e) {
      return null;
    }
  }

  static Future<String> checkInternetConnection() async {
    String status;
    try {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi) {
        // I am connected to a mobile network.
        status = InternetConnection.CONNECTED;
      } else {
        // I am connected to no network.
        status = InternetConnection.NOT_CONNECTED;
      }
    } catch (e) {
      status = InternetConnection.NOT_CONNECTED;
      status = 'Exception: ' + e.toString();
    }
    return status;
  }

  static Future<String> getServerWorkingUrl() async {
    List<LiveServer> liveServers = [];

    String connectionStatus = await NetworkHandler.checkInternetConnection();
    if (connectionStatus == InternetConnection.CONNECTED) {
      Uri getLiveUrlsUri = Uri.parse(
        LiveServerUrls.serviceUrl,
      );

      Response response = await get(getLiveUrlsUri);

      if (response.statusCode == HttpStatusCodes.OK) {
        var data = json.decode(response.body);

        var parsedJson = data["Data"];

        List responseData = parsedJson;
        liveServers =
            responseData.map((item) => LiveServer.fromMap(item)).toList();

        if (liveServers.length != 0 && liveServers.isNotEmpty) {
          for (var server in liveServers) {
            Uri checkUrl = Uri.parse(
              server.ipurl,
            );

            Response checkResponse = await get(checkUrl);

            if (checkResponse.statusCode == HttpStatusCodes.OK) {
            //return "http://103.19.18.101:81/";
            return server.ipurl;
            }
          }
        }
      } else {
        return "key_check_internet";
      }
    } else {
      return "key_check_internet";
    }
  }
}
