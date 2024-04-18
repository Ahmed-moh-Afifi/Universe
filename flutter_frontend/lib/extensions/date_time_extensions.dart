extension DateTimeExtensions on DateTime {
  String toEnglishString() {
    final DateTime now = DateTime.now();

    final durationDifference = difference(now).abs();
    if (durationDifference.inMinutes < 1440) {
      if (durationDifference.inSeconds < 60) {
        return '${durationDifference.inSeconds}s ago';
      } else if (durationDifference.inMinutes < 60) {
        return '${durationDifference.inMinutes}m ago';
      } else {
        return '${durationDifference.inHours}h ago';
      }
    } else {
      final List<String> months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec'
      ];
      return '$day, ${months[month - 1]}, $year';
    }
  }
}

class DateTimeExtensionsClass {}
