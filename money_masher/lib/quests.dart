import 'package:flutter/material.dart';
import "db.dart";

class Quests extends StatefulWidget {
  final int totalClicks;
  final List<int> clickTimes;
  const Quests({Key? key, required this.totalClicks, required this.clickTimes}) : super(key: key);

  @override
  _QuestsState createState() => _QuestsState();
}

class _QuestsState extends State<Quests> {
  List<Quest> questList = [];
  final db = DatabaseManager();

  @override
  void initState() {
    super.initState();
    loadQuests();
  }

  void loadQuests() async {
    var questsData = await db.getQuests();
    List<Quest> loadedQuests = [];

    for (var quest in questsData) {
      loadedQuests.add(Quest(
        id: quest['QuestID'] as int,
        title: quest['QuestName'] as String,
        goal: quest['Goal'] as int,
        timeLimit: quest['TimeLimit'] as int,
        completed: quest['Completed'] as int != 0,
      ));
    }

    setState(() {
      questList = loadedQuests;
    });
  }

  void checkQuestCompletion(int index) async {
    // Index is the index of the quest in the questList. Identify quests this way.
    int currentBoughtItems = await db.getShopItemsBought();
    int currentClicks = widget.totalClicks;
    List<int> clickTimes = widget.clickTimes;

    // Total Clicks Events.
    {}

    // Quick Click Events.
    if (clickTimes.length >= 100) {
      int oldestTime = clickTimes[clickTimes.length - 100];
      int latestTime = clickTimes[clickTimes.length - 1];
      // Examples. Not the same as what is set in the database.
      if (latestTime - oldestTime <= 60000) {
        print("100 clicks in 60 seconds!");
      }
      if (latestTime - oldestTime <= 45000) {
        print("100 clicks in 45 seconds!");
      }
      if (latestTime - oldestTime <= 30000) {
        print("100 clicks in 30 seconds!");
      }
    }
    
    // Shop Events.
    {}
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
              checkQuestCompletion(index);
              Color textColor = index % 2 == 0 ? Colors.white : Color.fromARGB(255, 245, 241, 2);
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
                  style: const TextStyle(color: Colors.white, fontSize: 14),
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
  final int id;
  final String title;
  final int goal;
  final int timeLimit;
  final bool completed;

  Quest({
    required this.id,
    required this.title,
    required this.goal,
    required this.timeLimit,
    required this.completed,
  });
}
