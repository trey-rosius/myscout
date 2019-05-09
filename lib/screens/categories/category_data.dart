class Category{
  int id;
  String name;
  String image;

  Category({this.id, this.name, this.image});


  String get asset => 'assets/images/$image.png';



}
final List<Category> categories = [
   Category(
       id: 1,
       name: 'Football',
       image: 'football'
   ),
   Category(
       id: 2,
       name: 'Basketball',
       image: 'basketball'
   ),
   Category(
       id: 3,
       name: 'Soccer',
       image: 'soccer'
   ),
   Category(
       id: 4,
       name: 'Baseball',
       image: 'baseball'
   ),
   Category(
       id: 5,
       name: 'Tennis',
       image: 'tennis'
   )



];