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
  late Stream _streamFetchData;

  @override
  void initState() {
    super.initState();

    _streamFetchData = fetchData();
  }

  Stream fetchData() async* {
    _ohlc = await OhlcApi.getOhlc(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _streamFetchData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return SfCartesianChart(
            plotAreaBorderWidth: 0,
            trackballBehavior: TrackballBehavior(
              enable: true,
              activationMode: ActivationMode.singleTap,
            ),
            series: [
              CandleSeries<Ohlc, DateTime>(
                  dataSource: _ohlc,
                  xValueMapper: (Ohlc data, _) => data.time,
                  lowValueMapper: (Ohlc data, _) => data.low,
                  highValueMapper: (Ohlc data, _) => data.high,
                  openValueMapper: (Ohlc data, _) => data.open,
                  closeValueMapper: (Ohlc data, _) => data.close)
            ],
            primaryXAxis: DateTimeAxis(
              dateFormat: DateFormat.MMMd(),
              majorGridLines: const MajorGridLines(width: 0),
              axisLine: const AxisLine(width: 0),
            ),
            primaryYAxis: NumericAxis(
              majorGridLines: const MajorGridLines(width: 0),
              axisLine: const AxisLine(width: 0),
              isVisible: false,
              minimum: _ohlc.map<num>((e) => e.low).reduce(min) as double,
              maximum: _ohlc.map<num>((e) => e.high).reduce(max) as double,
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
