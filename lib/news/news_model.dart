class News {
  final String title,desc,image,url;


  News(this.title, this.desc, this.image, this.url);

  News.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        image = json['image'],
        url = json['url'],
        desc = json['description'];

  Map<String, dynamic> toJson() =>
      {
        'title': title,
        'image': image,
        'description': desc,
        'url': url,
      };
}