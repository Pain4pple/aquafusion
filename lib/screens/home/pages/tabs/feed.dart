import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

void main() => runApp(Feed());

class Feed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Feed Tracker',
      home: FeedScreen(),
    );
  }
}

class FeedScreen extends StatefulWidget {
  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  double monthlyFeedUsage = 0.0; // Placeholder for fetched data
  List<FlSpot> feedUsageData = []; // Placeholder for fetched graph data
  List<Map<String, dynamic>> feedingTable = []; // Placeholder for fetched table data

  @override
  void initState() {
    super.initState();
    _fetchDataFromDatabase();
  }

  // Mock database fetch
  Future<void> _fetchDataFromDatabase() async {
    if (!mounted) return;
    setState(() {
      monthlyFeedUsage = 40.0; // Example value
      feedUsageData = [
        FlSpot(1, 5),
        FlSpot(2, 8),
        FlSpot(3, 6),
        FlSpot(4, 9),
        FlSpot(5, 12),
        FlSpot(6, 14),
      ];
      feedingTable = [
        {
          "Life Stage": "Fry",
          "ABW Range (g)": "<10",
          "Feeding Rate (% ABW)": "10-20",
          "Days of Culture": "1-40 Days"
        },
        {
          "Life Stage": "Fingerling",
          "ABW Range (g)": "10-25",
          "Feeding Rate (% ABW)": "7-10",
          "Days of Culture": "41-90 Days"
        },
        {
          "Life Stage": "Juvenile",
          "ABW Range (g)": "25-80",
          "Feeding Rate (% ABW)": "4-7",
          "Days of Culture": "91-120 Days"
        },
        {
          "Life Stage": "Grower",
          "ABW Range (g)": ">80",
          "Feeding Rate (% ABW)": "3-4",
          "Days of Culture": "121-150 Days"
        },
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.analytics), label: "Analytics"),
          BottomNavigationBarItem(icon: Icon(Icons.fastfood), label: "Feed"),
          BottomNavigationBarItem(icon: Icon(Icons.report), label: "Reports"),
        ],
        selectedItemColor: Colors.blue,
        backgroundColor: Colors.white, // Set background to blue
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FeedUsageCard(feedUsage: monthlyFeedUsage),
              SizedBox(height: 20),
              SizedBox(
                height: 200, // Allocate fixed height for graph
                child: FeedUsageGraph(data: feedUsageData),
              ),
              SizedBox(height: 20),
              FeedingTable(data: feedingTable),
            ],
          ),
        ),
      ),
    );
  }
}

class FeedUsageCard extends StatelessWidget {
  final double feedUsage;

  FeedUsageCard({required this.feedUsage});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "Amount of Feeds",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "$feedUsage kg",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.green),
            ),
            Text("Feed Usage past 3 weeks"),
          ],
        ),
      ),
    );
  }
}

class FeedUsageGraph extends StatelessWidget {
  final List<FlSpot> data;

  FeedUsageGraph({required this.data});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LineChart(
          LineChartData(
            gridData: FlGridData(show: true),
            titlesData: FlTitlesData(show: true),
            borderData: FlBorderData(show: true),
            minX: 0,
            maxX: 7,
            minY: 0,
            maxY: 20,
            lineBarsData: [
              LineChartBarData(
                spots: data,
                isCurved: true,
                barWidth: 4,
                color: Colors.blue,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FeedingTable extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  FeedingTable({required this.data});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "Feeding Table",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  DataColumn(label: Text("Life Stage")),
                  DataColumn(label: Text("ABW Range (g)")),
                  DataColumn(label: Text("Feeding Rate (% ABW)")),
                  DataColumn(label: Text("Days of Culture")),
                ],
                rows: data
                    .map(
                      (row) => DataRow(
                        cells: [
                          DataCell(Text(row["Life Stage"])),
                          DataCell(Text(row["ABW Range (g)"])),
                          DataCell(Text(row["Feeding Rate (% ABW)"])),
                          DataCell(Text(row["Days of Culture"])),
                        ],
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
