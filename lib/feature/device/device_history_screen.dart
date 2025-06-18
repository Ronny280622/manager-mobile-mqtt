import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:manager_mqtt/feature/device/device_history_controller.dart';
import 'package:manager_mqtt/feature/device/dto/data_device_dto.dart';
import 'package:provider/provider.dart';

class DeviceHistoryScreen extends StatefulWidget {
  const DeviceHistoryScreen({super.key});

  @override
  State<DeviceHistoryScreen> createState() => _DeviceHistoryScreenState();
}

class _DeviceHistoryScreenState extends State<DeviceHistoryScreen> {
  final controller = DeviceHistoryController();
  late final dynamic args;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((callback) async {
      args = ModalRoute.of(context)!.settings.arguments;
      if(args != null && args is int) {
        await controller.setDeviceId(context, args);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DeviceHistoryController>.value(
      value: controller,
      child: Consumer<DeviceHistoryController>(
        builder: (_, control, __) {
          return Scaffold(
            appBar: AppBar(
              title: Text("Historial"),
              actions: [
                IconButton(
                  onPressed: () {
                    control.showDialogFilter(context);
                  },
                  icon: Icon(Icons.filter_alt)
                )
              ],
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.only(
                  top: 10, left: 10, bottom: 10, right: 27),
              child: Column(
                children: control.dataByType.entries.map((entry) {
                  final String type = entry.key;
                  final Map<String, List<DataDeviceDto>> entradas = entry.value;

                  // Título descriptivo por tipo
                  String nameEntry = type == "1"
                      ? "Entradas Digitales"
                      : type == "2"
                      ? "Entradas Analógicas"
                      : "Entrada Serial";

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(nameEntry, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 25),
                      SizedBox(
                        height: 300,
                        child: ChartByType(entradaData: entradas),
                      ),
                      const SizedBox(height: 30),
                    ],
                  );
                }).toList(),
              ),
            ),

          );
        }
      ),
    );
  }
}

class ChartByType extends StatefulWidget {
  final Map<String, List<DataDeviceDto>> entradaData;

  const ChartByType({super.key, required this.entradaData});

  @override
  State<ChartByType> createState() => _ChartByTypeState();
}

class _ChartByTypeState extends State<ChartByType> {
  late Map<String, Color> entradaColors;
  late Map<String, bool> entradaVisible;

  @override
  void initState() {
    super.initState();

    entradaColors = {};
    entradaVisible = {};
    final palette = [
      Colors.blue,
      Colors.red,
      Colors.green,
    ];

    int colorIndex = 0;
    widget.entradaData.forEach((entrada, _) {
      entradaColors[entrada] = palette[colorIndex % palette.length];
      entradaVisible[entrada] = true;
      colorIndex++;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<LineChartBarData> lines = [];

    widget.entradaData.forEach((entrada, entries) {
      if (!(entradaVisible[entrada] ?? true)) return;

      entries.sort((a, b) => a.datetime.compareTo(b.datetime));

      final spots = entries.map((e) {
        final timestamp = e.datetime.millisecondsSinceEpoch.toDouble();
        return FlSpot(timestamp, e.value);
      }).toList();

      lines.add(LineChartBarData(
        spots: spots,
        isCurved: true,
        dotData: FlDotData(show: true),
        belowBarData: BarAreaData(show: false),
        barWidth: 2,
        color: entradaColors[entrada],
      ));
    });

    return Column(
      children: [
        SizedBox(
          height: 250,
          child: LineChart(
            LineChartData(
              lineBarsData: lines,
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    interval: 24 * 60 * 60 * 1000,
                    getTitlesWidget: (value, meta) {
                      final dt = DateTime.fromMillisecondsSinceEpoch(value.toInt());
                      final formatted = DateFormat('dd/MM HH:mm').format(dt);
                      return Text(formatted, style: const TextStyle(fontSize: 10));
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    interval: 1,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        value.toStringAsFixed(0),
                        style: const TextStyle(fontSize: 10),
                      );
                    },
                  ),
                ),
                topTitles: AxisTitles(),
                rightTitles: AxisTitles(),
              ),
              gridData: FlGridData(show: true),
              borderData: FlBorderData(show: true),
            ),
          ),
        ),
        const SizedBox(height: 15),
        Wrap(
          spacing: 12,
          children: entradaColors.entries.map((e) {
            final visible = entradaVisible[e.key]!;
            return GestureDetector(
              onTap: () {
                setState(() {
                  entradaVisible[e.key] = !visible;
                });
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    color: visible ? e.value : Colors.grey,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    e.key,
                    style: TextStyle(
                      color: visible ? Colors.black : Colors.grey,
                      decoration: visible ? null : TextDecoration.lineThrough,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

