import 'package:flutter/material.dart';

import 'log_entry_form.dart';
import 'log_table.dart';

class LogScreen extends StatelessWidget {
  const LogScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Log Book')),
        body: ListView(
          padding: const EdgeInsets.all(15),
          children: [
            Card(
              elevation: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 18,
                      horizontal: 20,
                    ),
                    color: Colors.grey.shade200,
                    child: Text(
                      'New entry',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  const LogEntryForm(),
                ],
              ),
            ),
            const SizedBox(height: 15),
            const LogTable(),
          ],
        ),
      );
}
