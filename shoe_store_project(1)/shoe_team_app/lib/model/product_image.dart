import 'dart:typed_data';

class ProductImage {
  final String imageId;
  final Uint8List image;

  ProductImage({
    required this.imageId,
    required this.image
  });

  ProductImage.fromMap(Map<String,dynamic> res)
  :imageId = res['imageId'],
  image = res['image'];
}