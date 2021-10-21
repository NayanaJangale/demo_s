class Album {
  int album_id;
  String album_desc;

  Album({
    this.album_id,
    this.album_desc,
  });

  Album.fromJson(Map<String, dynamic> map) {
    album_id = map[AlbumFieldNames.album_id];
    album_desc = map[AlbumFieldNames.album_desc];
  }

  Album.map(Map<String, dynamic> map) {
    album_id = map[AlbumFieldNames.album_id] ?? 0;
    album_desc = map[AlbumFieldNames.album_desc] ?? '';
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    AlbumFieldNames.album_id: album_id,
    AlbumFieldNames.album_desc: album_desc,
  };
}

class AlbumFieldNames {
  static const String album_id = "album_id";
  static const String album_desc = "album_desc";
}

class AlbumUrls {
  static const String GET_TEACHER_ALBUMS = 'Gallery/GetStudentAlbums';
  static const String GET_ALBUM_PHOTO = 'Gallery/GetAlbumPhoto';
}
