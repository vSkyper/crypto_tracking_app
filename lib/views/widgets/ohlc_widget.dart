import 'package:crypto_tracking/models/ohlc.api.dart';
import 'package:crypto_tracking/models/ohlc.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import 'package:syncfusion_flutter_charts/charts.dart';

class Ohlc extends StatefulWidget {
  final String id;

  const Ohlc({
    super.key,
    required this.id,
  });

  @override
  State<Ohlc> createState() => _OhlcState();
}

class _OhlcState extends State<Ohlc> {
  late List<OhlcModel> _ohlc;
  late Future _dataFuture;
  String _days = '7';
  final List<String> _daysList = ['1', '7', '30', '90', '180', '365', 'max'];

  @override
  void initState() {
    super.initState();

    _dataFuture = _fetchData();
  }

  Future _fetchData() async {
    try {
      _ohlc = await OhlcApi.getOhlc(widget.id, _days);
    } catch (e) {
      rethrow;
    }
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
              for (String i in _daysList)
                OutlinedButton(
                  onPressed: () => setState(() {
                    _days = i;
                    _dataFuture = _fetchData();
                  }),
                  style: OutlinedButton.styleFrom(
                    foregroundColor:
                        _days == i ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurface,
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
            if (snapshot.hasError) return const Center(child: Text('Something went wrong :('));
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
              case ConnectionState.active:
                return const Center(child: CircularProgressIndicator());
              case ConnectionState.done:
                return SfCartesianChart(
                  plotAreaBorderWidth: 0,
                  trackballBehavior: TrackballBehavior(
                    enable: true,
                    activationMode: ActivationMode.singleTap,
                    tooltipSettings: const InteractiveTooltip(
                      format: 'Date: point.x\nHigh: point.high\nLow: point.low\nOpen: point.open\nClose: point.close',
                    ),
                  ),
                  series: [
                    CandleSeries<OhlcModel, DateTime>(
                      dataSource: _ohlc,
                      xValueMapper: (OhlcModel data, _) => data.time,
                      lowValueMapper: (OhlcModel data, _) => data.low,
                      highValueMapper: (OhlcModel data, _) => data.high,
                      openValueMapper: (OhlcModel data, _) => data.open,
                      closeValueMapper: (OhlcModel data, _) => data.close,
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
            }
          },
        ),
      ],
    );
  }
}
