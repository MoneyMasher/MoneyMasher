import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  WindowOptions windowOptions = const WindowOptions(
    size: Size(1280, 720),
    minimumSize: Size(1280, 720),
    maximumSize: Size(1280, 720),
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
  _MoneyMasherState createState() => _MoneyMasherState();
}

class _MoneyMasherState extends State with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation _pulseAnimation;
  late AnimationController _hoverController;
  late Animation _hoverAnimation;
  int _ClickCount = 0;

  @override
  void initState() {
    super.initState();
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

  @override
  void dispose() {
    _pulseController.dispose();
    _hoverController.dispose();
    super.dispose();
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
            image: AssetImage('lib/assets/bg-1920.png'),
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
                        alignment: Alignment(0, -1),
                        child: Container(
                          width: double.infinity,
                          color: Colors.black.withOpacity(0.75),
                          padding: EdgeInsets.symmetric(vertical: 15),
                          child: Text(
                            '$_ClickCount Dollars',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 24, color: Colors.white),
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
                                  setState(() {
                                    _ClickCount++;
                                  });
                                },
                              child: AnimatedBuilder(
                                animation:
                                    Listenable.merge([_pulseAnimation, _hoverAnimation]),
                                builder: (context, child) {
                                  final scale = _hoverController.isAnimating ||
                                          _hoverController.value == 1.0
                                      ? _hoverAnimation.value
                                      : _pulseAnimation.value;
                                  return Transform.scale(
                                    scale: scale,
                                    child: child,
                                  );
                                },
                                child: Image.asset('lib/assets/dollar.png'),
                              ),                        ),
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
                'Quests',
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
                title: Text('Quest ${index + 1}',
                    style: const TextStyle(color: Colors.white)),
              ),
            ),
          ),
        ),
        Container(
          color: Colors.black.withOpacity(0.9),
          width: double.infinity,
          padding: const EdgeInsets.all(8),
          child: const Align(
            alignment: Alignment.centerLeft,
            child: Center(
              child: Text(
                'Items',
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
                title: Text('Item ${index + 1}',
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
                'Shop',
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
                title: Text('Shop Item ${index + 1}',
                    style: const TextStyle(color: Colors.white)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
