import 'package:flutter/material.dart';
class CardColor extends StatelessWidget {
  CardColor(this.color, this.isSelected, this.onTab);

  final Color color;
  final bool isSelected;
  final VoidCallback onTab;


  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTab,
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(5.0),
              border: Border.all(color: color, width: 6),
              boxShadow: isSelected
                  ? [
                BoxShadow(
                    color: Colors.black.withOpacity(.8),
                    blurRadius: 10.0,
                    offset: Offset(0.0, 10.0))
              ]
                  : []),
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: color.withOpacity(0.5),

          ),
        ),
      ),
    );
  }
}
