import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../data/models/expense_model.dart';
import 'expense_category.dart';

class TransactionCard extends StatelessWidget {
  TransactionCard({
    super.key,
    required this.expense,
    required this.onDelete,
  })  : _currencyFormat = NumberFormat.currency(
          locale: 'en_IN',
          symbol: '₹',
          decimalDigits:
              expense.amount.truncateToDouble() == expense.amount ? 0 : 2,
        ),
        _timeFormat = DateFormat('HH:mm');

  final ExpenseModel expense;
  final VoidCallback onDelete;
  final NumberFormat _currencyFormat;
  final DateFormat _timeFormat;

  @override
  Widget build(BuildContext context) {
    final category = resolveCategory(expense.category);
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
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
            decoration: BoxDecoration(
              color: category.color.withValues(alpha: 0.13),
              shape: BoxShape.circle,
            ),
            child: Icon(category.icon, color: category.color),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  expense.note.isEmpty ? 'Manual Entry' : expense.note,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF13213B),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${expense.category.toUpperCase()}  •  MANUAL',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF97A7C1),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(
                '-${_currencyFormat.format(expense.amount)}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFFFF446D),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _timeFormat.format(expense.date.toLocal()),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFB4C1D5),
                ),
              ),
              IconButton(
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline_rounded),
                color: const Color(0xFF96A6C2),
                tooltip: 'Delete expense',
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
