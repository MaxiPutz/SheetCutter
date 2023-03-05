class ImageInfoData {
  late int pixelX;
  late int pixelY;
  late double imageRatio;

  ImageInfoData(
      {required this.pixelX, required this.pixelY, required this.imageRatio});

  @override
  String toString() {
    return 'ImageInfoData { pixelX: $pixelX, pixelY: $pixelY, imageRatio: ${imageRatio} }';
  }
}
