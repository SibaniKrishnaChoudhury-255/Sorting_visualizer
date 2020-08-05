import 'package:flutter/material.dart';
// import 'Constants.dart';
import 'package:fl_chart/fl_chart.dart';
import 'Constants.dart';

class ShortingAlgorithmsList extends StatefulWidget {
  final Function(String) onTap;
  final bool isDisabled;

  const ShortingAlgorithmsList({Key key, this.isDisabled = false, this.onTap})
      : super(key: key);

  @override
  _ShortingAlgorithmsListState createState() => _ShortingAlgorithmsListState();
}

class _ShortingAlgorithmsListState extends State<ShortingAlgorithmsList> {
  int selected = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: shortingAlgoList.length,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () {
              if (!widget.isDisabled) {
                setState(() {
                  selected = index;
                });
                widget.onTap(shortingAlgoList[selected].title);
              }
            },
            child: Container(
//              width: 490,   //for web-app
              padding: EdgeInsets.all( 8.0),
              margin: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: (selected == index) ? accent : primaryDark,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Center(
                child: Text(
                  shortingAlgoList[index].title,
                  style: TextStyle(
                      fontSize: 14,
                      // fontWeight: FontWeight.bold,
                      color: selected == index ? Colors.black : accent),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class ChartWidget extends StatelessWidget {
  final Duration duration = Duration(milliseconds: 250);
  final List<int> numbers;
  final List<int> currentNumbers;

  ChartWidget({Key key, this.numbers, this.currentNumbers}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200,
      padding: EdgeInsets.only(top: 40, bottom: 10, left: 15, right: 15),
      child: FlChart(
        swapAnimationDuration: duration,
        chart: BarChart(barChartData()),
      ),
    );
  }

  BarChartData barChartData() {
    return BarChartData(
      titlesData: FlTitlesData(
        bottomTitles: SideTitles(
            showTitles: true,
            textStyle: TextStyle(
                color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 14),
            margin: 16.0,
            getTitles: (double number) {
              if (numbers[number.toInt()] == null)
                return '';
              else
                return numbers[number.toInt()].toString();
            }),
        leftTitles: const SideTitles(
          showTitles: false,
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: barGroupData(),
    );
  }

  List<BarChartGroupData> barGroupData() {
    return numbers.map((f) {
      return designBarData(numbers.indexOf(f), f,
          barColor: currentNumbers.contains(numbers.indexOf(f))
              ? Colors.deepOrange
              : Colors.white);
    }).toList();
  }

  BarChartGroupData designBarData(
      int x,
      int y, {
        Color barColor = Colors.white,
        double width = 10,  // for web-app take 15
      }) {
    return BarChartGroupData(x: x, barRods: [
      BarChartRodData(
        y: y.toDouble(),
        color: barColor,
        width: width,
        isRound: true,
        backDrawRodData: BackgroundBarChartRodData(
          show: true,
          y: 18,
          color: primaryDark,
        ),
      ),
    ]);
  }
}

class BottomPointer extends StatelessWidget {
  int lenght;
  List<int> pointers;

  BottomPointer({Key key, this.lenght, this.pointers}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20,
      width: double.infinity,
      child: Stack(
        children: pointers
            .map((item) => Padding(
          padding: EdgeInsets.only(left: item * MediaQuery.of(context).size.width / lenght + 8), // for web-app: item * MediaQuery.of(context).size.width / lenght + 25 + item * 2
          child: Icon(
            Icons.arrow_upward,
            color: Colors.black,
          ),
        ))
            .toList(),
      ),
    );
  }
}

