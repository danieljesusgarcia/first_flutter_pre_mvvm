import 'package:first_flutter/data/models/sentence.dart';
import 'package:first_flutter/presentation/viewmodels/sentence_vm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SentenceVM(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: MyHomePage(),
      ),
    );
  }
}


class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0; // ← Add this property.

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = GeneratorPage();
      case 1:
        page = FavoritesPage();
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 450) {
          return Scaffold(
            body: Row(
              children: [
                MainArea(page: page),
              ],
            ),
            bottomNavigationBar: NavigationBar(
              destinations: [
                NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
                NavigationDestination(
                  icon: Icon(Icons.favorite),
                  label: 'Favorites',
                ),
              ],
              selectedIndex: selectedIndex,
              onDestinationSelected: (value) {
                setState(() {
                  selectedIndex = value;
                });
              },
            ),
          );
        } else {
          return Scaffold(
            body: Row(
              children: [
                SafeArea(
                  child: NavigationRail(
                    extended: constraints.maxWidth >= 800, // ← Here.
                    destinations: [
                      NavigationRailDestination(
                        icon: Icon(Icons.home),
                        label: Text('Home'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.favorite),
                        label: Text('Favorites'),
                      ),
                    ],
                    selectedIndex: selectedIndex,
                    onDestinationSelected: (value) {
                      setState(() {
                        selectedIndex = value;
                      });
                    },
                  ),
                ),
                MainArea(page: page),
              ],
            ),
          );
        }
      },
    );
  }
}

class MainArea extends StatelessWidget {
  const MainArea({super.key, required this.page});

  final Widget page;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: Theme.of(context).colorScheme.primaryContainer,
        child: page,
      ),
    );
  }
}

class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var vm = context.watch<SentenceVM>();
    var pair = vm.current;

    // ↓ Add this.
    IconData icon;
    if (vm.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Center(
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.center, //Main axis is vertical for Column
        children: [
          Expanded(
            child: ListView(
              children: [
                for (var word in vm.history)
                  ListTile(
                    leading: Icon(
                      vm.favorites.contains(word)
                          ? Icons.favorite
                          : Icons.favorite_border,
                    ),
                    title: Text(word.text),
                  ),
              ],
            ),
          ),
          Text('A random AWESOME  idea:'),
          BigCard(pair: pair),
          // ↓ Add this.
          SizedBox(height: 20),
          Row(
            mainAxisSize: MainAxisSize.min, // ← Add this.
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  vm.toggleCurrentFavorite();
                },
                icon: Icon(icon),
                label: Text('Like'),
              ),
              SizedBox(width: 20), // ← Add some spacing between buttons.
              ElevatedButton(
                onPressed: () {
                  vm.next();
                },
                child: Text('Next'),
              ),
            ],
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var vm = context.watch<SentenceVM>();

    if (vm.favorites.isEmpty) {
      return Center(child: Text('No favorites yet.'));
    }
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            'You have '
            '${vm.favorites.length} favorites:',
          ),
        ),
        for (var word in vm.favorites)
          ListTile(
            leading: IconButton(
              icon: Icon(Icons.favorite),
              color: Theme.of(context).colorScheme.primary,
              onPressed: () {
                vm.toggleFavorite(word);
              },
              tooltip: 'Remove from favorites',
            ),
            title: Text(word.text),
          ),
      ],
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({super.key, required this.pair});

  final Sentence pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      shadows: [
        Shadow(color: theme.colorScheme.primaryContainer, blurRadius: 10),
      ],
      color: theme.colorScheme.onPrimary,
    );
    return Card(
      color: theme.colorScheme.primary,
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(pair.text, style: style),
      ),
    );
  }
}
