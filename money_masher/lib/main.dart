import "package:flutter/material.dart";
import "package:window_manager/window_manager.dart";
import "db.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  WindowOptions windowOptions = const WindowOptions(
    size: Size(1280, 720),
    minimumSize: Size(1280, 720),
    center: true,
    skipTaskbar: false,
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MoneyMasher(),
    );
  }
}

class MoneyMasher extends StatefulWidget {
  const MoneyMasher({super.key});

  @override
  MoneyMasherState createState() => MoneyMasherState();
}

class MoneyMasherState extends State with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation _pulseAnimation;
  late AnimationController _hoverController;
  late Animation _hoverAnimation;
  int _clicks = 0;
  List<int> _clickTimes = [];
  final _db = DatabaseManager();

  @override
  void initState() {
    super.initState();
    _initializeApp();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1350),
      vsync: this,
    )..repeat(reverse: true);
    _pulseAnimation = Tween(begin: 0.85, end: 1.0).animate(_pulseController);
    
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    );
    _hoverAnimation = Tween(
      begin: _pulseAnimation.value,
      end: 1.2,
    ).animate(_hoverController);
  }

  _initializeApp() async {
    _clicks = await _db.getClicks();
    setState(() {});
  }

  @override
  void dispose() {
    _db.updateClicks(_clicks);
    _pulseController.dispose();
    _hoverController.dispose();
    super.dispose();
  }

  void _handleQuests(timestamp) {
    print("Handling Quests!");
    print("Length: ${_clickTimes.length}");
    // Total Clicks Events.
    {}

    // Quick Click Events.
    if (_clickTimes.length >= 100) {
      int oldestTime = _clickTimes[_clickTimes.length - 100];
      int latestTime = _clickTimes[_clickTimes.length - 1];
      // These times are really easy and need to be made harder.
      // We also need to add a check to ensure the quests are only completed once.
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

  void _incrementClicks() {
    print("Incrementing Clicks!");
    setState(() {
      _clicks++;
    });
    _db.updateClicks(_clicks);
  }

  void _handleClickEvent() {
    print("Click!");
    int now = DateTime.now().millisecondsSinceEpoch;
    _clickTimes.add(now);
    
    _incrementClicks();
    _handleQuests(now);
    
    // Keep _clickTimes list to 150 items to preserve memory.
    if (_clickTimes.length > 150) {
      _clickTimes.removeRange(0, _clickTimes.length - 150);
    }
  }

  void _onMouseEnter() {
    _pulseController.stop();

    _hoverAnimation = Tween(
      begin: _pulseAnimation.value,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: Curves.easeOut,
    ));

    _hoverController
      ..value = 0.0
      ..repeat(reverse: true);
  }

  void _onMouseExit() {
    _hoverController
        .reverse()
        .then((value) => _pulseController.repeat(reverse: true));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("lib/assets/bg-1920.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 10,
              color: Colors.black,
            ),
            Expanded(
              flex: 2,
              child: ColoredBox(
                color: Colors.black.withOpacity(0.5),
                child: _buildLeftColumn(),
              ),
            ),
            Container(
              width: 10,
              color: Colors.black,
            ),
            Expanded(
              flex: 4,
              child: Container(
                color: Colors.black.withOpacity(0.20),
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Align(
                        alignment: const Alignment(0, -0.8),
                        child: Container(
                          width: double.infinity,
                          color: Colors.black.withOpacity(0.75),
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: const Text(
                            "MONEY MASHER",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 14, color: Colors.white),
                          ),
                        ),
                      ),
                      Align(
                        alignment: const Alignment(0, -0.6),
                        child: Container(
                          width: double.infinity,
                          color: Colors.black.withOpacity(0.75),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: Text(
                            "$_clicks Dollars",
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(150),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            MouseRegion(
                              onEnter: (_) => _onMouseEnter(),
                              onExit: (_) => _onMouseExit(),
                              child: GestureDetector(
                                onTap: () {
                                  _handleClickEvent();
                                },
                                child: AnimatedBuilder(
                                  animation: Listenable.merge(
                                      [_pulseAnimation, _hoverAnimation]),
                                  builder: (context, child) {
                                    final scale =
                                        _hoverController.isAnimating ||
                                                _hoverController.value == 1.0
                                            ? _hoverAnimation.value
                                            : _pulseAnimation.value;
                                    return Transform.scale(
                                      scale: scale,
                                      child: child,
                                    );
                                  },
                                  child: Image.asset("lib/assets/dollar.png"),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              width: 10,
              color: Colors.black,
            ),
            Expanded(
              flex: 2,
              child: ColoredBox(
                color: Colors.black.withOpacity(0.5),
                child: _buildRightColumn(),
              ),
            ),
            Container(
              width: 10,
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeftColumn() {
    return Column(
      children: [
        Container(
          color: Colors.black.withOpacity(0.9),
          width: double.infinity,
          padding: const EdgeInsets.all(8),
          child: const Align(
            alignment: Alignment.centerLeft,
            child: Center(
              child: Text(
                "Quests",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            child: ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) => ListTile(
                title: Text("Quest ${index + 1}",
                    style: const TextStyle(color: Colors.white)),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRightColumn() {
    return Column(
      children: [
        Container(
          color: Colors.black.withOpacity(0.9),
          width: double.infinity,
          padding: const EdgeInsets.all(8),
          child: const Align(
            alignment: Alignment.centerLeft,
            child: Center(
              child: Text(
                "Shop",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            child: ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) => ListTile(
                title: Text("Shop Item ${index + 1}",
                    style: const TextStyle(color: Colors.white)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
