class ChatTimeFormatter {
  static String formatSmartTime(DateTime? dateUtc) {
    if (dateUtc == null) return '';
    final date = dateUtc.toLocal();
    final now = DateTime.now();
    final difference = now.difference(date);

    if (now.year == date.year && now.month == date.month && now.day == date.day) {
      int hour = date.hour;
      final minute = date.minute.toString().padLeft(2, '0');
      final period = hour >= 12 ? 'PM' : 'AM';
      hour = hour % 12;
      if (hour == 0) hour = 12;
      return "$hour:$minute $period";
    } else if (difference.inDays == 1 || (now.day - date.day == 1 && now.month == date.month)) {
      return "Yesterday";
    } else {
      return "${date.day}/${date.month}/${date.year}";
    }
  }
}