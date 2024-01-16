import 'package:flutter/material.dart';
import 'package:hot_cold/locator.dart';

class ClearProgressButton extends StatefulWidget {
  const ClearProgressButton({super.key});

  @override
  State<ClearProgressButton> createState() => _ClearProgressButtonState();
}

class _ClearProgressButtonState extends State<ClearProgressButton> {
  bool confirming = false;
  void setConfirming(bool value) {
    setState(() {
      confirming = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Icon(Icons.delete),
            confirming
                ? const Padding(
                    padding: EdgeInsets.only(right: 65.0),
                    child: Text(
                      'Are you sure?',
                      style: TextStyle(color: Colors.red),
                    ),
                  )
                : const Text('Clear campaign progress?'),
          ],
        ),
        confirming
            ? Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        progress().clear();
                        setConfirming(false);
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      child: const Text(
                        'Confirm',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () {
                        setConfirming(false);
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              )
            : Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: OutlinedButton(
                  onPressed: () {
                    setConfirming(true);
                  },
                  child: const Text('Delete'),
                ),
              ),
      ],
    );
  }
}
