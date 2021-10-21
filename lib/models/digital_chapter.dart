import 'package:student/handlers/string_handlers.dart';
import 'package:student/models/chapter_video.dart';

class DigitalChapter {
  int chapter_id;
  String chapter_name;
  List<ChapterVideo> videos;

  DigitalChapter({
    this.chapter_id,
    this.chapter_name,
    this.videos,
  });

  DigitalChapter.fromMap(Map<String, dynamic> map) {
    chapter_id = map[DigitalChapterFieldNames.chapter_id] ?? 0;
    chapter_name = map[DigitalChapterFieldNames.chapter_name] ??
        StringHandlers.NotAvailable;
    videos = map[DigitalChapterFieldNames.videos] != null
        ? (map[DigitalChapterFieldNames.videos] as List)
            .map((item) => ChapterVideo.fromMap(item))
            .toList()
        : null;
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        DigitalChapterFieldNames.chapter_id: chapter_id,
        DigitalChapterFieldNames.chapter_name: chapter_name,
      };
}

class DigitalChapterFieldNames {
  static const String chapter_id = "chapter_id";
  static const String chapter_name = "chapter_name";
  static const String videos = "videos";
}

class DigitalChapterUrls {
  static const String GET_DIGITAL_CHAPTERS =
      'DigitalChapter/GetDigitalChapters';
}
