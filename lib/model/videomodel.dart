class VideoModel{
  String url;
  int commentcount;
  int likecount;
  int sharecount;
  String title;
  String name;
  String headshot;

  VideoModel ({this.url,this.commentcount,this.likecount,this.sharecount,this.title,this.name,this.headshot});

  factory VideoModel.fromJson(Map<String, dynamic> json) {
    return VideoModel(
      url: json['url'],
      commentcount: json['comment-count'],
      likecount: json['like-count'],
      sharecount: json['share-count'],
      title: json['title'],
      name: json['user']['name'],
      headshot: json['user']['headshot'],

    );
  }

}