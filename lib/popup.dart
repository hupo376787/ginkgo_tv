import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ginkgo_tv/model/channel.dart';

class PupupWidget extends StatefulWidget {
  const PupupWidget({super.key});

  @override
  State<PupupWidget> createState() => _PupupWidgetState();
}

class _PupupWidgetState extends State<PupupWidget> {
  late List<Channel> chns;

  Future<void> getData() async {
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
            itemCount: chns.length,
            itemBuilder: (context, index) {
              return Container(
                child: Text('ddd'),
              );
            });
      },
    );
  }
}
