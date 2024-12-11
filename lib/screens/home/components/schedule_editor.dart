import 'package:aquafusion/services/mqtt_service.dart';
import 'package:aquafusion/services/providers/schedule_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ScheduleEditor extends StatelessWidget {
  const ScheduleEditor({super.key});

  void publishToMQTT(String data) {
    // Publish using MQTT Singleton
    final mqttSingleton = MQTTClientWrapper();
    mqttSingleton.publishMessage('aquafusion/001/command/new_sched', data, false);
    print('Published: $data');
  }

  Future<void> showAddDialog(BuildContext context, scheduleProvider provider) async {
    TextEditingController controller = TextEditingController();
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Schedule'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(labelText: 'Enter time (e.g., 9:00)'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                provider.addSchedule(controller.text);
                publishToMQTT(provider.getFormattedSchedules());
              }
              Navigator.of(context).pop();
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }

  Future<void> showEditDialog(BuildContext context, scheduleProvider provider, int index) async {
    TextEditingController controller = TextEditingController(text: provider.schedules[index]);
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Schedule'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(labelText: 'Enter new time (e.g., 9:00)'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                provider.editSchedule(index, controller.text);
                publishToMQTT(provider.getFormattedSchedules());
              }
              Navigator.of(context).pop();
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Schedule Editor'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              final provider = Provider.of<scheduleProvider>(context, listen: false);
              showAddDialog(context, provider);
            },
          ),
        ],
      ),
      body: Consumer<scheduleProvider>(
        builder: (context, provider, child) {
          return ListView.builder(
            itemCount: provider.schedules.length,
            itemBuilder: (context, index) {
              return Card(
                margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: ListTile(
                  title: Text(provider.schedules[index]),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          showEditDialog(context, provider, index);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          provider.deleteSchedule(index);
                          publishToMQTT(provider.getFormattedSchedules());
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
