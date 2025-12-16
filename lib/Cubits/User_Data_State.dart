class userDataState {
  List<UserData> userDataList;
  String? errorMessage;

  userDataState({
    this.userDataList = const [],
    this.errorMessage,
  });
}

class UserData {
  int? userId;
  int? id;
  String? title;
  String? body;

  UserData({this.userId, this.id, this.title, this.body});

  UserData.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    id = json['id'];
    title = json['title'];
    body = json['body'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['id'] = this.id;
    data['title'] = this.title;
    data['body'] = this.body;
    return data;
  }
  Map<String, dynamic> toMap() {
    return {
      "userId": userId,
      "id": id,
      "title": title,
      "body": body,
    };
  }
  factory UserData.fromMap(Map<String, dynamic> map) {
    return UserData(
      userId: map["userId"],
      id: map["id"],
      title: map["title"],
      body: map["body"],
    );
  }
}
