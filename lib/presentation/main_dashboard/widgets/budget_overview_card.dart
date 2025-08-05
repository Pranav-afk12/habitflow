import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BudgetOverviewCard extends StatelessWidget {
  const BudgetOverviewCard({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> budgetData = {
      "monthlyBudget": 3500.0,
      "totalSpent": 2150.0,
      "remainingBalance": 1350.0,
      "categories": [
        {
          "name": "Food & Dining",
          "spent": 650.0,
          "budget": 800.0,
          "icon": "restaurant",
          "color": 0xFFE67E22
        },
        {
          "name": "Transportation",
          "spent": 320.0,
          "budget": 400.0,
          "icon": "directions_car",
          "color": 0xFF3498DB
        },
        {
          "name": "Entertainment",
          "spent": 180.0,
          "budget": 300.0,
          "icon": "movie",
          "color": 0xFF9B59B6
        },
        {
          "name": "Shopping",
          "spent": 450.0,
          "budget": 500.0,
          "icon": "shopping_bag",
          "color": 0xFFE74C3C
        }
      ]
    };

    final double spentPercentage = (budgetData["totalSpent"] as double) /
        (budgetData["monthlyBudget"] as double);
    final bool isOverBudget = spentPercentage > 0.8;

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.secondary
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(2.w),
                  ),
                  child: CustomIconWidget(
                    iconName: 'account_balance_wallet',
                    color: AppTheme.lightTheme.colorScheme.secondary,
                    size: 6.w,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Budget Overview",
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "August 2025",
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/budget-planning'),
                  child: CustomIconWidget(
                    iconName: 'arrow_forward_ios',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 5.w,
                  ),
                ),
              ],
            ),
            SizedBox(height: 3.h),
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: isOverBudget
                    ? AppTheme.lightTheme.colorScheme.error
                        .withValues(alpha: 0.05)
                    : AppTheme.lightTheme.colorScheme.tertiary
                        .withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(2.w),
                border: Border.all(
                  color: isOverBudget
                      ? AppTheme.lightTheme.colorScheme.error
                          .withValues(alpha: 0.2)
                      : AppTheme.lightTheme.colorScheme.tertiary
                          .withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Spent",
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          Text(
                            "\$${(budgetData["totalSpent"] as double).toStringAsFixed(0)}",
                            style: AppTheme.lightTheme.textTheme.titleLarge
                                ?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: isOverBudget
                                  ? AppTheme.lightTheme.colorScheme.error
                                  : AppTheme.lightTheme.colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "Remaining",
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          Text(
                            "\$${(budgetData["remainingBalance"] as double).toStringAsFixed(0)}",
                            style: AppTheme.lightTheme.textTheme.titleMedium
                                ?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppTheme.lightTheme.colorScheme.tertiary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Container(
                    width: double.infinity,
                    height: 1.h,
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.outline
                          .withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(0.5.h),
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor:
                          spentPercentage > 1.0 ? 1.0 : spentPercentage,
                      child: Container(
                        decoration: BoxDecoration(
                          color: isOverBudget
                              ? AppTheme.lightTheme.colorScheme.error
                              : AppTheme.lightTheme.colorScheme.secondary,
                          borderRadius: BorderRadius.circular(0.5.h),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    "${(spentPercentage * 100).toStringAsFixed(0)}% of monthly budget used",
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              "Top Categories",
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 1.h),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: (budgetData["categories"] as List).length > 2
                  ? 2
                  : (budgetData["categories"] as List).length,
              separatorBuilder: (context, index) => SizedBox(height: 1.h),
              itemBuilder: (context, index) {
                final category = (budgetData["categories"] as List)[index]
                    as Map<String, dynamic>;
                final categorySpentPercentage = (category["spent"] as double) /
                    (category["budget"] as double);

                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(2.w),
                    border: Border.all(
                      color: AppTheme.lightTheme.colorScheme.outline
                          .withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(2.w),
                        decoration: BoxDecoration(
                          color: Color(category["color"] as int)
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(1.5.w),
                        ),
                        child: CustomIconWidget(
                          iconName: category["icon"] as String,
                          color: Color(category["color"] as int),
                          size: 4.w,
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              category["name"] as String,
                              style: AppTheme.lightTheme.textTheme.bodyMedium
                                  ?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 0.5.h),
                            Container(
                              width: double.infinity,
                              height: 0.5.h,
                              decoration: BoxDecoration(
                                color: AppTheme.lightTheme.colorScheme.outline
                                    .withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(0.25.h),
                              ),
                              child: FractionallySizedBox(
                                alignment: Alignment.centerLeft,
                                widthFactor: categorySpentPercentage > 1.0
                                    ? 1.0
                                    : categorySpentPercentage,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Color(category["color"] as int),
                                    borderRadius: BorderRadius.circular(0.25.h),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "\$${(category["spent"] as double).toStringAsFixed(0)}",
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            "of \$${(category["budget"] as double).toStringAsFixed(0)}",
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
