import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';

class CurrencySettingsScreen extends StatefulWidget {
  const CurrencySettingsScreen({Key? key}) : super(key: key);

  @override
  State<CurrencySettingsScreen> createState() => _CurrencySettingsScreenState();
}

class _CurrencySettingsScreenState extends State<CurrencySettingsScreen> {
  String _selectedCurrency = 'USD';
  String _selectedSymbol = '\$';
  bool _showSymbolBefore = true;
  bool _isLoading = true;

  final List<Map<String, dynamic>> _currencies = [
    {
      'code': 'USD',
      'name': 'US Dollar',
      'symbol': '\$',
      'flag': '🇺🇸',
      'example': '\$1,234.56',
    },
    {
      'code': 'EUR',
      'name': 'Euro',
      'symbol': '€',
      'flag': '🇪🇺',
      'example': '€1.234,56',
    },
    {
      'code': 'GBP',
      'name': 'British Pound',
      'symbol': '£',
      'flag': '🇬🇧',
      'example': '£1,234.56',
    },
    {
      'code': 'JPY',
      'name': 'Japanese Yen',
      'symbol': '¥',
      'flag': '🇯🇵',
      'example': '¥123,456',
    },
    {
      'code': 'CAD',
      'name': 'Canadian Dollar',
      'symbol': 'C\$',
      'flag': '🇨🇦',
      'example': 'C\$1,234.56',
    },
    {
      'code': 'AUD',
      'name': 'Australian Dollar',
      'symbol': 'A\$',
      'flag': '🇦🇺',
      'example': 'A\$1,234.56',
    },
    {
      'code': 'CHF',
      'name': 'Swiss Franc',
      'symbol': 'CHF',
      'flag': '🇨🇭',
      'example': 'CHF 1,234.56',
    },
    {
      'code': 'CNY',
      'name': 'Chinese Yuan',
      'symbol': '¥',
      'flag': '🇨🇳',
      'example': '¥1,234.56',
    },
    {
      'code': 'INR',
      'name': 'Indian Rupee',
      'symbol': '₹',
      'flag': '🇮🇳',
      'example': '₹1,23,456',
    },
    {
      'code': 'KRW',
      'name': 'South Korean Won',
      'symbol': '₩',
      'flag': '🇰🇷',
      'example': '₩1,234,567',
    },
    {
      'code': 'BRL',
      'name': 'Brazilian Real',
      'symbol': 'R\$',
      'flag': '🇧🇷',
      'example': 'R\$ 1.234,56',
    },
    {
      'code': 'MXN',
      'name': 'Mexican Peso',
      'symbol': '\$',
      'flag': '🇲🇽',
      'example': '\$12,345.60',
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadCurrencySettings();
  }

  Future<void> _loadCurrencySettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        _selectedCurrency = prefs.getString('selected_currency') ?? 'USD';
        _selectedSymbol = prefs.getString('currency_symbol') ?? '\$';
        _showSymbolBefore = prefs.getBool('show_symbol_before') ?? true;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveCurrencySettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('selected_currency', _selectedCurrency);
      await prefs.setString('currency_symbol', _selectedSymbol);
      await prefs.setBool('show_symbol_before', _showSymbolBefore);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Currency settings saved successfully'),
          backgroundColor: AppTheme.lightTheme.primaryColor,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save currency settings'),
          backgroundColor: AppTheme.errorLight,
        ),
      );
    }
  }

  void _selectCurrency(Map<String, dynamic> currency) {
    setState(() {
      _selectedCurrency = currency['code'];
      _selectedSymbol = currency['symbol'];
    });
    _saveCurrencySettings();
  }

  String _formatCurrency(double amount) {
    final formattedAmount = amount.toStringAsFixed(2).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );

    return _showSymbolBefore
        ? '$_selectedSymbol$formattedAmount'
        : '$formattedAmount $_selectedSymbol';
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Center(
          child: CircularProgressIndicator(
            color: AppTheme.lightTheme.primaryColor,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Currency Settings'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color:
                Theme.of(context).textTheme.titleLarge?.color ?? Colors.black,
            size: 24,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCurrentCurrencyCard(),
            SizedBox(height: 3.h),
            _buildFormatOptions(),
            SizedBox(height: 3.h),
            _buildCurrencyList(),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentCurrencyCard() {
    final currentCurrency = _currencies.firstWhere(
      (currency) => currency['code'] == _selectedCurrency,
      orElse: () => _currencies.first,
    );

    return Container(
      margin: EdgeInsets.all(4.w),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Current Currency',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.lightTheme.primaryColor,
                    ),
              ),
              Spacer(),
              Text(
                currentCurrency['flag'],
                style: TextStyle(fontSize: 24),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Text(
                currentCurrency['name'],
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              Spacer(),
              Text(
                currentCurrency['code'],
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppTheme.lightTheme.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            'Example: ${_formatCurrency(1234.56)}',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormatOptions() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Display Options',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          SizedBox(height: 2.h),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.shadowLight,
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                ListTile(
                  title: Text('Show symbol before amount'),
                  subtitle: Text(_showSymbolBefore
                      ? '${_selectedSymbol}1,234.56'
                      : '1,234.56 $_selectedSymbol'),
                  trailing: Switch(
                    value: _showSymbolBefore,
                    activeColor: AppTheme.lightTheme.primaryColor,
                    onChanged: (value) {
                      setState(() {
                        _showSymbolBefore = value;
                      });
                      _saveCurrencySettings();
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrencyList() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Available Currencies',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          SizedBox(height: 2.h),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.shadowLight,
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _currencies.length,
              separatorBuilder: (context, index) => Divider(
                height: 1,
                color: Theme.of(context).dividerColor,
              ),
              itemBuilder: (context, index) {
                final currency = _currencies[index];
                final isSelected = _selectedCurrency == currency['code'];

                return ListTile(
                  leading: Text(
                    currency['flag'],
                    style: TextStyle(fontSize: 24),
                  ),
                  title: Text(
                    currency['name'],
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w400,
                        ),
                  ),
                  subtitle: Text(
                    '${currency['code']} • ${currency['example']}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                  trailing: isSelected
                      ? CustomIconWidget(
                          iconName: 'check_circle',
                          color: AppTheme.lightTheme.primaryColor,
                          size: 24,
                        )
                      : CustomIconWidget(
                          iconName: 'radio_button_unchecked',
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          size: 24,
                        ),
                  onTap: () => _selectCurrency(currency),
                  tileColor: isSelected
                      ? AppTheme.lightTheme.primaryColor.withValues(alpha: 0.05)
                      : null,
                );
              },
            ),
          ),
          SizedBox(height: 4.h),
        ],
      ),
    );
  }
}
