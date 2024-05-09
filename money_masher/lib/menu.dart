import 'package:flutter/material.dart';
import 'package:popover/popover.dart';
import "package:window_manager/window_manager.dart";

class MenuButton extends StatelessWidget {
  const MenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showPopover(
        context: context,
        bodyBuilder: (context) => MenuItems(),
        width: 300,
        height: 200,
      ),
      child: Icon(
        Icons.settings,
        size: 30.0,
      ),
    );
  }
}

class MenuItems extends StatelessWidget {
  const MenuItems({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 50,
          width: 300,
          color: Colors.blueGrey[600],
          child: const Align(
            alignment: Alignment.center,
            child: Text(
              "OPTIONS",
              style: const TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
        ),
        Container(
          height: 150,
          width: 300,
          color: Colors.blueGrey[600],
          padding: const EdgeInsets.symmetric(vertical: 3),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Center the options
            children: [
              const Text(
                "Resolution",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              const SizedBox(height: 8),
              InkWell(
                // Option 1
                onTap: () {
                  Navigator.pop(context);
                  _handleResolutionChange('800x600');
                },
                child: const Text('800x600',
                    style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(height: 5),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                  _handleResolutionChange('1280x720');
                },
                child: const Text('1280x720',
                    style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(height: 5),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                  _handleResolutionChange('1920x1080');
                },
                child: const Text('1920x1080',
                    style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
        //Container(
        //height: 40,
        //width: 300,
        //color: Colors.blueGrey[600],
        //child: const Align(
        //alignment: Alignment.center,
        //child: Text(
        //"Sound (?)",
        //style: const TextStyle(fontSize: 14, color: Colors.white),
        //),
        //),
        //),
      ],
    );
  }

  void _handleResolutionChange(String resolution) async {
    if (resolution.isNotEmpty) {
      var dimensions = resolution.split('x'); // Splits into width and height
      if (dimensions.length == 2) {
        try {
          double width = double.parse(dimensions[0]);
          double height = double.parse(dimensions[1]);
          await windowManager.setSize(Size(width, height));
        } catch (error) {}
      }
    }
  }
}
