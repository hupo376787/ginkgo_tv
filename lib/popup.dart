import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ginkgo_tv/model/channel.dart';

class PupupWidget extends StatefulWidget {
  const PupupWidget({super.key});

  @override
  State<PupupWidget> createState() => _PupupWidgetState();
}

class _PupupWidgetState extends State<PupupWidget> {
  late List<Channel> chns = <Channel>[];

  Future<void> getData() async {
    if (chns.isNotEmpty) return;
    rootBundle
        .loadString("assets/file/channels.json")
        .then((value) => setState(() {
              debugPrint(value);
              chns = channelFromJson(value);
            }));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getData(),
      builder: (context, snapshot) {
        return ListView.builder(
            shrinkWrap: true,
            itemCount: chns.length,
            itemBuilder: (context, index) {
              return UnconstrainedBox(
                child: Container(
                  color: Colors.white.withOpacity(0.5),
                  width: 300,
                  height: 50,
                  child: Text(
                    'CCTV1 综合',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              );
            });
      },
    );
  }
}
