class GetFriendListResponse {
  List? datas;

  GetFriendListResponse({this.datas});

  GetFriendListResponse.fromJson(Map<String, dynamic> json) {
    print(json);
    if (json['datas'] != null) {
      datas = json['datas'];
    }
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = <String, dynamic>{};
  //   if (comments != null) {
  //     data['comments'] = comments!.map((v) => v.toJson()).toList();
  //   }
  //   return data;
  // }
}
