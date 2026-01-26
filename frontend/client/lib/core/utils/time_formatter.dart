
// fungsi untuk memformat waktu menjadi format "time ago"
class TimeFormatter { 
  static String timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 60) return '${diff.inMinutes} m lalu';
    if (diff.inHours < 24) return '${diff.inHours} jam lalu';
    return '${diff.inDays} hari lalu';
  }
    static String timeAgoNull(DateTime? date) {
    final diff = DateTime?.now().difference(date!);
    if (diff.inMinutes < 60) return '${diff.inMinutes} m lalu';
    if (diff.inHours < 24) return '${diff.inHours} jam lalu';
    return '${diff.inDays} hari lalu';
  }
}