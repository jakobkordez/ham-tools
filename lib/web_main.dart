import 'package:flutter/material.dart';
import 'package:ham_tools/src/callsign/callsign_screen.dart';
import 'package:ham_tools/src/map/azimuthal_map_screen.dart';
import 'package:ham_tools/src/map/cylindrical_map_screen.dart';

void main() => runApp(const WebApp());

class WebApp extends StatelessWidget {
  const WebApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Ham tools - S52KJ',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.blue,
          ).copyWith(
            primary: Colors.blue.shade700,
          ),
        ),
        home: const HomeScreen(),
        routes: <String, WidgetBuilder>{
          '/callsign': (_) => const CallsignScreen(),
          '/azmap': (_) => const AzimuthalMapScreen(),
          '/cylmap': (_) => const CylindricalMapScreen(),
        },
      );
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final onPrimary = theme.colorScheme.onPrimary;

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.blue.shade800],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Ham tools',
                  style: textTheme.headlineMedium?.copyWith(color: onPrimary),
                ),
                Text(
                  'by S52KJ',
                  style: textTheme.titleLarge?.copyWith(color: onPrimary),
                ),
              ],
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                constraints: const BoxConstraints(maxWidth: 1000),
                child: GridView.extent(
                  padding: const EdgeInsets.all(20),
                  maxCrossAxisExtent: 350,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 1.5,
                  children: [
                    _LinkCard(
                      image: Image.asset(
                        'assets/images/callsign.png',
                        fit: BoxFit.cover,
                        alignment: Alignment.topCenter,
                      ),
                      title: const Text('Callsign lookup'),
                      onTap: () => Navigator.pushNamed(context, '/callsign'),
                    ),
                    _LinkCard(
                      image: Image.asset(
                        'assets/images/azimuth_map.png',
                        fit: BoxFit.cover,
                      ),
                      title: const Text('Azimuthal map'),
                      onTap: () => Navigator.pushNamed(context, '/azmap'),
                    ),
                    _LinkCard(
                      title: const Text('QTH map'),
                      onTap: () => Navigator.pushNamed(context, '/cylmap'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LinkCard extends StatelessWidget {
  final Text? title;
  final Image? image;
  final VoidCallback? onTap;

  const _LinkCard({
    Key? key,
    this.title,
    this.image,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: image != null
                    ? image!
                    : Material(color: Colors.grey.shade300),
              ),
              if (title != null)
                Material(
                  color: Theme.of(context).colorScheme.surface,
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                    child: DefaultTextStyle(
                      style: Theme.of(context).textTheme.titleLarge!,
                      child: title!,
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
}
