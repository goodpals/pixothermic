import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hot_cold/store/progress_store.dart';

class ClearProgressWidget extends StatefulWidget {
  const ClearProgressWidget({super.key});

  @override
  State<ClearProgressWidget> createState() => _ClearProgressWidgetState();
}

class _ClearProgressWidgetState extends State<ClearProgressWidget> {
  bool confirmationDialogShowing = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Icon(Icons.delete),
            confirmationDialogShowing
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
        confirmationDialogShowing
            ? Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        context.read<ProgressStore>().clear();
                        setState(
                          () {
                            confirmationDialogShowing = false;
                          },
                        );
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
                        setState(() {
                          confirmationDialogShowing = false;
                        });
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
                    setState(
                      () {
                        confirmationDialogShowing = true;
                      },
                    );
                  },
                  child: const Text('Delete'),
                ),
              ),
      ],
    );
  }
}
