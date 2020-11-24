String getco2quad(var value) {
  String quality;
  if (value <= 400) {
    quality = 'Rất tốt!';
  }
  if (400 < value && value <= 600) {
    quality = 'Tốt!';
  }
  if (600 < value && value <= 1000) {
    quality = 'Bình thường!';
  }
  if (1000 < value) {
    quality = 'Tệ!';
  }
  return quality;
}