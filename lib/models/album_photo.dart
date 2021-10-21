class AlbumPhoto {
  int album_id, photo_id;
  String photo_desc;

  AlbumPhoto({
    this.album_id,
    this.photo_id,
    this.photo_desc,
  });

  AlbumPhoto.fromJson(Map<String, dynamic> map) {
    album_id = map[AlbumPhotoFieldNames.album_id] ?? 0;
    photo_id = map[AlbumPhotoFieldNames.photo_id] ?? 0;
    photo_desc = map[AlbumPhotoFieldNames.photo_desc] ?? '';
  }

  AlbumPhoto.map(Map<String, dynamic> map) {
    album_id = map[AlbumPhotoFieldNames.album_id];
    photo_id = map[AlbumPhotoFieldNames.photo_id];
    photo_desc = map[AlbumPhotoFieldNames.photo_desc];
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    AlbumPhotoFieldNames.album_id: album_id,
    AlbumPhotoFieldNames.photo_id: photo_id,
    AlbumPhotoFieldNames.photo_desc: photo_desc,
  };
}

class AlbumPhotoFieldNames {
  static String album_id = "album_id";
  static String photo_id = "photo_id";
  static String photo_desc = "photo_desc";
}

class AlbumPhotoUrls {
  static const String GET_ALBUM_PHOTOS = 'Gallery/GetAlbumPhotos';
}
