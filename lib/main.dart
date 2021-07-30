import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BackTester',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
      ),
      home: MyHomePage(title: 'Strategy Test'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double totalTrades;
  var totalWins;
  var totalLoss;
  var profit;
  var loss;
  var maxWin;
  var maxLost;
  var winCounter;
  var lostCounter;

  double winRate;
  String winStr;
  double balance;
  double initBalance;
  var numFormat = NumberFormat.simpleCurrency(locale: 'HI');
  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];
  List<FlSpot> flSpots;
  LineChartData data;

  @override
  void initState() {
    balance = 10000.0;
    initBalance = balance;
    totalTrades = 0.0;
    totalWins = 0;
    totalLoss = 0;
    profit = 150;
    loss = 100;
    maxWin = 0;
    maxLost = 0;
    winCounter = 0;
    lostCounter = 0;
    flSpots = [FlSpot(totalTrades, balance)];
    setChartData();
    super.initState();
  }

  void resetAll() {
    profit = 150;
    loss = 100;
    totalTrades = 0;
    totalWins = 0;
    totalLoss = 0;
    maxWin = 0;
    maxLost = 0;
    winCounter = 0;
    lostCounter = 0;
    balance = 10000.0;
    initBalance = balance;
    flSpots = [FlSpot(totalTrades, balance)];
    setChartData();
  }

  void editBalance() {
    totalTrades = 0;
    totalWins = 0;
    totalLoss = 0;
    profit = 0.015 * balance;
    loss = 0.01 * balance;
    maxWin = 0;
    maxLost = 0;
    winCounter = 0;
    lostCounter = 0;
    flSpots = [FlSpot(totalTrades, balance)];
    setChartData();
  }

  void setChartData() {
    data = LineChartData(
        clipData:
            FlClipData(top: true, bottom: false, left: true, right: false),
        titlesData: FlTitlesData(
          bottomTitles: SideTitles(
            showTitles: true,
            interval: 20,
            reservedSize: 12,
            getTextStyles: (value) => TextStyle(
              color: Color(0xff67727d),
              fontFamily: 'Raleway',
              fontSize: 10,
            ),
            margin: 8,
          ),
          leftTitles: SideTitles(
            showTitles: true,
            interval: balance / 4,
            reservedSize: 30,
            getTextStyles: (value) => TextStyle(
              color: Color(0xff67727d),
              fontFamily: 'Raleway',
              fontSize: 10,
            ),
            margin: 8,
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: Color(0xff37434d), width: 1),
        ),
        maxY: balance * 2 > balance ? balance * 2 : balance,
        minY: 0,
        minX: 0,
        maxX: totalTrades > 100 ? totalTrades : 100,
        lineBarsData: [
          LineChartBarData(
              spots: flSpots,
              isCurved: true,
              colors: gradientColors,
              barWidth: 2,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: false,
              ),
              belowBarData: BarAreaData(
                show: true,
                colors: gradientColors.map((e) => e.withOpacity(0.3)).toList(),
              ))
        ]);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var pl = balance - initBalance;
    String plPe = ((pl / initBalance) * 100).toStringAsFixed(2);
    if (totalWins != 0) {
      winRate = (totalWins / totalTrades) * 100;
      winStr = winRate.toStringAsFixed(2);
    } else {
      winStr = '100.00';
    }
    setChartData();

    return Scaffold(
      backgroundColor: Color.fromRGBO(19, 23, 33, 1),
      // backgroundColor: Colors.black,
      appBar: AppBar(
        toolbarHeight: 55,
        backgroundColor: Color.fromRGBO(30, 34, 44, 1),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.title,
              style: TextStyle(
                fontFamily: 'Raleway',
                color: Colors.yellow[700],
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              child: Row(
                children: [
                  TextButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                                title: Text(
                                  'Edit Initial Balance',
                                  style: TextStyle(
                                    fontFamily: 'Raleway',
                                    color: Colors.white38,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                content: TextField(
                                  textAlign: TextAlign.center,
                                  controller:
                                      TextEditingController(text: "$balance"),
                                  keyboardType: TextInputType.number,
                                  onChanged: (val) {
                                    balance = double.parse(val);
                                    initBalance = double.parse(val);
                                  },
                                ),
                                actions: [
                                  TextButton(
                                    child: Text("OK"),
                                    onPressed: () {
                                      setState(() {
                                        if (balance <= 1) {
                                          balance = 10000.0;
                                        } else {
                                          editBalance();
                                          setChartData();
                                          Navigator.pop(context, true);
                                        }
                                      });
                                    },
                                  )
                                ],
                              ));
                    },
                    child: Text(
                      'Edit',
                      style: TextStyle(
                        fontFamily: 'Raleway',
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        resetAll();
                      });
                    },
                    child: Text(
                      'Reset',
                      style: TextStyle(
                        fontFamily: 'Raleway',
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      numFormat.format(balance),
                      style: TextStyle(
                        fontFamily: 'Raleway',
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      "TOTAL PORTFOLIO BALANCE",
                      style: TextStyle(
                        fontFamily: 'Raleway',
                        color: Colors.white38,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 16, right: 16),
                child: Column(
                  children: [
                    Container(
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.black38,
                                borderRadius: BorderRadius.circular(
                                    5) // use instead of BorderRadius.all(Radius.circular(20))
                                ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 8, bottom: 8, left: 115, right: 115),
                              child: Column(
                                children: [
                                  Container(
                                    width: 100,
                                    child: Center(
                                      child: Text(
                                        '$winStr%',
                                        style: TextStyle(
                                          fontFamily: 'Raleway',
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "WINRATE",
                                    style: TextStyle(
                                      fontFamily: 'Raleway',
                                      color: Colors.white38,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          left: 22, top: 0, right: 22, bottom: 0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                margin: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    color: Color.fromRGBO(51, 77, 83, 1),
                                    borderRadius: BorderRadius.circular(5)),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8, bottom: 8, right: 52, left: 52),
                                  child: Column(
                                    children: [
                                      Text(
                                        '$totalWins',
                                        style: TextStyle(
                                          color:
                                              Color.fromRGBO(38, 166, 154, 1),
                                          fontFamily: 'Raleway',
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        'WON',
                                        style: TextStyle(
                                          fontFamily: 'Raleway',
                                          color: Colors.white38,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    color: Color.fromRGBO(41, 37, 47, 1),
                                    borderRadius: BorderRadius.circular(5)),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8, bottom: 8, right: 52, left: 52),
                                  child: Column(
                                    children: [
                                      Text(
                                        '$totalLoss',
                                        style: TextStyle(
                                          fontFamily: 'Raleway',
                                          color: Color.fromRGBO(239, 83, 79, 1),
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        'LOST',
                                        style: TextStyle(
                                          fontFamily: 'Raleway',
                                          color: Colors.white38,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.black38,
                                borderRadius: BorderRadius.circular(5)),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 8, bottom: 8, right: 110, left: 110),
                              child: Column(
                                children: [
                                  Text(
                                    '$totalTrades',
                                    style: TextStyle(
                                      fontFamily: 'Raleway',
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    'TOTAL NO OF TRADES',
                                    style: TextStyle(
                                      color: Colors.white38,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 16, right: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Container(
                          width: 100,
                          margin: EdgeInsets.all(8),
                          child: TextFormField(
                            key: Key(profit.toString()),
                            initialValue: profit.toString(),
                            textAlign: TextAlign.center,
                            cursorColor: Colors.amber,
                            style: TextStyle(
                                color: Colors.white, fontFamily: 'Raleway'),
                            keyboardType: TextInputType.number,
                            onChanged: (val) {
                              profit = int.parse(val);
                            },
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          margin: EdgeInsets.all(8),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Color.fromRGBO(38, 166, 154, 1)),
                            onPressed: () {
                              setState(() {
                                totalTrades = totalTrades + 1.0;
                                totalWins = totalWins + 1;
                                winCounter = winCounter + 1;
                                if (winCounter >= maxWin) {
                                  maxWin = winCounter;
                                }
                                lostCounter = 0;
                                balance = balance + profit;
                                flSpots.add(FlSpot(totalTrades, balance));
                                setChartData();
                              });
                            },
                            child: const Text(
                              '+PROFIT',
                              style: TextStyle(fontFamily: 'Raleway'),
                            ),
                          ),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                          width: 100,
                          margin: EdgeInsets.all(8),
                          child: TextFormField(
                            key: Key(loss.toString()),
                            initialValue: loss.toString(),
                            textAlign: TextAlign.center,
                            cursorColor: Colors.amber,
                            style: TextStyle(
                                color: Colors.white, fontFamily: 'Raleway'),
                            keyboardType: TextInputType.number,
                            onChanged: (val) {
                              loss = int.parse(val);
                            },
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          margin: EdgeInsets.all(8),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Color.fromRGBO(239, 83, 79, 1),
                            ),
                            onPressed: () {
                              setState(() {
                                totalTrades = totalTrades + 1;
                                totalLoss = totalLoss + 1;
                                balance = balance - loss;
                                lostCounter = lostCounter + 1;
                                if (lostCounter >= maxLost) {
                                  maxLost = lostCounter;
                                }
                                winCounter = 0;
                                if (balance <= 0) {
                                  showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                      title: Text(
                                        'Wow!',
                                        style: TextStyle(
                                          fontFamily: 'Raleway',
                                          color: Colors.white38,
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      content: Text(
                                        "ACCOUNT BLOWN!🤯",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'Raleway'),
                                      ),
                                    ),
                                  );
                                  resetAll();
                                } else {
                                  flSpots.add(FlSpot(totalTrades, balance));
                                  setChartData();
                                }
                              });
                            },
                            child: const Text(
                              '-LOSS',
                              style: TextStyle(fontFamily: 'Raleway'),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.all(10),
                child: SizedBox(
                    height: MediaQuery.of(context).size.height * .25,
                    width: MediaQuery.of(context).size.width * .9,
                    child: LineChart(data)),
              ),
              Container(
                margin: EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      margin: EdgeInsets.all(8),
                      child: Center(
                        child: Column(
                          children: [
                            Text(
                              '$maxWin',
                              style: TextStyle(
                                color: Colors.yellow[700],
                                fontFamily: 'Raleway',
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              'WON STREAK',
                              style: TextStyle(
                                  color: Colors.white38,
                                  fontFamily: 'Raleway',
                                  fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(8),
                      child: Center(
                        child: Column(
                          children: [
                            // Text(
                            //   numFormat.format(pl),
                            //   style: TextStyle(
                            //     color: pl >= 0
                            //         ? Colors.greenAccent
                            //         : Colors.redAccent,
                            //     fontFamily: 'Raleway',
                            //     fontSize: 16,
                            //   ),
                            // ),
                            // SizedBox(
                            //   height: 5,
                            // ),
                            Text(
                              '$plPe%',
                              style: TextStyle(
                                color: pl >= 0
                                    ? Colors.greenAccent
                                    : Colors.redAccent,
                                fontFamily: 'Raleway',
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              'P&L',
                              style: TextStyle(
                                  color: Colors.white38,
                                  fontFamily: 'Raleway',
                                  fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(8),
                      child: Center(
                        child: Column(
                          children: [
                            Text(
                              '$maxLost',
                              style: TextStyle(
                                color: Colors.yellow[700],
                                fontFamily: 'Raleway',
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              'LOST STREAK',
                              style: TextStyle(
                                  color: Colors.white38,
                                  fontFamily: 'Raleway',
                                  fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
