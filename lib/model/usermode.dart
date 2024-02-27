
class UserModel {
  UserModel({
    required this.Chess_Level,
    required this.Email,
    required this.Name,
    required this.Pic_link,
    required this.Bio,
    required this.Draw,
    required this.Gender,
    required this.Interest,
    required this.Language,
    required this.Location,
    required this.Lose,
    required this.Talk,
    required this.Won,
    required this.uid,
  });
  late final String Chess_Level;
  late final String Email;
  late final String Name;
  late final String Pic_link;
  late final String Bio;
  late final int Draw;
  late final String Gender;
  late final String Interest;
  late final String Language;
  late final String Location;
  late final int Lose;
  late final String Talk;
  late final int Won;
  late final String uid;

  UserModel.fromJson(Map<String, dynamic> json){
    Chess_Level = json['Chess Level'] ?? '1st 2018';
    Email = json['Email'] ?? 'demo@demo.com';
    Name = json['Name'] ?? 'samai';
    Pic_link = json['Pic_link'] ?? 'https://i.pinimg.com/736x/98/fc/63/98fc635fae7bb3e63219dd270f88e39d.jpg';
    Bio = json['Bio'] ?? 'Demo';
    Draw = json['Draw'] ?? 0 ;
    Gender = json['Gender'] ?? "Male" ;
    Interest = json['Interest'] ?? "Chess Game" ;
    Language = json['Language'] ?? "English" ;
    Location = json['Location'] ?? "Spain" ;
    Lose = json['Lose'] ?? 0 ;
    Talk = json['Talk'] ?? "Little Talkative" ;
    Won = json['Won'] ?? 0 ;
    uid = json['Uid'] ?? "Hello";
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['Chess Level'] = Chess_Level;
    data['Email'] = Email;
    data['Name'] = Name;
    data['Pic_link'] = Pic_link;
    return data;
  }

}
