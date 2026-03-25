import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../data/models/expense_model.dart';
import 'amount_visibility.dart';
import 'expense_category.dart';

class TransactionCard extends StatelessWidget {
  TransactionCard({
    super.key,
    required this.expense,
    required this.onDelete,
    this.onEdit,
    this.accountLabel,
    this.maskAmounts = false,
  }) : _currencyFormat = NumberFormat.currency(
          locale: 'en_IN',
          symbol: '₹',
          decimalDigits:
              expense.amount.truncateToDouble() == expense.amount ? 0 : 2,
        );

  final ExpenseModel expense;
  final VoidCallback onDelete;
  final VoidCallback? onEdit;
  final String? accountLabel;
  final bool maskAmounts;
  final NumberFormat _currencyFormat;

  @override
  Widget build(BuildContext context) {
    final category = resolveCategory(expense.category);
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        child: InkWell(
          onTap: onEdit,
          borderRadius: BorderRadius.circular(26),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(26),
              boxShadow: const <BoxShadow>[
                BoxShadow(
                  color: Color(0x1209386D),
                  blurRadius: 22,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              children: <Widget>[
                Container(
                  width: 52,
                  height: 52,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF3F6FB),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(category.icon, color: const Color(0xFF32415A)),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        category.name,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF6B7A94),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        maskAmount(_currencyFormat.format(expense.amount),
                            masked: maskAmounts),
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF13213B),
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        expense.note.isEmpty ? 'Manual Entry' : expense.note,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF96A6C3),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_horiz_rounded),
                  color: Colors.white,
                  iconColor: const Color(0xFF96A6C2),
                  onSelected: (value) {
                    if (value == 'delete') {
                      onDelete();
                      return;
                    }
                    onEdit?.call();
                  },
                  itemBuilder: (context) => <PopupMenuEntry<String>>[
                    if (onEdit != null)
                      const PopupMenuItem<String>(
                        value: 'edit',
                        child: Text('Edit'),
                      ),
                    const PopupMenuItem<String>(
                      value: 'delete',
                      child: Text('Delete'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
