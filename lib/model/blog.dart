class BlogModel {
  late final String pictureLink;
  late final String title;
  late final String date;
  late final int open;
  late final String para;
  late final String picture;
  late final String title1;
  late final String para2;
  late final String link;
  late final String linkp;
  late final List activity ;
  late final List boomark ;

  BlogModel({
    required this.pictureLink,
    required this.title,
    required this.date,
    required this.open,
    required this.para,
    required this.picture,
    required this.title1,
    required this.para2,
    required this.link,
    required this.linkp,
    required this.activity,
    required this.boomark,
  });

  BlogModel.fromJson(Map<String, dynamic> json)
      : pictureLink = json['picture_link'] ?? '',
        title = json['Title'] ?? 'Class 10 CBSE Result Declared ( 2023 ) Check Now in cbse.in website',
        date = json['Date'] ?? '24 July, 2023',
        open = json['Open'] ?? 199,
        para = json['para'] ?? '',
        picture = json['picture'] ?? '',
        title1 = json['title1'] ?? '',
        para2 = json['para2'] ?? '',
        link = json['link'] ?? '',
  activity = json['activity'] ?? [],
  boomark = json['bookmark'] ?? [],
        linkp = json['linkp'] ?? '';

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['picture_link'] = pictureLink;
    data['Title'] = title;
    data['Date'] = date;
    data['activity'] = activity;
    data['bookmark'] = boomark ;
    data['Open'] = open;
    data['para'] = para;
    data['picture'] = picture;
    data['title1'] = title1;
    data['para2'] = para2;
    data['link'] = link;
    data['linkp'] = linkp;
    return data;
  }
}
