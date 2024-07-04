import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class BottomButtonsWidget extends StatelessWidget {
  final VoidCallback onAddEntry;
  final VoidCallback onShowCalendar;
  final VoidCallback onProcessAI;

  const BottomButtonsWidget({
    super.key,
    required this.onAddEntry,
    required this.onProcessAI,
    required this.onShowCalendar,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildButton(
            icon: CupertinoIcons.calendar,
            label: 'Calendar',
            onPressed: onShowCalendar,
          ),
          _buildButton(
            icon: CupertinoIcons.sparkles,
            label: 'AI Actionables',
            onPressed: onProcessAI,
          ),
          _buildButton(
            icon: CupertinoIcons.pencil,
            label: 'Add entry',
            onPressed: onAddEntry,
          ),
        ],
      ),
    );
  }

  Widget _buildButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 30,
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            label,
            style: const TextStyle(color: Colors.white),
          )
        ],
      ),
    );
  }
}
