import 'package:flutter/material.dart';

import 'log_entry_form.dart';
import 'log_table.dart';

class LogScreen extends StatelessWidget {
  const LogScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Log Book'),
          actions: [
            IconButton(
              onPressed: () => Navigator.pushNamed(context, '/settings'),
              icon: const Icon(Icons.settings),
            ),
          ],
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            final newEntry = Card(
              clipBehavior: Clip.antiAlias,
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
            );

            if (constraints.maxWidth < 1000) {
              return ListView(
                padding: const EdgeInsets.all(15),
                children: [
                  newEntry,
                  const SizedBox(height: 15),
                  const LogTable(),
                ],
              );
            }

            return Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: SingleChildScrollView(
                      primary: false,
                      child: newEntry,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    flex: 2,
                    child: SingleChildScrollView(
                      primary: false,
                      child: LogTable(),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );
}
