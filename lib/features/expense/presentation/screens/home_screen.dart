import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../data/models/expense_model.dart';
import '../provider/expense_providers.dart';
import '../widgets/expense_category.dart';
import '../widgets/quick_action_bar.dart';
import '../widgets/transaction_card.dart';
import 'add_expense_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expenseState = ref.watch(expenseListProvider);
    final expenses = expenseState.valueOrNull ?? const <ExpenseModel>[];
    final stats = ref.watch(statsProvider);
    final currencyFormat =
        NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _Header(stats: stats, currencyFormat: currencyFormat),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _FeatureRow(
                      onSoonTap: (label) => _showSoonMessage(context, label)),
                  const SizedBox(height: 22),
                  QuickActionBar(
                    actions: const <QuickActionItem>[
                      QuickActionItem(label: 'SMS', icon: Icons.sms_outlined),
                      QuickActionItem(
                          label: 'VOICE', icon: Icons.mic_none_rounded),
                      QuickActionItem(
                          label: 'SPLIT', icon: Icons.group_outlined),
                      QuickActionItem(
                          label: 'SMART', icon: Icons.bolt_outlined),
                      QuickActionItem(
                          label: 'MANUAL',
                          icon: Icons.add_rounded,
                          isHighlighted: true),
                    ],
                    onTap: (action) {
                      if (action.label == 'MANUAL') {
                        _openAddExpenseScreen(context);
                        return;
                      }
                      _showSoonMessage(context, action.label);
                    },
                  ),
                  const SizedBox(height: 22),
                  SizedBox(
                    height: 72,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: <double>[50, 100, 200, 500, 1000].map((amount) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: _AmountChip(
                            label: currencyFormat.format(amount),
                            onTap: () => _openAddExpenseScreen(context,
                                initialAmount: amount),
                          ),
                        );
                      }).toList(growable: false),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: expenseCategories.map((category) {
                      return _CategoryTile(
                        category: category,
                        onTap: () => _openAddExpenseScreen(
                          context,
                          initialCategory: category.name,
                        ),
                      );
                    }).toList(growable: false),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    children: <Widget>[
                      const Text(
                        'RECENT TRANSACTIONS',
                        style: TextStyle(
                          color: Color(0xFF0A6BE8),
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.4,
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {},
                        child: const Text('View All'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  if (expenseState.hasError)
                    const _EmptyCard(
                      title: 'Storage unavailable',
                      message:
                          'The expense list could not be loaded right now.',
                    )
                  else if (expenseState.isLoading && expenses.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 24),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  else if (expenses.isEmpty)
                    const _EmptyCard(
                      title: 'No expenses yet',
                      message:
                          'Tap the blue add button or choose a quick amount to record your first transaction.',
                    )
                  else
                    ...expenses.take(5).map((expense) {
                      return TransactionCard(
                        expense: expense,
                        onDelete: () => ref
                            .read(expenseControllerProvider)
                            .deleteExpense(expense.id),
                      );
                    }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openAddExpenseScreen(
    BuildContext context, {
    double? initialAmount,
    String? initialCategory,
  }) {
    return Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => AddExpenseScreen(
          initialAmount: initialAmount,
          initialCategory: initialCategory,
        ),
      ),
    );
  }

  void _showSoonMessage(BuildContext context, String label) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(
              '$label shortcuts arrive after the core expense flow is stable.')),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.stats,
    required this.currencyFormat,
  });

  final ExpenseStats stats;
  final NumberFormat currencyFormat;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(22, 20, 22, 28),
      decoration: const BoxDecoration(
        color: Color(0xFF0A6BE8),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(44)),
      ),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              const Icon(Icons.grid_view_rounded,
                  color: Colors.white, size: 24),
              const SizedBox(width: 14),
              Text(
                'Pensa',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const Spacer(),
              const Icon(Icons.tune_rounded, color: Colors.white, size: 28),
            ],
          ),
          const SizedBox(height: 30),
          Text(
            '[ All Accounts - ${currencyFormat.format(stats.monthTotal)} ]',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              _MetricColumn(
                  label: 'EXPENSE SO FAR',
                  value: currencyFormat.format(stats.monthTotal)),
              _MetricColumn(label: 'INCOME SO FAR', value: '₹0'),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetricColumn extends StatelessWidget {
  const _MetricColumn({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          label,
          style: const TextStyle(
            color: Color(0xB3FFFFFF),
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            fontSize: 24,
          ),
        ),
      ],
    );
  }
}

class _FeatureRow extends StatelessWidget {
  const _FeatureRow({required this.onSoonTap});

  final ValueChanged<String> onSoonTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: _FeatureCard(
            title: 'Split Bills',
            subtitle: 'SPLITWISE',
            icon: Icons.group_outlined,
            onTap: () => onSoonTap('Split bills'),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: _FeatureCard(
            title: 'Recurring',
            subtitle: 'MANAGE SUBS',
            icon: Icons.sync_alt_rounded,
            onTap: () => onSoonTap('Recurring'),
          ),
        ),
      ],
    );
  }
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(28),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(28),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: <Widget>[
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF5FF),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: const Color(0xFF0A6BE8)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      style: const TextStyle(
                        color: Color(0xFF13213B),
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Color(0xFF9AA8BE),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AmountChip extends StatelessWidget {
  const _AmountChip({
    required this.label,
    required this.onTap,
  });

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: 92,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: const <BoxShadow>[
              BoxShadow(
                color: Color(0x1209386D),
                blurRadius: 18,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Text(
            label,
            style: const TextStyle(
              color: Color(0xFF13213B),
              fontWeight: FontWeight.w900,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({
    required this.category,
    required this.onTap,
  });

  final ExpenseCategory category;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFEFF3FA),
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: SizedBox(
          width: 96,
          height: 118,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(category.icon, color: category.color, size: 28),
              const SizedBox(height: 10),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    category.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFF97A7C1),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyCard extends StatelessWidget {
  const _EmptyCard({
    required this.title,
    required this.message,
  });

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF13213B),
              fontWeight: FontWeight.w900,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: const TextStyle(
              color: Color(0xFF6F7F9C),
              height: 1.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
