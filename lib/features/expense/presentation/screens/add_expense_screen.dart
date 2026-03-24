import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../provider/expense_providers.dart';
import '../widgets/expense_category.dart';

class AddExpenseScreen extends ConsumerStatefulWidget {
  const AddExpenseScreen({
    super.key,
    this.initialAmount,
    this.initialCategory,
  });

  final double? initialAmount;
  final String? initialCategory;

  @override
  ConsumerState<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends ConsumerState<AddExpenseScreen> {
  late final TextEditingController _noteController;
  late String _amountText;
  late String _selectedCategory;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _amountText = widget.initialAmount?.toStringAsFixed(0) ?? '0';
    _selectedCategory = widget.initialCategory ?? expenseCategories.first.name;
    _noteController = TextEditingController(text: 'Manual Entry');
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final amount = double.tryParse(_amountText) ?? 0;
    final amountLabel = amount <= 0 ? '₹0' : _formatAmount(amount);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded),
                  ),
                  const Spacer(),
                  _ModeChip(
                    label: 'Expense',
                    isSelected: true,
                    onTap: () {},
                  ),
                  const SizedBox(width: 8),
                  _ModeChip(
                    label: 'Income',
                    isSelected: false,
                    onTap: _showIncomeMessage,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'Blazing Fast Input.',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF121B34),
                    ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    amountLabel,
                    style: const TextStyle(
                      fontSize: 44,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF121B34),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: _backspace,
                    icon: const Icon(Icons.backspace_outlined),
                    color: const Color(0xFF7B88A5),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _noteController,
                decoration: InputDecoration(
                  hintText: 'What was this for?',
                  filled: true,
                  fillColor: const Color(0xFFF5F7FB),
                  prefixIcon: const Icon(Icons.edit_note_rounded),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: <Widget>[
                  _InfoPill(
                    icon: Icons.today_outlined,
                    label: DateFormat('EEE, d MMM').format(_selectedDate),
                  ),
                  const SizedBox(width: 10),
                  _InfoPill(
                    icon: Icons.schedule_rounded,
                    label: DateFormat('HH:mm').format(_selectedDate),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: _pickDate,
                    child: const Text('Change'),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Align(
                alignment: Alignment.centerLeft,
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: <Widget>[
                    for (final category in expenseCategories.take(6))
                      ChoiceChip(
                        label: Text(category.name),
                        selected: category.name == _selectedCategory,
                        avatar: Icon(
                          category.icon,
                          size: 18,
                          color: category.name == _selectedCategory
                              ? Colors.white
                              : category.color,
                        ),
                        labelStyle: TextStyle(
                          color: category.name == _selectedCategory
                              ? Colors.white
                              : const Color(0xFF43506A),
                          fontWeight: FontWeight.w700,
                        ),
                        selectedColor: category.color,
                        backgroundColor: const Color(0xFFF4F7FC),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                          side: BorderSide.none,
                        ),
                        onSelected: (_) {
                          setState(() {
                            _selectedCategory = category.name;
                          });
                        },
                      ),
                  ],
                ),
              ),
              const Spacer(),
              GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.4,
                physics: const NeverScrollableScrollPhysics(),
                children: <Widget>[
                  for (final key in <String>[
                    '1',
                    '2',
                    '3',
                    '4',
                    '5',
                    '6',
                    '7',
                    '8',
                    '9',
                    '.',
                    '0',
                  ])
                    _KeypadButton(
                      label: key,
                      onTap: () => _appendValue(key),
                    ),
                  _KeypadButton(
                    label: '✓',
                    isPrimary: true,
                    onTap: _saveExpense,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatAmount(double amount) {
    return NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: amount.truncateToDouble() == amount ? 0 : 2,
    ).format(amount);
  }

  void _appendValue(String value) {
    setState(() {
      if (value == '.' && _amountText.contains('.')) {
        return;
      }
      if (_amountText == '0' && value != '.') {
        _amountText = value;
      } else {
        _amountText += value;
      }
    });
  }

  void _backspace() {
    setState(() {
      if (_amountText.length <= 1) {
        _amountText = '0';
        return;
      }
      _amountText = _amountText.substring(0, _amountText.length - 1);
    });
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked == null) {
      return;
    }

    setState(() {
      _selectedDate = DateTime(
        picked.year,
        picked.month,
        picked.day,
        _selectedDate.hour,
        _selectedDate.minute,
      );
    });
  }

  void _showIncomeMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Income tracking is planned for a later release.'),
      ),
    );
  }

  Future<void> _saveExpense() async {
    final amount = double.tryParse(_amountText) ?? 0;
    if (amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enter a valid amount before saving.'),
        ),
      );
      return;
    }

    await ref.read(expenseControllerProvider).addExpense(
          amount: amount,
          category: _selectedCategory,
          date: _selectedDate,
          note: _noteController.text.trim(),
        );

    if (!mounted) {
      return;
    }

    Navigator.of(context).pop();
  }
}

class _ModeChip extends StatelessWidget {
  const _ModeChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF2F5FA) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color:
                isSelected ? const Color(0xFF121B34) : const Color(0xFFA5B1C6),
          ),
        ),
      ),
    );
  }
}

class _InfoPill extends StatelessWidget {
  const _InfoPill({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7FB),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 18, color: const Color(0xFF7386A6)),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF4B5974),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _KeypadButton extends StatelessWidget {
  const _KeypadButton({
    required this.label,
    required this.onTap,
    this.isPrimary = false,
  });

  final String label;
  final VoidCallback onTap;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isPrimary ? const Color(0xFF2B2A2B) : const Color(0xFFF5F7FB),
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: isPrimary ? Colors.white : const Color(0xFF121B34),
            ),
          ),
        ),
      ),
    );
  }
}
