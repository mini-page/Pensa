import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../provider/budget_providers.dart';
import '../provider/expense_providers.dart';
import '../provider/preferences_providers.dart';
import '../widgets/amount_visibility.dart';
import '../widgets/budget_editor_sheet.dart';
import '../widgets/expense_category.dart';

class CategoriesScreen extends ConsumerStatefulWidget {
  const CategoriesScreen({super.key});

  @override
  ConsumerState<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends ConsumerState<CategoriesScreen> {
  bool _showIncome = false;

  @override
  Widget build(BuildContext context) {
    final stats = ref.watch(statsProvider);
    final budgetState = ref.watch(budgetTargetsProvider);
    final privacyModeEnabled = ref.watch(privacyModeEnabledProvider);
    final currency = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 1,
    );
    final budgets = budgetState.valueOrNull ?? defaultBudgetTargets;

    // Build grid children
    final List<Widget> gridChildren = _showIncome
        ? <Widget>[
            ..._incomeEntries.map((entry) {
              return _GridCategoryCard(
                title: entry.title,
                icon: entry.icon,
                tone: entry.tone,
                amount: '₹0.0',
                onTap: () => _openBudgetEditor(
                  categoryName: expenseCategories.first.name,
                  currentBudget: budgets[expenseCategories.first.name] ?? 0,
                ),
              );
            }),
            _AddCategoryCard(
              onTap: () => _openBudgetEditor(
                categoryName: expenseCategories.first.name,
                currentBudget: budgets[expenseCategories.first.name] ?? 0,
              ),
            ),
          ]
        : <Widget>[
            ...expenseCategories.map((category) {
              final spent = stats.categoryTotals[category.name] ?? 0;
              return _GridCategoryCard(
                title: category.name,
                icon: category.icon,
                tone: category.color,
                amount: maskAmount(
                  currency.format(spent),
                  masked: privacyModeEnabled,
                ),
                onTap: () => _openBudgetEditor(
                  categoryName: category.name,
                  currentBudget: budgets[category.name] ?? 0,
                ),
              );
            }),
            _AddCategoryCard(
              onTap: () => _openBudgetEditor(
                categoryName: expenseCategories.first.name,
                currentBudget: budgets[expenseCategories.first.name] ?? 0,
              ),
            ),
          ];

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(18, 20, 18, 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // ── Balance header ──
            Row(
              children: <Widget>[
                const Icon(
                  Icons.blur_on_rounded,
                  color: Color(0xFF0A6BE8),
                  size: 28,
                ),
                const SizedBox(width: 10),
                Text(
                  maskAmount(
                    currency.format(stats.monthTotal),
                    masked: privacyModeEnabled,
                  ),
                  style: const TextStyle(
                    color: Color(0xFF152039),
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            const Text(
              'Current balance',
              style: TextStyle(
                color: Color(0xFF90A1BE),
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),

            // ── Expenses / Incomes toggle + Create New ──
            Row(
              children: <Widget>[
                Expanded(
                  child: _PillSwitch(
                    leftLabel: 'Expenses',
                    rightLabel: 'Incomes',
                    isRightSelected: _showIncome,
                    onChanged: (value) {
                      setState(() {
                        _showIncome = value;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 12),
                FilledButton(
                  onPressed: () => _openBudgetEditor(
                    categoryName: expenseCategories.first.name,
                    currentBudget: budgets[expenseCategories.first.name] ?? 0,
                  ),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF0A6BE8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                  ),
                  child: const Text(
                    'Create New',
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
              ],
            ),
            if (budgetState.isLoading)
              const Padding(
                padding: EdgeInsets.only(top: 16),
                child: LinearProgressIndicator(minHeight: 4),
              ),
            const SizedBox(height: 22),

            // ── 3-column category grid ──
            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 14,
              crossAxisSpacing: 14,
              childAspectRatio: 0.82,
              children: gridChildren,
            ),
            const SizedBox(height: 32),

            // ── Recurring Subs section ──
            Row(
              children: <Widget>[
                const Text(
                  'RECURRING SUBS',
                  style: TextStyle(
                    color: Color(0xFF0A6BE8),
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.3,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: _showManageMessage,
                  child: const Text('Manage'),
                ),
              ],
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 170,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: _subscriptions.map((subscription) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 14),
                    child: _SubscriptionCard(subscription: subscription),
                  );
                }).toList(growable: false),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openBudgetEditor({
    required String categoryName,
    required double currentBudget,
  }) async {
    final result = await showBudgetEditorSheet(
      context,
      categories: expenseCategories.take(6).toList(growable: false),
      initialCategory: categoryName,
      initialAmount: currentBudget,
    );

    if (result == null) return;

    await ref.read(budgetControllerProvider).saveBudget(
          category: result.category,
          monthlyLimit: result.amount,
        );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${result.category} budget updated to ₹${result.amount.toStringAsFixed(0)}.',
        ),
      ),
    );
  }

  void _showManageMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content:
            Text('Recurring subscription management will be expanded soon.'),
      ),
    );
  }
}

// ── Pill Switch ─────────────────────────────────────────────────────────────

class _PillSwitch extends StatelessWidget {
  const _PillSwitch({
    required this.leftLabel,
    required this.rightLabel,
    required this.isRightSelected,
    required this.onChanged,
  });

  final String leftLabel;
  final String rightLabel;
  final bool isRightSelected;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F4F9),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: <Widget>[
          _SwitchOption(
            label: leftLabel,
            isSelected: !isRightSelected,
            onTap: () => onChanged(false),
          ),
          _SwitchOption(
            label: rightLabel,
            isSelected: isRightSelected,
            onTap: () => onChanged(true),
          ),
        ],
      ),
    );
  }
}

class _SwitchOption extends StatelessWidget {
  const _SwitchOption({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF0A6BE8) : Colors.transparent,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.white : const Color(0xFF6C7D99),
              fontWeight: FontWeight.w800,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}

// ── Grid Category Card (matches the design reference) ───────────────────────

class _GridCategoryCard extends StatelessWidget {
  const _GridCategoryCard({
    required this.title,
    required this.icon,
    required this.tone,
    required this.amount,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final Color tone;
  final String amount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: tone.withValues(alpha: 0.18),
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: tone.withValues(alpha: 0.55),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: Colors.white, size: 22),
                  ),
                  const Spacer(),
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF16233C),
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    amount,
                    style: const TextStyle(
                      color: Color(0xFF0A6BE8),
                      fontWeight: FontWeight.w900,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
            // 3-dot menu overlay
            Positioned(
              top: 6,
              right: 2,
              child: PopupMenuButton<String>(
                icon: Icon(
                  Icons.more_vert_rounded,
                  color: tone.withValues(alpha: 0.7),
                  size: 20,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                color: Colors.white,
                onSelected: (value) {
                  if (value == 'edit') {
                    onTap();
                  }
                },
                itemBuilder: (context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: 'edit',
                    child: Text('Edit Budget'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Add Category Card (+) ───────────────────────────────────────────────────

class _AddCategoryCard extends StatelessWidget {
  const _AddCategoryCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFD8DFE9),
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: const Center(
          child: Icon(
            Icons.add_rounded,
            color: Color(0xFF6F829D),
            size: 40,
          ),
        ),
      ),
    );
  }
}

// ── Subscription Card ───────────────────────────────────────────────────────

class _SubscriptionCard extends StatelessWidget {
  const _SubscriptionCard({required this.subscription});

  final _Subscription subscription;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x1209386D),
            blurRadius: 22,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F6FB),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(subscription.icon, color: const Color(0xFF8BA0C0)),
          ),
          const Spacer(),
          Text(
            subscription.name,
            style: const TextStyle(
              color: Color(0xFF13213B),
              fontWeight: FontWeight.w800,
              fontSize: 22,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subscription.price,
            style: const TextStyle(
              color: Color(0xFF94A4BE),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            subscription.nextBill,
            style: const TextStyle(
              color: Color(0xFF0A6BE8),
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Data Models ─────────────────────────────────────────────────────────────

class _Subscription {
  const _Subscription({
    required this.name,
    required this.price,
    required this.nextBill,
    required this.icon,
  });

  final String name;
  final String price;
  final String nextBill;
  final IconData icon;
}

class _IncomeEntry {
  const _IncomeEntry({
    required this.title,
    required this.icon,
    required this.tone,
  });

  final String title;
  final IconData icon;
  final Color tone;
}

// ── Static Data ─────────────────────────────────────────────────────────────

const List<_IncomeEntry> _incomeEntries = <_IncomeEntry>[
  _IncomeEntry(
    title: 'Salary',
    icon: Icons.work_outline_rounded,
    tone: Color(0xFF8FC7FF),
  ),
  _IncomeEntry(
    title: 'Award',
    icon: Icons.emoji_events_outlined,
    tone: Color(0xFFB4EFB8),
  ),
  _IncomeEntry(
    title: 'Coupon',
    icon: Icons.confirmation_num_outlined,
    tone: Color(0xFFFFB9C6),
  ),
  _IncomeEntry(
    title: 'Grant',
    icon: Icons.card_giftcard_outlined,
    tone: Color(0xFFD0BEFF),
  ),
  _IncomeEntry(
    title: 'Lottery',
    icon: Icons.casino_outlined,
    tone: Color(0xFFFFE38A),
  ),
  _IncomeEntry(
    title: 'Refund',
    icon: Icons.replay_circle_filled_outlined,
    tone: Color(0xFF7FD4C0),
  ),
  _IncomeEntry(
    title: 'Sale',
    icon: Icons.sell_outlined,
    tone: Color(0xFFFFCB7A),
  ),
];

const List<_Subscription> _subscriptions = <_Subscription>[
  _Subscription(
    name: 'Netflix',
    price: '₹499/mo',
    nextBill: 'NEXT: 25 MAR',
    icon: Icons.tv_rounded,
  ),
  _Subscription(
    name: 'Spotify',
    price: '₹119/mo',
    nextBill: 'NEXT: 1 APR',
    icon: Icons.music_note_rounded,
  ),
  _Subscription(
    name: 'YouTube',
    price: '₹129/mo',
    nextBill: 'NEXT: 8 APR',
    icon: Icons.play_circle_outline_rounded,
  ),
];
