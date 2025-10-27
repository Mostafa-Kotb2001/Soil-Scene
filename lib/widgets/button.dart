import 'package:flutter/material.dart';

class Button extends StatelessWidget{

   final String text;
   final Color color ;
   final Color textcolor ;
   final void Function() onTap ;
  const Button({
    super.key ,
    required this.text ,
    required this.color,
    required this.textcolor,
    required this.onTap,
});
  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: 55,
        decoration:  BoxDecoration(
          color:color ,
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        ),
        child: MaterialButton(
          onPressed: onTap,
          child:  Center(
            child: Text(text ,
              style:TextStyle(
                  fontSize: 18 ,
                  color: textcolor,
                  fontWeight: FontWeight.bold
              )
              ,),
          ),
        )
    );
  }
}