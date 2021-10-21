class LiveServer {
  String ipurl;
  String prodid;
  String ipstatus;

  LiveServer({
    this.ipurl,
    this.prodid,
    this.ipstatus,
  });

  LiveServer.fromMap(Map<String, dynamic> map) {
    ipurl = map[LiveServerConst.ipurlConst];
    prodid = map[LiveServerConst.prodidConst];
    ipstatus = map[LiveServerConst.ipstatusConst];
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        LiveServerConst.ipurlConst: ipurl,
        LiveServerConst.prodidConst: prodid,
        LiveServerConst.ipstatusConst: ipstatus,
      };
}

class LiveServerConst {
  static const String ipurlConst = "ipurl";
  static const String prodidConst = "prodid";
  static const String ipstatusConst = "ipstatus";
}

class LiveServerUrls {
  static final String serviceUrl = 'http://softaidservices.com/api/urlmsts';
}
