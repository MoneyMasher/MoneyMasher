import "dart:math";
import "package:flutter/material.dart";
import "package:window_manager/window_manager.dart";
import "db.dart";
import "package:money_masher/quests.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  WindowOptions windowOptions = const WindowOptions(
    size: Size(1280, 720),
    minimumSize: Size(1280, 720),
    maximumSize: Size(3840, 2160),
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

class MoneyMasherState extends State<MoneyMasher> with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation _pulseAnimation;
  late AnimationController _hoverController;
  late Animation _hoverAnimation;
  int _clicks = 0;
  int _multiplier = 1;
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

  void _incrementClick() {
    setState(() {
      _clicks += (1 * _multiplier);
    });
    _db.updateClicks(_clicks);
  }

  void _handleClickEvent() {
    int now = DateTime.now().millisecondsSinceEpoch;
    _clickTimes.add(now);
    
    _incrementClick();

    setState(() {
      // Keep _clickTimes list to 5000 items to preserve memory.
      if (_clickTimes.length > 5000) {
        _clickTimes.removeRange(0, _clickTimes.length - 5000);
      }
    });
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
    double imageWidth = MediaQuery.of(context).size.width / 3;
    double imageHeight = MediaQuery.of(context).size.height / 3;
    
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
                                  child: Image.asset(
                                    "lib/assets/dollar.png",
                                    width: imageWidth,
                                    height: imageHeight,
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
        Expanded(
          child: Quests(totalClicks: _clicks, clickTimes: _clickTimes),
        ),
      ],
    );
  }

  final List<String> titles = [
    "Potion of 2x Clicks",
    "Potion of 5x Clicks",
    "Potion of 10x Clicks",
    "Ritual of +1 Clicks",
    "Beginner Money Printer",
    "Intermediate Money Printer",
    "Advanced Money Printer",
    "Scroll of Rebirth",
  ];


  final List<String> descriptions = [
    "Every click counts as 2x for 1 minute.",
    "Every click counts as 5x for 5 minutes.",
    "Every click counts as 10x for 10 minutes.",
    "Permanently gain +1 to every click.",
    "Get \$1 every 3 seconds for free.",
    "Get \$10 every 3 seconds for free.",
    "Get \$100 every 3 seconds for free.",
    "Reset everything and gain a permanent 2x click multiplier.",
  ];

  final List<String> iconPaths = [
    "lib/assets/shop_icons/icon1.png",
    "lib/assets/shop_icons/icon2.png",
    "lib/assets/shop_icons/icon3.png",
    "lib/assets/shop_icons/icon4.png",
    "lib/assets/shop_icons/icon5.png",
    "lib/assets/shop_icons/icon6.png",
    "lib/assets/shop_icons/icon7.png",
    "lib/assets/shop_icons/icon8.png",
  ];

  Widget _buildRightColumn() {
    double width = MediaQuery.of(context).size.width;
    double baseScale = width / 1280;
    double fontSizeScale = baseScale * 10;
    double imageSize = baseScale * 64;

    return Column(
      children: [
        Container(
          color: Colors.black.withOpacity(0.9),
          width: double.infinity,
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Text(
              "Shop",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: fontSizeScale,
              ),
            ),
          ),
        ),
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.0,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
            ),
            itemCount: 8,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () => _handleItemClick(index, context),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Align(
                          alignment: Alignment.center,
                          child: SingleChildScrollView(
                            child: Text(
                              titles[index],
                              style: TextStyle(color: Colors.white, fontSize: fontSizeScale),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Image.asset(
                        iconPaths[index],
                        width: imageSize,
                        height: imageSize,
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: Align(
                          alignment: Alignment.center,
                          child: SingleChildScrollView(
                            child: Text(
                              descriptions[index],
                              style: TextStyle(color: Colors.white, fontSize: fontSizeScale * 0.8),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _handleItemClick(int index, BuildContext context) {
    print("Item $index clicked!");
  }
}
