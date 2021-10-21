import 'package:student/handlers/string_handlers.dart';

class ChapterVideo {
  int video_id;
  String video_title;
  String video_url;

  ChapterVideo({
    this.video_id,
    this.video_title,
    this.video_url,
  });

  ChapterVideo.fromMap(Map<String, dynamic> map) {
    video_id = map[ChapterVideoFieldNames.video_id] ?? 0;
    video_title =
        map[ChapterVideoFieldNames.video_title] ?? StringHandlers.NotAvailable;
    video_url =
        map[ChapterVideoFieldNames.video_url] ?? StringHandlers.NotAvailable;
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        ChapterVideoFieldNames.video_id: video_id,
        ChapterVideoFieldNames.video_title: video_title,
        ChapterVideoFieldNames.video_url: video_url,
      };
}

class ChapterVideoFieldNames {
  static const String video_id = "video_id";
  static const String video_title = "video_title";
  static const String video_url = "video_url";
}
