import 'package:aquafusion/prompts/insertnewabw.dart';
import 'package:aquafusion/services/feed_level_provider.dart';
import 'package:aquafusion/services/mqtt_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class All extends StatefulWidget {
  const All({Key? key}) : super(key: key);

  @override
  State<All> createState() => _AllState();
}

class _AllState extends State<All> {
  @override
  void initState() {
    super.initState();

    // Listen to feed level from MQTT
    if (mounted) {
        MQTTClientWrapper().feedLevel.listen((message) {
          double feedLevel = double.tryParse(message.toString()) ?? 0.0;
          // Update the feed level using Provider
          Provider.of<FeedLevelProvider>(context, listen: false).updateFeedLevel(feedLevel);
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FeedLevelProvider>(
      builder: (context, feedLevelProvider, child) {
        double feedLevel = feedLevelProvider.feedLevel;
        String feedStatus = feedLevel < 30 ? "Low Feed Levels" : "Normal";

        return SingleChildScrollView(
          child: Column(
            children: [
              // Your header and cards go here
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      "Feed Levels",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Icon(Icons.feed, size: 50, color: Colors.red),
                    Text(
                      "${feedLevel.toStringAsFixed(1)}%",
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // Deduct 10% of the feed level but ensure it doesn't go below 0
                            feedLevelProvider.updateFeedLevel((feedLevel * 0.9).clamp(0, double.infinity));
                          },
                          child: const Text("-10%"),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => InsertNewAbwPrompt(),
                            );
                          },
                          child: Text("Insert New ABW and Stocking Density"),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // Add 10% to the feed level
                            feedLevelProvider.updateFeedLevel(feedLevel * 1.1);
                          },
                          child: const Text("+10%"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
