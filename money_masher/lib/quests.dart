import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import "db.dart";

class Quests extends StatefulWidget {
  final int totalClicks;
  final List<int> clickTimes;
  final int shopItemsBought;
  final Function(int) updateRewards;
  
  const Quests({
    Key? key, 
    required this.totalClicks, 
    required this.clickTimes, 
    required this.shopItemsBought,
    required this.updateRewards,
    }) : super(key: key);

  @override
  QuestsState createState() => QuestsState();
}

class QuestsState extends State<Quests> {
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
        type: quest['QuestType'] as String,
        goal: quest['Goal'] as int,
        reward: quest['Reward'] as int,
        timeLimit: quest['TimeLimit'] as int,
        completed: quest['Completed'] as int != 0,
      ));
    }

    setState(() {
      questList = loadedQuests;
    });
  }

  void checkQuestCompletion() async {
    int currentBoughtItems = widget.shopItemsBought;
    int currentClicks = widget.totalClicks;
    List<int> clickTimes = widget.clickTimes;

    for (var quest in questList) {
      if (quest.type == "Click") {
        if (!quest.completed && currentClicks >= quest.goal) {
          quest.completed = true;
          await db.updateQuestCompletion(quest.id, 1);
          setState(() {
            widget.updateRewards(quest.reward);
          });
        }
        if (currentClicks > quest.goal) {
          currentClicks = quest.goal;
        }
        quest.progressPercent = clampDouble(currentClicks / quest.goal, 0, 100);
        quest.progress = currentClicks;
      } else if (quest.type == "Quick") {
        if (clickTimes.isEmpty) {
          continue;
        }
        int goal = quest.goal;
        int absGoal = clickTimes.length < goal ? clickTimes.length : goal;
        int oldestClickTime = clickTimes[clickTimes.length - absGoal];
        int latestClickTime = clickTimes[clickTimes.length - 1];
        int clicksWithinTimeLimit = 0;
        for (int i = clickTimes.length - absGoal; i < clickTimes.length; i++) {
          if (clickTimes[i] >= latestClickTime - (quest.timeLimit * 1000)) {
            clicksWithinTimeLimit++;
          }
        }
        int timeBetweenLatestAndOldest = latestClickTime - oldestClickTime;
        if (!quest.completed && timeBetweenLatestAndOldest <= (quest.timeLimit * 1000) && clickTimes.length >= goal) {
          quest.completed = true;
          await db.updateQuestCompletion(quest.id, 1);
          setState(() {
            widget.updateRewards(quest.reward);
          });
          quest.progressPercent = 100;
          quest.progress = goal;
        } else {
          if (clicksWithinTimeLimit > goal) {
            clicksWithinTimeLimit = goal;
          }
          quest.progressPercent = clampDouble(clicksWithinTimeLimit / goal, 0, 100);
          quest.progress = clicksWithinTimeLimit;
        }
      } else if (quest.type == "Shop") {
        if (!quest.completed && currentBoughtItems >= quest.goal) {
          quest.completed = true;
          await db.updateQuestCompletion(quest.id, 1);
          setState(() {
            widget.updateRewards(quest.reward);
          });
        }
        if (currentBoughtItems > quest.goal) {
          currentBoughtItems = quest.goal;
        }
        quest.progressPercent = clampDouble(currentBoughtItems / quest.goal, 0, 100);
        quest.progress = currentBoughtItems;
      }
    }
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
              "QUESTS",
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: questList.length,
            itemBuilder: (context, index) {
              var quest = questList[index];
              checkQuestCompletion();
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
                  value: quest.progressPercent,
                  backgroundColor: Colors.grey,
                  color: Colors.green,
                ),
                trailing: Text(
                  "${quest.progress} / ${quest.goal}",
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
  final String type;
  final int goal;
  final int reward;
  final int timeLimit;
  bool completed;
  double progressPercent;
  int progress;

  Quest({
    required this.id,
    required this.title,
    required this.type,
    required this.goal,
    required this.reward,
    required this.timeLimit,
    required this.completed,
  }) : progress = 0, progressPercent = 0.0;
}
