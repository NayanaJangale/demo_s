import 'package:student/handlers/string_handlers.dart';

class Video {
  int video_no;
  String title;
  String video_url;

  Video({
    this.video_no,
    this.title,
    this.video_url,
  });

  Video.fromMap(Map<String, dynamic> map) {
    video_no = map[VideoFieldNames.video_no] ?? 0;
    title = map[VideoFieldNames.title]  ?? StringHandlers.NotAvailable;
    video_url = map[VideoFieldNames.video_url] ?? '';
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        VideoFieldNames.video_no: video_no ,
        VideoFieldNames.title: title,
        VideoFieldNames.video_url: video_url
      };
}

class VideoFieldNames {
  static const String video_no = "video_no";
  static const String title = "title";
  static const String video_url = "video_url";
}

class VideoUrls {
  static const String GET_VIDEOS = 'Video/GetVideos';
}
