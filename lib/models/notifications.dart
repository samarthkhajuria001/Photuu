class Notification {
  final String uid;
  final bool isRead;
  final String data;

  Notification(this.uid, this.isRead, this.data);

  factory Notification.fromFirebase(Map<String, dynamic> noti) {
    return Notification(noti['uid'], noti['isRead'], noti['data']);
  }

  Map<String, dynamic> toJson(Notification noti) {
    return {'uid': noti.uid, 'isRead': noti.isRead, 'data': noti.data};
  }
}
