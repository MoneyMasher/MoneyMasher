import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainMenu(),
    );
  }
}

class MainMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("lib/assets/backgro1und.jpeg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 60,
            left: 50,
            child: Text(
              'Money Mashers',
              style: TextStyle(
                fontSize: 80,
                color: Color.fromARGB(255, 15, 25, 104),
                fontWeight: FontWeight.bold,
                fontFamily: 'Arial',
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                  
                  },
                  child: Text(
                    'Play',
                    style: TextStyle(fontSize: 40),
                  ),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue,
                    padding:
                        EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  ),
                ),
                SizedBox(height: 20), 
                ElevatedButton(
                  onPressed: () {
                  
                  },
                  child: Text(
                    'Settings',
                    style: TextStyle(fontSize: 40),
                  ),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue,
                    padding:
                        EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  ),
                ),
                SizedBox(height: 20), 
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MoneyMasher()),
                    );
                  },
                  child: Text(
                    'Quests',
                    style: TextStyle(fontSize: 40),
                  ),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue,
                    padding:
                        EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MoneyMasher extends StatelessWidget {
  const MoneyMasher({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Row(
          children: [
            // This is the left pane for the Quests and Inventory.
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  // This is the quests header.
                  Container(
                    color: Colors.grey[350],
                    width: double.infinity,
                    padding: const EdgeInsets.all(8),
                    child: const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Quests',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  // This is the list of quest items.
                  Expanded(
                    child: Container(
                      color: Colors.grey[300],
                      child: ListView.builder(
                        itemCount: 5,
                        itemBuilder: (context, index) => ListTile(
                          title: Text('Quest ${index + 1}'),
                        ),
                      ),
                    ),
                  ),
                  // This is the inventory header.
                  Container(
                    color: Colors.grey[450], // Title banner background
                    width: double.infinity,
                    padding: const EdgeInsets.all(8),
                    child: const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Items',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  // This is the list of inventory items, things bought from the shop.
                  Expanded(
                    child: Container(
                      color: Colors.grey[400],
                      child: ListView.builder(
                        itemCount: 5,
                        itemBuilder: (context, index) => ListTile(
                          title: Text('Item ${index + 1}'),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // This is the center pane where the clicking will take place. "Dollar.png" placeholder.
            Expanded(
              flex: 3,
              child: Container(
                color: Colors.grey[500],
                child: const Center(child: Text('Dollar.png')),
              ),
            ),
            // This is the right pane where the shop will be with powerups and the like.
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  // This is the header for the pane.
                  Container(
                    color: Colors.grey[650],
                    width: double.infinity,
                    padding: const EdgeInsets.all(8),
                    child: const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Shop',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  // This is the placeholder list for the shop.
                  Expanded(
                    child: Container(
                      color: Colors.grey[600],
                      child: ListView.builder(
                        itemCount: 5,
                        itemBuilder: (context, index) => ListTile(
                          title: Text('Shop Item ${index + 1}'),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
