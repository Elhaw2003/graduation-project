class GuideGalleryEditItem {
  const GuideGalleryEditItem._({this.networkUrl, this.localPath});

  const GuideGalleryEditItem.network(String url)
      : this._(networkUrl: url, localPath: null);

  const GuideGalleryEditItem.local(String path)
      : this._(networkUrl: null, localPath: path);

  final String? networkUrl;
  final String? localPath;

  bool get isLocal => localPath != null && localPath!.isNotEmpty;
  bool get isNetwork => networkUrl != null && networkUrl!.isNotEmpty;
}
