import 'dart:async';
import 'package:flutter/material.dart';

void main() => runApp(const EventCountdownApp());

class EventCountdownApp extends StatelessWidget {
  const EventCountdownApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Event Countdown Timer',
      home: CountdownPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class CountdownPage extends StatefulWidget {
  @override
  _CountdownPageState createState() => _CountdownPageState();
}

class _CountdownPageState extends State<CountdownPage> {
  final TextEditingController _eventController = TextEditingController();
  final List<Map<String, dynamic>> _events = [];
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      setState(() {});
    });
  }

  void _addEvent(String eventName, DateTime date) {
    setState(() {
      _events.add({'name': eventName, 'date': date});
    });
  }

  void _deleteEvent(int index) {
    setState(() {
      _events.removeAt(index);
    });
  }

  String _formatCountdown(DateTime eventDate) {
    final now = DateTime.now();
    final difference = eventDate.difference(now);

    if (difference.isNegative) {
      return "Event Passed";
    }

    final days = difference.inDays;
    final hours = difference.inHours % 24;
    final minutes = difference.inMinutes % 60;
    final seconds = difference.inSeconds % 60;

    return "$days days, $hours hours, $minutes minutes, $seconds seconds";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Event Countdown Timer'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _eventController,
              decoration: InputDecoration(
                labelText: 'Event Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100),
                ).then((selectedDate) {
                  if (selectedDate != null && _eventController.text.isNotEmpty) {
                    _addEvent(_eventController.text, selectedDate);
                    _eventController.clear();
                  }
                });
              },
              child: Text('Add Event'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: _events.isEmpty
                  ? Center(
                child: Text(
                  'No events added',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              )
                  : ListView.builder(
                itemCount: _events.length,
                itemBuilder: (context, index) {
                  final event = _events[index];
                  return Card(
                    child: ListTile(
                      title: Text(event['name']),
                      subtitle: Text(_formatCountdown(event['date'])),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteEvent(index),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
