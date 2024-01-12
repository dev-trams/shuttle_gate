import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:latlong2/latlong.dart';
import 'package:shuttle_gate/models/model_core.dart';
import 'package:shuttle_gate/models/model_r1.dart';
import 'package:shuttle_gate/services/service_api_core.dart';
import 'package:shuttle_gate/widgets/columnorrow.dart';
import 'package:url_launcher/url_launcher.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final List<LatLng> busRoute = [
    const LatLng(37.733302, 127.212573), // 초기 위치
    const LatLng(37.733302, 127.212223),
    const LatLng(37.733422, 127.212173),
    const LatLng(37.733622, 127.211958),
    const LatLng(37.733800, 127.211960),
    const LatLng(37.734400, 127.213000),
  ];

  Timer? timer;
  int currentPosition = 0;
  int r1currentPosition = 0;
  int r2currentPosition = 0;
  int r3currentPosition = 0;
  int r4currentPosition = 0;
  int seconds = 3;
  bool polyLineVisible = false;
  bool processState = true;

  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: seconds), (Timer) {
      setState(() {
        currentPosition = (currentPosition + 1) % busRoute.length;
        r1currentPosition = (r1currentPosition + 1) % R1Model().r1.length;
        r2currentPosition = (r2currentPosition + 2) % R1Model().r2.length;
        r3currentPosition = (r3currentPosition + 1) % R1Model().r3.length;
        r4currentPosition = (r4currentPosition + 1) % R1Model().r4.length;
      });
    });
  }

  final List<double> defaultStation = [37.733332, 127.212573];
  @override
  void dispose() {
    timer?.cancel(); // 위젯이 dispose될 때 타이머 종료
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ColOrRowWidget(
        state: MediaQuery.of(context).size.width > 600 ? true : false,
        children: [
          Flexible(
            flex: 2,
            child: FlutterMap(
              options: MapOptions(
                center: LatLng(busRoute[currentPosition].latitude,
                    busRoute[currentPosition].longitude),
                zoom: 18,
              ),
              children: [
                TileLayer(
                  urlTemplate: '//tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.kakao_map_example',
                ),
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: busRoute,
                      strokeWidth: 5.0,
                      color: polyLineVisible ? Colors.blue : Colors.transparent,
                    ),
                    Polyline(
                      points: R1Model().r4,
                      strokeWidth: 5.0,
                      color: polyLineVisible ? Colors.red : Colors.transparent,
                    ),
                    Polyline(
                      points: R1Model().r3,
                      strokeWidth: 5.0,
                      color:
                          polyLineVisible ? Colors.yellow : Colors.transparent,
                    ),
                    Polyline(
                      points: R1Model().r2,
                      strokeWidth: 5.0,
                      color: polyLineVisible ? Colors.blue : Colors.transparent,
                    ),
                    Polyline(
                      points: R1Model().r1,
                      strokeWidth: 5.0,
                      color: polyLineVisible
                          ? Colors.deepPurple
                          : Colors.transparent,
                    )
                  ],
                ),
                MarkerLayer(
                  markers: [
                    BusMarker(
                      busNum: "BUS001",
                      x: busRoute[currentPosition].latitude,
                      y: busRoute[currentPosition].longitude,
                    ),
                    BusMarker(
                      busNum: "BUS002",
                      x: R1Model().r4[r4currentPosition].latitude,
                      y: R1Model().r4[r4currentPosition].longitude,
                    ),
                    BusMarker(
                      busNum: "BUS003",
                      x: R1Model().r3[r3currentPosition].latitude,
                      y: R1Model().r3[r3currentPosition].longitude,
                    ),
                    BusMarker(
                      busNum: "BUS004",
                      x: R1Model().r2[r2currentPosition].latitude,
                      y: R1Model().r2[r2currentPosition].longitude,
                    ),
                    BusMarker(
                      busNum: "BUS005",
                      x: R1Model().r1[r1currentPosition].latitude,
                      y: R1Model().r1[r1currentPosition].longitude,
                    ),
                    newMarker(
                      point: const LatLng(37.651703, 127.177178),
                    ),
                    newMarker(),
                    newMarker(),
                    newMarker(),
                    newMarker(),
                  ],
                ),
              ],
            ),
          ),
          Flexible(
            flex: 1,
            child: processState
                ? FutureBuilder(
                    future: CoreApiService().fetchCoreData(),
                    builder: (builder, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            var busData = snapshot.data![index];
                            return Text(busData.bid!);
                          },
                        );
                      } else {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const CircularProgressIndicator(
                                color: Colors.blue,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Text(snapshot.hasData ? '로딩중...' : '데이터가 없습니다.')
                            ],
                          ),
                        );
                      }
                    },
                  )
                : ListView.builder(
                    itemCount: 5,
                    itemBuilder: (context, index) => Center(
                      child: Container(
                        height: 60,
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.black,
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.directions_bus),
                            Expanded(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text('BUS00${index + 1}'),
                                  Text('경복대 <-> 종점${index + 1}'),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
          )
        ],
      ),
    );
  }

  Marker newMarker({
    LatLng? point,
    IconData? icon,
    Color? color,
    double? size,
  }) {
    return Marker(
      point: point ?? const LatLng(37.733255, 127.212641),
      builder: (ctx) => Icon(
        icon ?? Icons.bus_alert,
        size: size ?? 25,
        color: Colors.white,
        shadows: [
          Shadow(
            color: color ?? Colors.black,
            blurRadius: 20,
          )
        ],
      ),
    );
  }

  Marker BusMarker({
    double? x,
    double? y,
    required String busNum,
    Color? busColor,
  }) {
    return Marker(
      width: 100,
      height: 100,
      point: LatLng((x ?? defaultStation[0]), (y ?? defaultStation[1])),
      builder: (ctx) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              Icons.airport_shuttle_outlined,
              color: busColor ?? Colors.white,
              shadows: const [
                Shadow(
                  color: Colors.black,
                  blurRadius: 20,
                )
              ],
              size: 30,
            ),
            SizedBox(
              child: Text(
                busNum,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  backgroundColor: Colors.black,
                ),
              ),
            )
          ],
        );
      },
    );
  }
}
