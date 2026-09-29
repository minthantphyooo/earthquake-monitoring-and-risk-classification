class TimeFormatter {
  static String formatTimeAgo(DateTime time) {
    final difference = DateTime.now().difference(time);
    if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hr ${difference.inMinutes % 60} min ago';
    } else {
      return '${difference.inMinutes} min ago';
    }
  }
} 