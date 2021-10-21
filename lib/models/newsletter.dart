import 'package:student/handlers/string_handlers.dart';

class Newsletter {
  DateTime NewsDate;
  String NewsDesc;
  int NewsId;
  String NewsTitle;
  String news_image;
  String news_type;
  String video_url;


  Newsletter({this.NewsDate, this.NewsDesc, this.NewsId, this.NewsTitle, this.news_image, this.news_type, this.video_url});

  Newsletter.fromMap(Map<String, dynamic> map) {
    NewsDate = DateTime.parse(map[NewsletterFieldNames.NewsDate ]) != null &&
        map[NewsletterFieldNames.NewsDate].toString().trim() != ''
        ? DateTime.parse(map[NewsletterFieldNames.NewsDate])
        : null;
    NewsDesc = map[NewsletterFieldNames.NewsDesc]  ?? StringHandlers.NotAvailable;
    NewsId = map[NewsletterFieldNames.NewsId] ?? 0;
    NewsTitle = map[NewsletterFieldNames.NewsTitle]  ?? StringHandlers.NotAvailable;
    news_image = map[NewsletterFieldNames.news_image]  ?? StringHandlers.NotAvailable;
    news_type = map[NewsletterFieldNames.news_type]  ?? StringHandlers.NotAvailable;
    video_url = map[NewsletterFieldNames.video_url] ?? '';
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    NewsletterFieldNames.NewsDate :
    NewsDate == null ? null : NewsDate.toIso8601String(),
        NewsletterFieldNames.NewsDesc: NewsDesc,
        NewsletterFieldNames.NewsId: NewsId,
        NewsletterFieldNames.NewsTitle: NewsTitle,
        NewsletterFieldNames.news_image: news_image,
        NewsletterFieldNames.news_type: news_type,
        NewsletterFieldNames.video_url: video_url
      };
}

class NewsletterFieldNames {
  static const String NewsDate = "NewsDate";
  static const String NewsDesc = "NewsDesc";
  static const String NewsId = "NewsId";
  static const String NewsTitle = "NewsTitle";
  static const String news_image = "news_image";
  static const String news_type = "news_type";
  static const String video_url = "video_url";
}

class NewsletterUrls {
  static const String GetNewsFeed = 'Video/GetNewsFeed';
}
