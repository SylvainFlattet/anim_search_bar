import 'package:flutter/material.dart';
import 'dart:math';

class AnimSearchBar extends StatefulWidget {
  
  ///  width - double ,isRequired : Yes
  ///  textController - TextEditingController  ,isRequired : Yes
  ///  rtl - Boolean, isRequired : No
  ///  onSuffixTap - Function, isRequired : Yes
  ///  suffixIcon - IconData ,isRequired :  No
  ///  prefixIcon - IconData  ,isRequired : No
  ///  animationDurationInMilli -  int ,isRequired : No
  ///  helpText - String ,isRequired :  No

  final double width;
  final TextEditingController textController;
  final IconData suffixIcon;
  final IconData prefixIcon;
  final String helpText;
  final int animationDurationInMilli;
  final onSuffixTap;
  final bool rtl;

  const AnimSearchBar(
      {Key key,

      /// The width cannot be null
      @required this.width,

      /// The textController cannot be null
      @required this.textController,
      this.suffixIcon = Icons.close,
      this.prefixIcon = Icons.search,
      this.helpText = "Search...",

      /// The onSuffixTap cannot be null
      @required this.onSuffixTap,
      this.animationDurationInMilli = 375,

      /// make the search bar to open from right to left
      this.rtl = false})
      : assert(
          /// The width cannot be null and double.infinity
          width != null && width != double.infinity,

          /// The textController cannot be null
          textController != null,
        ),
        super(key: key);
  @override
  _AnimSearchBarState createState() => _AnimSearchBarState();
}

///toggle - 0 => false or closed
///toggle 1 => true or open
int toggle = 0;

class _AnimSearchBarState extends State<AnimSearchBar>
    with SingleTickerProviderStateMixin {
  ///initializing the AnimationController
  AnimationController _con;
  @override
  void initState() {
    super.initState();

    ///Initializing the animationController which is responsible for the expanding and shrinking of the search bar
    _con = AnimationController(
      vsync: this,

      /// animationDurationInMilli is optional, the default value is 375
      duration: Duration(milliseconds: widget.animationDurationInMilli),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.0,

      ///if the rtl is true, search bar will be from right to left
      alignment: widget.rtl ? Alignment.centerRight : Alignment(-1.0, 0.0),

      ///Using Animated container to expand and shrink the widget
      child: AnimatedContainer(
        duration: Duration(milliseconds: widget.animationDurationInMilli),
        height: 48.0,
        width: (toggle == 0) ? 48.0 : widget.width,
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              spreadRadius: -10.0,
              blurRadius: 10.0,
              offset: Offset(0.0, 10.0),
            ),
          ],
        ),
        child: Stack(
          children: [
            ///Using Animated Positioned widget to expand and shrink the widget
            AnimatedPositioned(
              duration: Duration(milliseconds: widget.animationDurationInMilli),
              top: 6.0,
              right: 7.0,
              curve: Curves.easeOut,
              child: AnimatedOpacity(
                opacity: (toggle == 0) ? 0.0 : 1.0,
                duration: Duration(milliseconds: 200),
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Color(0xffF2F3F7),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: AnimatedBuilder(
                    child: GestureDetector(
                      onTap: () {
                        try {
                          ///trying to execute the onSuffixTap function
                          widget.onSuffixTap();
                        } catch (e) {
                          ///print the error if the try block fails
                          print(e);
                        }
                      },
                      child: Icon(
                        widget.suffixIcon,
                        size: 20.0,
                      ),
                    ),
                    builder: (context, widget) {
                      ///Using Transform.rotate to rotate the suffix icon when it gets expanded
                      return Transform.rotate(
                        angle: _con.value * 2.0 * pi,
                        child: widget,
                      );
                    },
                    animation: _con,
                  ),
                ),
              ),
            ),
            AnimatedPositioned(
              duration: Duration(milliseconds: widget.animationDurationInMilli),
              left: (toggle == 0) ? 20.0 : 40.0,
              curve: Curves.easeOut,
              top: 11.0,

              ///Using Animated opacity to change the opacity of th textField while expanding
              child: AnimatedOpacity(
                opacity: (toggle == 0) ? 0.0 : 1.0,
                duration: Duration(milliseconds: 200),
                child: Container(
                  height: 23.0,
                  width: 180.0,
                  child: TextField(
                    ///Text Controller. you can manipulate the text inside this textField by calling this controller.
                    controller: widget.textController,
                    cursorRadius: Radius.circular(10.0),
                    cursorWidth: 2.0,
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      labelText: widget.helpText,
                      labelStyle: TextStyle(
                        color: Color(0xff5B5B5B),
                        fontSize: 17.0,
                        fontWeight: FontWeight.w500,
                      ),
                      alignLabelWithHint: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            ///Using material widget here to get the ripple effect on the prefix icon
            Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30.0),
              child: IconButton(
                splashRadius: 19.0,

                ///if toggle is 1, which means it's open. so show the back icon, which will close it.
                ///if the toggle is 0, which means it's closed, so tapping on it will expand the widget.
                icon: Icon(
                    toggle == 1 ? Icons.arrow_back_ios : widget.prefixIcon),
                onPressed: () {
                  setState(
                    () {
                      ///if the search bar is closed
                      if (toggle == 0) {
                        toggle = 1;

                        ///forward == expand
                        _con.forward();
                      } else {
                        ///if the search bar is expanded
                        toggle = 0;

                        ///reverse == close
                        _con.reverse();
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
