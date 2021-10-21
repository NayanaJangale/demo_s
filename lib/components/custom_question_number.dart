import 'package:flutter/material.dart';
import 'package:student/models/mcq_question.dart';
class PageIndicator extends StatelessWidget {
  final int currentIndex;
  final int pageCount;
  Color bgDarkColor = Color(0xa13700b3);
  final Function onClick;
  List<MCQQuestion> mcq_question;
  PageIndicator(
      this.currentIndex, this.pageCount, this.onClick,this.mcq_question);
  _indicator(bool isActive, int index) {

    return Container(
      child: InkWell(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        onTap: () {
          onClick(index);
        },
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            AnimatedContainer(
              height: 4.0,
              decoration: BoxDecoration(
                  color: isActive ? Colors.white70 : Colors.white30,
                  boxShadow: [
                    BoxShadow(
                        color: isActive ? Colors.white70 : Colors.white30,
                        offset: Offset(0.0, 1.0),
                        blurRadius: 10.0)
                  ]),
              duration: Duration(seconds: 2),
              // Provide an optional curve to make the animation feel smoother.
              curve: Curves.fastLinearToSlowEaseIn,
            ),
            CircleAvatar(
              backgroundColor: mcq_question[index].isMarkForReview ? Colors.orange : mcq_question[index].qStatus == "A" ? Colors.green : bgDarkColor,
              child: Text(
                "${index + 1}",
                style: TextStyle(
                    color: index == currentIndex ? bgDarkColor : Colors.white, fontSize: 16),
              ),
            ),
            mcq_question[index].qStatus == "A"
                ? Positioned(
              top: -4,
              right: 8,
              child: Icon(
                Icons.done,
                color: Colors.green,
              ),
            )
                : SizedBox()
          ],
        ),
      ),
    );
  }
  _buildPageIndicators() {
    List<Widget> indicatorList = [];
    for (int i = 0; i < pageCount; i++) {
      indicatorList
          .add(i <= currentIndex ? _indicator(true, i) : _indicator(false, i));
    }
    return indicatorList;
  }
  /* @override
  Widget build(BuildContext context) {
    return new Row(
      children: _buildPageIndicators(),
    );
  }*/

  @override
  Widget build(BuildContext context) {
    return  Container(
      height: 60,
      child: ListView(
          scrollDirection: Axis.horizontal,
          children: _buildPageIndicators()
      ),
    );
  }

}


class SurveyDetailsUi extends StatefulWidget {
  @override
  _SurveyDetailsUiState createState() => _SurveyDetailsUiState();
}
class _SurveyDetailsUiState extends State<SurveyDetailsUi> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
