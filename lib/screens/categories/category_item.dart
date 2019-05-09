import 'package:flutter/material.dart';
import 'package:myscout/screens/categories/category_data.dart';
import 'package:myscout/sports/sports_screen.dart';
class CategoryItem extends StatelessWidget {
  CategoryItem({this.item,this.userId});
  final Category item;
  final String userId;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){

        Navigator.push(
            context,
            new MaterialPageRoute(
              builder: (context) =>SportScreen(item: item,userId: userId,)
            ));
      },
      child: Container(
          padding: EdgeInsets.all(10.0),
        child:  Column(
          children: <Widget>[
            Container(
              height: 80.0,
              width: 80.0,
              child: Material(
                color: Colors.white,
                elevation: 5.0,
                borderRadius: BorderRadius.circular(10.0),
      shadowColor: Color(0x802196F3),
       child: Image.asset(item.asset,),
      ),
            ),
      Padding(
        padding: const EdgeInsets.only(top:10.0),
        child: Text(item.name,style: TextStyle(fontSize: 17.0,color: Theme.of(context).primaryColorLight),),
      )
          ],
        )
      ),
    );
  }
}
