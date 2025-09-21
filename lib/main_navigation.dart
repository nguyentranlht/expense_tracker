import 'package:expense_tracker/core/utils/localization_helper.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../features/expense_tracking/presentation/pages/expense_list_page.dart';
import '../features/expense_tracking/presentation/pages/statistics_page.dart';
import 'features/home/presentation/pages/home_page.dart';
import 'features/settings/presentation/pages/settings_page.dart';

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const ExpenseListPage(),
    const StatisticsPage(),
    const SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedIndex: _currentIndex,
        destinations: [
          NavigationDestination(
            selectedIcon: Icon(FontAwesomeIcons.house),
            icon: Icon(FontAwesomeIcons.house),
            label: context.l10n.home,
          ),
          NavigationDestination(
            selectedIcon: Icon(FontAwesomeIcons.solidCreditCard),
            icon: Icon(FontAwesomeIcons.creditCard),
            label: context.l10n.expenses,
          ),
          NavigationDestination(
            selectedIcon: Icon(FontAwesomeIcons.chartPie),
            icon: Icon(FontAwesomeIcons.chartPie),
            label: context.l10n.statistics,
          ),
          NavigationDestination(
            selectedIcon: Icon(FontAwesomeIcons.gear),
            icon: Icon(FontAwesomeIcons.gear),
            label: context.l10n.settings,
          ),
        ],
      ),
    );
  }
}
