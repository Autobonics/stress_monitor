import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:stress_monitor/ui/smart_widgets/online_status.dart';
import 'package:stacked/stacked.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart' as g;

import 'package:lottie/lottie.dart';

import 'home_viewmodel.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      onViewModelReady: (model) => model.onModelReady(),
      builder: (context, model, child) {
        // print(model.node?.lastSeen);
        return Scaffold(
            appBar: AppBar(
              title: const Text('Stress monitor'),
              centerTitle: true,
              actions: [IsOnlineWidget()],
            ),
            body: model.data != null
                ? const _HomeBody()
                : Center(child: Text("No data")));
      },
      viewModelBuilder: () => HomeViewModel(),
    );
  }
}

class _HomeBody extends ViewModelWidget<HomeViewModel> {
  const _HomeBody({Key? key}) : super(key: key, reactive: true);

  @override
  Widget build(BuildContext context, HomeViewModel model) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _TempMeter(value: model.data!.temp),
                  _AlchMeter(value: model.data!.gsr),
                ],
              ),
              Column(
                children: [
                  _Spo2Ind(value: model.data!.spo2),
                  _HeartRateInd(value: model.data!.heartRate)
                ],
              ),
              _GraphPlot(),
            ],
          ),
        ),
        if (!model.data!.isFinger) Positioned.fill(child: NoFinger())
      ],
    );
  }
}

class NoFinger extends StatelessWidget {
  const NoFinger({super.key});

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
      child: Center(
        child: Card(
          elevation: 10,
          color: Colors.black.withOpacity(0.5),
          child: Container(
            height: 250,
            width: 200,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Lottie.network(
                      'https://assets8.lottiefiles.com/packages/lf20_ls4tnvo4/finger/data.json'),
                  SizedBox(height: 20),
                  Text(
                    'Place your finger',
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Spo2Ind extends StatelessWidget {
  final int value;
  const _Spo2Ind({required this.value, super.key});

  @override
  Widget build(BuildContext context) {
    /// Returns the range pointer gauge

    return SfRadialGauge(
      title: GaugeTitle(text: "Oxygen"),
      axes: <RadialAxis>[
        RadialAxis(
            showLabels: false,
            showTicks: false,
            startAngle: 270,
            endAngle: 270,
            radiusFactor: 0.8,
            axisLineStyle: const AxisLineStyle(
                thicknessUnit: GaugeSizeUnit.factor, thickness: 0.15),
            annotations: <GaugeAnnotation>[
              GaugeAnnotation(
                  angle: 180,
                  widget: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "$value%",
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 60,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            "0",
                            style: TextStyle(
                                fontFamily: 'Times',
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.italic),
                          ),
                          Text(
                            ' / 100',
                            style: TextStyle(
                                fontFamily: 'Times',
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.italic),
                          ),
                        ],
                      ),
                    ],
                  )),
            ],
            pointers: <GaugePointer>[
              RangePointer(
                value: value.toDouble(),
                cornerStyle: g.CornerStyle.bothCurve,
                enableAnimation: true,
                animationDuration: 1200,
                sizeUnit: GaugeSizeUnit.factor,
                gradient: SweepGradient(
                    colors: <Color>[Color(0xFF6A6EF6), Color(0xFFDB82F5)],
                    stops: <double>[0.25, 0.75]),
                color: Color(0xFF00A8B5),
                width: 0.15,
              ),
            ]),
      ],
    );
  }
}

class _HeartRateInd extends StatelessWidget {
  final int value;
  const _HeartRateInd({required this.value, super.key});

  @override
  Widget build(BuildContext context) {
    /// Returns the range pointer gauge

    return SfRadialGauge(
      title: GaugeTitle(text: "Herat Rate"),
      axes: <RadialAxis>[
        RadialAxis(
            showLabels: false,
            showTicks: false,
            startAngle: 270,
            endAngle: 270,
            radiusFactor: 0.8,
            axisLineStyle: const AxisLineStyle(
                thicknessUnit: GaugeSizeUnit.factor, thickness: 0.15),
            annotations: <GaugeAnnotation>[
              GaugeAnnotation(
                  angle: 180,
                  widget: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        value.toString(),
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 60,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            "55",
                            style: TextStyle(
                                fontFamily: 'Times',
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.italic),
                          ),
                          Text(
                            ' / 130',
                            style: TextStyle(
                                fontFamily: 'Times',
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.italic),
                          ),
                        ],
                      ),
                    ],
                  )),
            ],
            pointers: <GaugePointer>[
              RangePointer(
                value: value.toDouble(),
                cornerStyle: g.CornerStyle.bothCurve,
                enableAnimation: true,
                animationDuration: 1200,
                sizeUnit: GaugeSizeUnit.factor,
                gradient: SweepGradient(
                    colors: <Color>[Color(0xFF6A6EF6), Color(0xFFDB82F5)],
                    stops: <double>[0.25, 0.75]),
                color: Color(0xFF00A8B5),
                width: 0.15,
              ),
            ]),
      ],
    );
  }
}

class _AlchMeter extends ViewModelWidget<HomeViewModel> {
  final int value;
  const _AlchMeter({required this.value, Key? key})
      : super(key: key, reactive: true);

  @override
  Widget build(BuildContext context, HomeViewModel model) {
    Widget _buildThermometer(BuildContext context) {
      final Brightness brightness = Theme.of(context).brightness;
      return Center(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            /// Linear gauge to display celsius scale.
            SfLinearGauge(
              minimum: 0,
              maximum: 4095,
              interval: 600,
              minorTicksPerInterval: 2,
              axisTrackExtent: 23,
              axisTrackStyle: LinearAxisTrackStyle(
                  thickness: 12,
                  color: Colors.white,
                  borderWidth: 1,
                  edgeStyle: LinearEdgeStyle.bothCurve),
              tickPosition: LinearElementPosition.outside,
              labelPosition: LinearLabelPosition.outside,
              orientation: LinearGaugeOrientation.vertical,
              markerPointers: <LinearMarkerPointer>[
                LinearWidgetPointer(
                    markerAlignment: LinearMarkerAlignment.end,
                    value: 4095,
                    enableAnimation: false,
                    position: LinearElementPosition.outside,
                    offset: 8,
                    child: SizedBox(
                      height: 30,
                      child: Text(
                        'GSR',
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    )),
                LinearShapePointer(
                  value: 0,
                  markerAlignment: LinearMarkerAlignment.start,
                  shapeType: LinearShapePointerType.rectangle,
                  borderWidth: 1,
                  color: Colors.deepPurpleAccent,
                  position: LinearElementPosition.cross,
                  width: 24,
                  height: 24,
                ),
              ],
              barPointers: <LinearBarPointer>[
                LinearBarPointer(
                  value: value.toDouble(),
                  enableAnimation: false,
                  thickness: 6,
                  edgeStyle: LinearEdgeStyle.endCurve,
                  color: Colors.deepPurpleAccent,
                )
              ],
            ),
          ],
        ),
      ));
    }

    return _buildThermometer(context);
  }
}

class _TempMeter extends ViewModelWidget<HomeViewModel> {
  final double value;
  const _TempMeter({required this.value, Key? key})
      : super(key: key, reactive: true);

  @override
  Widget build(BuildContext context, HomeViewModel model) {
    Widget _buildThermometer(BuildContext context) {
      final Brightness brightness = Theme.of(context).brightness;
      return Column(
        children: [
          Center(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                /// Linear gauge to display celsius scale.
                SfLinearGauge(
                  minimum: -20,
                  maximum: 50,
                  interval: 10,
                  minorTicksPerInterval: 2,
                  axisTrackExtent: 23,
                  axisTrackStyle: LinearAxisTrackStyle(
                      thickness: 12,
                      color: Colors.white,
                      borderWidth: 1,
                      edgeStyle: LinearEdgeStyle.bothCurve),
                  tickPosition: LinearElementPosition.outside,
                  labelPosition: LinearLabelPosition.outside,
                  orientation: LinearGaugeOrientation.vertical,
                  markerPointers: <LinearMarkerPointer>[
                    LinearWidgetPointer(
                        markerAlignment: LinearMarkerAlignment.end,
                        value: 50,
                        enableAnimation: false,
                        position: LinearElementPosition.outside,
                        offset: 8,
                        child: SizedBox(
                          height: 30,
                          child: Text(
                            '°C',
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        )),
                    LinearShapePointer(
                      value: -20,
                      markerAlignment: LinearMarkerAlignment.start,
                      shapeType: LinearShapePointerType.circle,
                      borderWidth: 1,
                      borderColor: brightness == Brightness.dark
                          ? Colors.white30
                          : Colors.black26,
                      color: value > 37
                          ? const Color(0xffFF7B7B)
                          : const Color(0xff0074E3),
                      position: LinearElementPosition.cross,
                      width: 24,
                      height: 24,
                    ),
                    LinearShapePointer(
                      value: -20,
                      markerAlignment: LinearMarkerAlignment.start,
                      shapeType: LinearShapePointerType.circle,
                      borderWidth: 6,
                      borderColor: Colors.transparent,
                      color: value > 37
                          ? const Color(0xffFF7B7B)
                          : const Color(0xff0074E3),
                      position: LinearElementPosition.cross,
                      width: 24,
                      height: 24,
                    ),
                    LinearWidgetPointer(
                        value: -20,
                        markerAlignment: LinearMarkerAlignment.start,
                        child: Container(
                          width: 10,
                          height: 3.4,
                          decoration: BoxDecoration(
                            border: Border(
                              left: BorderSide(width: 2.0, color: Colors.black),
                              right:
                                  BorderSide(width: 2.0, color: Colors.black),
                            ),
                            color: value > 37
                                ? const Color(0xffFF7B7B)
                                : const Color(0xff0074E3),
                          ),
                        )),
                    // LinearWidgetPointer(
                    //     value: value,
                    //     enableAnimation: false,
                    //     position: LinearElementPosition.outside,
                    //     // onChanged: (dynamic value) {
                    //     //   setState(() {
                    //     //     _meterValue = value as double;
                    //     //   });
                    //     // },
                    //     child: Container(
                    //         width: 16,
                    //         height: 12,
                    //         transform: Matrix4.translationValues(4, 0, 0.0),
                    //         child: Image.asset(
                    //           'images/triangle_pointer.png',
                    //           color: value > 30
                    //               ? const Color(0xffFF7B7B)
                    //               : const Color(0xff0074E3),
                    //         ))),
                    LinearShapePointer(
                      value: value,
                      width: 20,
                      height: 20,
                      enableAnimation: false,
                      color: Colors.transparent,
                      position: LinearElementPosition.cross,
                      // onChanged: (dynamic value) {
                      //   setState(() {
                      //     _meterValue = value as double;
                      //   });
                      // },
                    )
                  ],
                  barPointers: <LinearBarPointer>[
                    LinearBarPointer(
                      value: value,
                      enableAnimation: false,
                      thickness: 6,
                      edgeStyle: LinearEdgeStyle.endCurve,
                      color: value > 37
                          ? const Color(0xffFF7B7B)
                          : const Color(0xff0074E3),
                    )
                  ],
                ),

                /// Linear gauge to display Fahrenheit  scale.
                Container(
                    transform: Matrix4.translationValues(-6, 0, 0.0),
                    child: SfLinearGauge(
                      maximum: 120,
                      showAxisTrack: false,
                      interval: 20,
                      minorTicksPerInterval: 0,
                      axisTrackExtent: 24,
                      axisTrackStyle: const LinearAxisTrackStyle(thickness: 0),
                      orientation: LinearGaugeOrientation.vertical,
                      markerPointers: <LinearMarkerPointer>[
                        LinearWidgetPointer(
                            markerAlignment: LinearMarkerAlignment.end,
                            value: 120,
                            position: LinearElementPosition.inside,
                            offset: 6,
                            enableAnimation: false,
                            child: SizedBox(
                              height: 30,
                              child: Text(
                                '°F',
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                            )),
                      ],
                    ))
              ],
            ),
          )),
        ],
      );
    }

    return _buildThermometer(context);
  }
}

// class _RainGageMeter extends ViewModelWidget<HomeViewModel> {
//   const _RainGageMeter({Key? key})
//       : super(key: key, reactive: true);
//
//   @override
//   Widget build(BuildContext context, HomeViewModel model) {
//     return Card(
//       child: Container(
//         height: 175,
//         width: 175,
//         child: SfRadialGauge(
//           title: GaugeTitle(
//               text: "Moisture",
//               textStyle: Theme.of(context).textTheme.bodyLarge!),
//           axes: <RadialAxis>[
//             RadialAxis(
//                 showLabels: false,
//                 showAxisLine: false,
//                 showTicks: false,
//                 minimum: 0,
//                 maximum: isRain ? 250 : 80,
//                 ranges: <GaugeRange>[
//                   GaugeRange(
//                     startValue: 0,
//                     endValue: isRain ? 62.5 : 20,
//                     color: Colors.green,
//                     sizeUnit: GaugeSizeUnit.factor,
//                     startWidth: 0.5,
//                     endWidth: 0.5,
//                   ),
//                   GaugeRange(
//                     startValue: isRain ? 62.5 : 20,
//                     endValue: isRain ? 125 : 40,
//                     color: Colors.yellow,
//                     startWidth: 0.5,
//                     endWidth: 0.5,
//                     sizeUnit: GaugeSizeUnit.factor,
//                   ),
//                   GaugeRange(
//                     startValue: isRain ? 125 : 40,
//                     endValue: isRain ? 187.5 : 60,
//                     color: Colors.deepOrangeAccent,
//                     sizeUnit: GaugeSizeUnit.factor,
//                     startWidth: 0.5,
//                     endWidth: 0.5,
//                   ),
//                   GaugeRange(
//                     startValue: isRain ? 187.5 : 60,
//                     endValue: isRain ? 250 : 80,
//                     color: Colors.red,
//                     sizeUnit: GaugeSizeUnit.factor,
//                     startWidth: 0.5,
//                     endWidth: 0.5,
//                   ),
//                 ],
//                 pointers: <GaugePointer>[
//                   NeedlePointer(
//                     value: isRain
//                         ? model.node?.ph.toDouble() ?? 0
//                         : model.node?.waterFLow.toDouble() ?? 0,
//                   )
//                 ])
//           ],
//         ),
//       ),
//     );
//   }
// }

class _GraphPlot extends ViewModelWidget<HomeViewModel> {
  const _GraphPlot({Key? key}) : super(key: key, reactive: true);

  @override
  Widget build(BuildContext context, HomeViewModel model) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.only(top: 12.0),
        child: Column(
          children: [
            Text("Heart rate graph",
                style: Theme.of(context).textTheme.bodyLarge!),
            SfCartesianChart(
                plotAreaBorderWidth: 0,
                primaryXAxis:
                    NumericAxis(majorGridLines: const MajorGridLines(width: 0)),
                primaryYAxis: NumericAxis(
                    axisLine: const AxisLine(width: 0),
                    majorTickLines: const MajorTickLines(size: 0)),
                series: <LineSeries<ChartData, int>>[
                  LineSeries<ChartData, int>(
                    onRendererCreated: (ChartSeriesController controller) {
                      model.chartSeriesController = controller;
                    },
                    dataSource: model.chartData!,
                    color: Colors.blue,
                    xValueMapper: (ChartData reading, _) => reading.time,
                    yValueMapper: (ChartData reading, _) => reading.heartRate,
                    animationDuration: 0,
                  ),
                  // LineSeries<ChartData, int>(
                  //   onRendererCreated: (ChartSeriesController controller) {
                  //     model.chartSeriesController = controller;
                  //   },
                  //   dataSource: model.chartData!,
                  //   color: const Color.fromRGBO(192, 108, 132, 1),
                  //   xValueMapper: (ChartData reading, _) => reading.time,
                  //   yValueMapper: (ChartData reading, _) => reading.y,
                  //   animationDuration: 0,
                  // ),
                  // LineSeries<ChartData, int>(
                  //   onRendererCreated: (ChartSeriesController controller) {
                  //     model.chartSeriesController = controller;
                  //   },
                  //   dataSource: model.chartData!,
                  //   color: const Color.fromRGBO(192, 108, 132, 1),
                  //   xValueMapper: (ChartData reading, _) => reading.time,
                  //   yValueMapper: (ChartData reading, _) => reading.z,
                  //   animationDuration: 0,
                  // ),
                ]),
          ],
        ),
      ),
    );
  }
}
