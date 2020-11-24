String getgasquad(var value) {
  String quality;
  if (value <= 200) {
    quality = 'Bình thường!';
  }
  if (200 < value && value <= 500) {
    quality = 'Rò rỉ gas ít!';
  }
  if (500 < value && value <= 1000) {
    quality = 'Rò rỉ gas!';
  }
  if (1000 < value) {
    quality = 'Rò rỉ gas nghiêm trọng!';
  }
  return quality;
}