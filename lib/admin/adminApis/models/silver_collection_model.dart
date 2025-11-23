class SilverCollection {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String publicId;

  SilverCollection({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.publicId,
  });

  factory SilverCollection.fromJson(Map<String, dynamic> json) {
    return SilverCollection(
      id: json['_id'],
      title: json['title'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      publicId: json['publicId'],
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'imageUrl': imageUrl,
        'publicId': publicId,
      };
}
