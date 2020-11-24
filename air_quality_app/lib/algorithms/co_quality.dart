String getcoquad(var value) {
  String quality;
  if (value <= 2) {
    quality = 'Rất tốt!';
  }
  if (2 < value && value <= 9) {
    quality = 'Tốt!';
  }
  if (9 < value && value <= 35) {
    quality = 'Được cho phép trong 8 tiếng liên tục';
  }
  if (35 < value && value <= 50) {
    quality = 'Không tốt trong 8 tiếng liên tục';
  }
  if (50 < value && value <= 100) {
    quality = 'Có thể gây nhức đầu nhẹ';
  }
  if (100 < value && value <= 400) {
    quality = 'Có thể gây đau đầu kéo dài';
  }
  if (400 < value && value <= 800) {
    quality = 'Có thể gây buồn nôn, chóng mặt, co giật';
  }
  if (800 < value && value <= 1600) {
    quality = 'Có thể gây tử vong trong 2 tiếng';
  }
  if (1600 < value && value <= 3200) {
    quality = 'Có thể gây tử vong trong 30 phút';
  }
  if (3200 < value && value <= 6400) {
    quality = 'Có thể gây tử vong trong 10 phút';
  }
  if (6400 < value) {
    quality = 'Có thể gây tử vong trong 1 phút';
  }
  return quality;
}