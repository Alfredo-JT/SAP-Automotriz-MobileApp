/// Replicates the Excel formula:
/// =CONCATENATE(TEXT(date,"DDMMYY"), "-", TEXT(COUNTIF(same_day_count), "00"))
///
/// Example: 10/03/26, 2nd service of the day → "100326-02"
String generateFolio(DateTime date, int sameDayCount) {
  final dd = date.day.toString().padLeft(2, '0');
  final mm = date.month.toString().padLeft(2, '0');
  final yy = (date.year % 100).toString().padLeft(2, '0');
  final count = sameDayCount.toString().padLeft(2, '0');
  return '$dd$mm$yy-$count';
}
