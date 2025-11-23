class ImageItem {
  final String id;
  final String imageUrl;
  final String publicId;
  final String groupId;

  ImageItem({
    required this.id,
    required this.imageUrl,
    required this.publicId,
    required this.groupId,
  });

  factory ImageItem.fromJson(Map<String, dynamic> json, String groupId) {
    return ImageItem(
      id: json['_id'],
      imageUrl: json['imageUrl'],
      publicId: json['publicId'],
      groupId: groupId,
    );
  }
}
