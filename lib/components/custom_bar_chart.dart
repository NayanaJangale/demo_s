import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:student/themes/colors.dart';

class CustomBarChart extends StatefulWidget {
  final String chartTitle;
  final List<ChartData> data;

  const CustomBarChart({@required this.data, this.chartTitle});

  @override
  _CustomBarChartState createState() => _CustomBarChartState();
}

class _CustomBarChartState extends State<CustomBarChart> {
  final Duration animDuration = Duration(milliseconds: 250);
  final Color barBackgroundColor = DepricatedThemeColors.primaryExtraLight1;
  int touchedIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          5,
        ),
        color: DepricatedThemeColors.primaryExtraLight2,
      ),
      margin: EdgeInsets.all(15.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              widget.chartTitle,
              style: TextStyle(
                color: DepricatedThemeColors.primary,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.left,
            ),
            SizedBox(
              height: 10,
            ),
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 150),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: BarChart(
                  mainBarData(),
                  swapAnimationDuration: animDuration,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<BarChartGroupData> showingGroups() =>
      List.generate(widget.data.length, (i) {
        return makeGroupData(
          widget.data[i].barNo,
          widget.data[i].barValue,
          isTouched: i == touchedIndex,
          width: 15,
        );
      });

  BarChartData mainBarData() {
    List<TextStyle> textstyles = [
      TextStyle(
        color: DepricatedThemeColors.primary,
        fontWeight: FontWeight.bold,
        fontSize: 14,
      )
    ];
    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: DepricatedThemeColors.primaryDark,
          getTooltipItem: (group, groupIndex, rod, rodIndex) {
            ChartData item = null;
            try {
              item = widget.data
                  .where((item) => item.barNo == group.x.toInt())
                  .elementAt(0);
            } catch (e) {}

            String weekDay = '';
            if (item != null) {
              weekDay = item.barName;
            }
            return BarTooltipItem(
              weekDay + '\n' + (rod.y - 1).toString(),
              TextStyle(color: Colors.white),
            );
          },
        ),
        touchCallback: (barTouchResponse) {
          setState(() {

          });
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
            showTitles: true,
            margin: 10,
            getTitles: (double value) {
              ChartData item = null;
              try {
                item = widget.data
                    .where((item) => item.barNo == value.toInt())
                    .elementAt(0);
              } catch (e) {}
              if (item != null)
                return item.barShortName;
              else
                return '';
            }),
        leftTitles:  SideTitles(
          showTitles: false,
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: showingGroups(),
    );
  }

  BarChartGroupData makeGroupData(
      int x,
      double y, {
        bool isTouched = false,
        Color barColor = DepricatedThemeColors.primary,
        double width = 22,
        List<int> showTooltips = const [],
      }) {
    List<Color> barChartRodDataColor = [
      Colors.pink,
      barColor
    ];
    List<Color> bgBarChartRodDataColor = [
      barBackgroundColor
    ];
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          y: isTouched ? y + 1 : y,
          colors: barChartRodDataColor,
          width: width,
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            y: 100,
            colors: bgBarChartRodDataColor,
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }
}

class ChartData {
  int barNo;
  String barName;
  String barShortName;
  double barValue;

  ChartData({
    this.barNo,
    this.barName,
    this.barShortName,
    this.barValue,
  });
}
