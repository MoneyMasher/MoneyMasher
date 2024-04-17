import 'package:flutter/material.dart';

class Quests extends StatefulWidget {
  final int totalClicks;
  const Quests({Key? key, required this.totalClicks, required List<Quest> questList}) : super(key: key);

  @override
  _QuestsState createState() => _QuestsState();
}

class _QuestsState extends State<Quests> {
  late List<Quest> questList;

  @override
  void initState() {
    super.initState();
    questList = [
      Quest(title: "Click 100 Times", goal: 100),
      Quest(title: "Click 1,000 Times", goal: 1000),
      Quest(title: "Click 5,000 Times", goal: 5000),
      Quest(title: "Click 100 Times in 60 Seconds", goal: 100, isTimed: true, timeLimit: 60),
      Quest(title: "Click 100 Times in 45 Seconds", goal: 100, isTimed: true, timeLimit: 45),
      Quest(title: "Click 100 Times in 30 Seconds", goal: 100, isTimed: true, timeLimit: 30),
    ];
  }

  @override
Widget build(BuildContext context) {
  return Column(
    children: [
      Container(
        color: Colors.black.withOpacity(0.9),
        width: double.infinity,
        padding: const EdgeInsets.all(8),
        child: const Align(
          alignment: Alignment.center,
          child: Text(
            "Quests",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18),
          ),
        ),
      ),
      Expanded(
        child: ListView.builder(
          itemCount: questList.length,
          itemBuilder: (context, index) {
            var quest = questList[index];
            int progressClicks = widget.totalClicks.clamp(0, quest.goal);
            Color textColor = index % 2 == 0 ? Colors.white : Color.fromARGB(255, 245, 241, 2); // Alternate color
            return ListTile(
              title: Text(
                quest.title,
                style: TextStyle(
                  color: textColor,
                  fontSize: 16,
                ),
              ),
              subtitle: LinearProgressIndicator(
                value: progressClicks / quest.goal,
                backgroundColor: Colors.grey,
                color: Colors.green,
              ),
              trailing: Text(
                "$progressClicks / ${quest.goal}",
                style: const TextStyle(color: Colors.white, fontSize: 14), // Larger text
              ),
            );
          },
        ),
      ),
    ],
  );
 }
}

class Quest {
  final String title;
  final int goal;
  final bool isTimed;
  final int? timeLimit;

  Quest({
    required this.title,
    required this.goal,
    this.isTimed = false,
    this.timeLimit,
  });
}
