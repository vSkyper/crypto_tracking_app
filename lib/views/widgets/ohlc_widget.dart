import 'package:crypto_tracking_app/models/ohlc.api.dart';
import 'package:crypto_tracking_app/models/ohlc.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import 'package:syncfusion_flutter_charts/charts.dart';

class OhlcWidget extends StatefulWidget {
  final String id;

  const OhlcWidget({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  State<OhlcWidget> createState() => _OhlcWidgetState();
}

class _OhlcWidgetState extends State<OhlcWidget> {
  late List<Ohlc> _ohlc;
  late Future _dataFuture;
  String _days = '7';
  final List<String> _daysList = ['1', '7', '30', '90', '180', '365', 'max'];

  @override
  void initState() {
    super.initState();

    _dataFuture = fetchData();
  }

  Future fetchData() async {
    _ohlc = await OhlcApi.getOhlc(widget.id, _days);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: [
              for (var i in _daysList)
                OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _days = i;
                      _dataFuture = fetchData();
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    primary: _days == i ? Colors.blue : Colors.white,
                    minimumSize: const Size(10, 30),
                  ),
                  child: Text(i),
                ),
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        FutureBuilder(
          future: _dataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return SfCartesianChart(
                plotAreaBorderWidth: 0,
                trackballBehavior: TrackballBehavior(
                  enable: true,
                  activationMode: ActivationMode.singleTap,
                  tooltipSettings: const InteractiveTooltip(
                    format:
                        'Date: point.x\nHigh: point.high\nLow: point.low\nOpen: point.open\nClose: point.close',
                  ),
                ),
                series: [
                  CandleSeries<Ohlc, DateTime>(
                    dataSource: _ohlc,
                    xValueMapper: (Ohlc data, _) => data.time,
                    lowValueMapper: (Ohlc data, _) => data.low,
                    highValueMapper: (Ohlc data, _) => data.high,
                    openValueMapper: (Ohlc data, _) => data.open,
                    closeValueMapper: (Ohlc data, _) => data.close,
                  ),
                ],
                primaryXAxis: DateTimeAxis(
                  dateFormat: DateFormat.yMMMd(),
                  majorGridLines: const MajorGridLines(width: 0),
                  axisLine: const AxisLine(width: 0),
                ),
                primaryYAxis: NumericAxis(
                  majorGridLines: const MajorGridLines(width: 0),
                  axisLine: const AxisLine(width: 0),
                  isVisible: false,
                  minimum: _ohlc.map((e) => e.low).reduce(min) as double,
                  maximum: _ohlc.map((e) => e.high).reduce(max) as double,
                ),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ],
    );
  }
}
