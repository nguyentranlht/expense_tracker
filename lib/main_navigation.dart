import 'package:expense_tracker/core/extensions/context_extensions.dart';
import 'package:expense_tracker/core/utils/localization_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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

class _MainNavigationPageState extends State<MainNavigationPage>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _animationController;
  late Animation<Offset> _offsetAnimation;
  bool _isVisible = true;

  final List<Widget> _pages = [
    const HomePage(),
    const ExpenseListPage(),
    const StatisticsPage(),
    const SettingsPage(),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0.0, 1.0),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onScrollNotification(ScrollNotification notification) {
    if (notification is UserScrollNotification) {
      final ScrollDirection direction = notification.direction;
      if (direction == ScrollDirection.reverse) {
        if (_isVisible) {
          _isVisible = false;
          _animationController.forward();
        }
      } else if (direction == ScrollDirection.forward) {
        if (!_isVisible) {
          _isVisible = true;
          _animationController.reverse();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification notification) {
          _onScrollNotification(notification);
          return false;
        },
        child: IndexedStack(index: _currentIndex, children: _pages),
      ),
      bottomNavigationBar: SlideTransition(
        position: _offsetAnimation,
        child: Container(
          decoration: BoxDecoration(
            color: context.cs.surface,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: NavigationBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            onDestinationSelected: (int index) {
              setState(() {
                _currentIndex = index;
              });
            },
            selectedIndex: _currentIndex,
            destinations: [
              NavigationDestination(
                selectedIcon: const Icon(FontAwesomeIcons.house),
                icon: const Icon(FontAwesomeIcons.house),
                label: context.l10n.home,
              ),
              NavigationDestination(
                selectedIcon: const Icon(FontAwesomeIcons.solidCreditCard),
                icon: const Icon(FontAwesomeIcons.creditCard),
                label: context.l10n.expenses,
              ),
              NavigationDestination(
                selectedIcon: const Icon(FontAwesomeIcons.chartPie),
                icon: const Icon(FontAwesomeIcons.chartPie),
                label: context.l10n.statistics,
              ),
              NavigationDestination(
                selectedIcon: const Icon(FontAwesomeIcons.gear),
                icon: const Icon(FontAwesomeIcons.gear),
                label: context.l10n.settings,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
