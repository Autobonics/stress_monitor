import 'dart:async';

import 'package:stress_monitor/models/models.dart';
import 'package:stress_monitor/services/db_service.dart';
import 'package:stacked/stacked.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.logger.dart';
// import '../../setup_snackbar_ui.dart';

class HomeViewModel extends ReactiveViewModel {
  final log = getLogger('HomeViewModel');

  // final _snackBarService = locator<SnackbarService>();
  // final _navigationService = locator<NavigationService>();
  final _dbService = locator<DbService>();

  DeviceData? get data => _dbService.node;

  bool _isStress = false;
  bool get isStress => _isStress;

  @override
  List<DbService> get reactiveServices => [_dbService];

  //=========Chart============
  Timer? timer;
  List<ChartData>? chartData;
  late int count;
  ChartSeriesController? chartSeriesController;

  void onModelReady() {
    count = 19;
    chartData = <ChartData>[];
    for (int i = 0; i < 19; i++) {
      chartData!.add(ChartData(i, 0));
    }
    timer =
        Timer.periodic(const Duration(milliseconds: 1000), _updateDataSource);
  }

  void setStress() {
    _isStress = !_isStress;
    notifyListeners();
  }

  void calStress() {
    if (data != null && data!.gsr > 600 && data!.heartRate > 76) {
      _isStress = true;
      notifyListeners();
    }
  }

  void _updateDataSource(Timer timer) {
    calStress();
    chartData!.add(ChartData(count, data?.heartRate ?? 0));
    if (chartData!.length == 20) {
      chartData!.removeAt(0);
      chartSeriesController?.updateDataSource(
        addedDataIndexes: <int>[chartData!.length - 1],
        removedDataIndexes: <int>[0],
      );
    } else {
      chartSeriesController?.updateDataSource(
        addedDataIndexes: <int>[chartData!.length - 1],
      );
    }
    count = count + 1;
  }

  @override
  void dispose() {
    timer?.cancel();
    chartData!.clear();
    chartSeriesController = null;
    super.dispose();
  }
}

class ChartData {
  ChartData(
    this.time,
    this.heartRate,
  );
  final int time;
  final int heartRate;
}
