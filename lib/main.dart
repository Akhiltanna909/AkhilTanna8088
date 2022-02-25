import 'package:dart_ping/dart_ping.dart';
import 'package:flutter/material.dart';
import 'package:ping_app/provider/ping_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PingProvider(),
      builder: (context, child) => Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton(
                child: const Text("Ping"),
                onPressed: () {
                  context.read<PingProvider>().startPing();
                },
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: context.watch<PingProvider>().pings.length,
                  itemBuilder: (context, index) {
                    String? seq;
                    String? ip;
                    String? time;
                    PingData data = context.read<PingProvider>().pings[index];
                    print(data);
                    if (index ==
                            context.read<PingProvider>().pings.length - 1 &&
                        data.summary != null) {
                      return Card(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                  "Total Summary Time: ${data.summary!.time!.inMilliseconds} ms"),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                  "Total Sum Time: ${context.read<PingProvider>().sum} ms"),
                            ),
                          ],
                        ),
                      );
                    }

                    if (data.response != null) {
                      seq = data.response!.seq.toString();
                      ip = data.response!.ip;
                      time = data.response!.time!.inMilliseconds.toString();
                    } else {
                      ip = data.error!.error.name;
                    }

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        visualDensity: VisualDensity.compact,
                        leading: Text(seq ?? "N/A"),
                        title: Text(ip!),
                        trailing: Text((time ?? "NA") + " ms"),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
