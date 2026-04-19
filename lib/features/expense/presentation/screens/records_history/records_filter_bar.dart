import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_tokens.dart';
import '../../../data/models/account_model.dart';
import 'records_filter.dart';

/// Horizontal scrollable row of [ChoiceChip]s for filtering records.
class RecordsFilterChips extends StatelessWidget {
  const RecordsFilterChips({
    super.key,
    required this.selectedFilter,
    required this.onFilterSelected,
    required this.labelForFilter,
    this.onCustomDateRange,
    this.customDateRange,
  });

  final RecordsFilter selectedFilter;
  final ValueChanged<RecordsFilter> onFilterSelected;
  final String Function(RecordsFilter) labelForFilter;
  final VoidCallback? onCustomDateRange;
  final DateTimeRange? customDateRange;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: RecordsFilter.values.map((filter) {
          final isSelected = selectedFilter == filter;
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: ChoiceChip(
              label: Text(labelForFilter(filter)),
              selected: isSelected,
              onSelected: (_) {
                if (filter == RecordsFilter.custom) {
                  onCustomDateRange?.call();
                } else {
                  onFilterSelected(filter);
                }
              },
              avatar: isSelected
                  ? const Icon(
                      Icons.check_rounded,
                      size: 14,
                      color: Colors.white,
                    )
                  : null,
              showCheckmark: false,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              side: BorderSide(
                color: isSelected
                    ? AppColors.primaryBlue
                    : AppColors.primaryBlue.withValues(alpha: 0.2),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadii.pill),
              ),
              selectedColor: AppColors.primaryBlue,
              backgroundColor: Colors.white,
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : const Color(0xFF48607E),
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w700,
                fontSize: 13,
              ),
            ),
          );
        }).toList(growable: false),
      ),
    );
  }
}

/// Popup-menu button for filtering records by account.
class RecordsAccountDropdown extends StatelessWidget {
  const RecordsAccountDropdown({
    super.key,
    required this.accounts,
    required this.onAccountSelected,
    required this.allAccountsKey,
    required this.accountFilterLabel,
  });

  final List<AccountModel> accounts;
  final ValueChanged<String> onAccountSelected;
  final String allAccountsKey;
  final String accountFilterLabel;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: PopupMenuButton<String>(
        color: Colors.white,
        elevation: 0,
        position: PopupMenuPosition.under,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.lg),
        ),
        constraints: const BoxConstraints(minWidth: 220, maxWidth: 280),
        itemBuilder: (context) => <PopupMenuEntry<String>>[
          PopupMenuItem<String>(
            value: allAccountsKey,
            height: 44,
            child: const Text('All accounts'),
          ),
          ...accounts.map((account) {
            return PopupMenuItem<String>(
              value: account.id,
              height: 44,
              child: Text(account.name),
            );
          }),
        ],
        onSelected: onAccountSelected,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppRadii.pill),
            boxShadow: const <BoxShadow>[
              BoxShadow(
                color: AppColors.cardShadow,
                blurRadius: 18,
                offset: Offset(0, 8),
              ),
            ],
            border: Border.all(
              color: AppColors.primaryBlue.withValues(alpha: 0.08),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Icon(
                Icons.account_balance_wallet_outlined,
                size: 18,
                color: AppColors.primaryBlue,
              ),
              const SizedBox(width: 8),
              Text(
                accountFilterLabel,
                style: const TextStyle(
                  color: AppColors.textDark,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppColors.textMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
