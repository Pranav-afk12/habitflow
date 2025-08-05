import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AddCategoryModalWidget extends StatefulWidget {
  final String categoryType;
  final Map<String, dynamic>? category;
  final Function(Map<String, dynamic>) onAddCategory;

  const AddCategoryModalWidget({
    Key? key,
    required this.categoryType,
    this.category,
    required this.onAddCategory,
  }) : super(key: key);

  @override
  State<AddCategoryModalWidget> createState() => _AddCategoryModalWidgetState();
}

class _AddCategoryModalWidgetState extends State<AddCategoryModalWidget> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _budgetController = TextEditingController();
  String _selectedIcon = 'category';
  Color _selectedColor = Colors.blue;

  final List<String> _availableIcons = [
    'category',
    'favorite',
    'work',
    'school',
    'person',
    'restaurant',
    'directions_car',
    'movie',
    'shopping_bag',
    'local_hospital',
    'flash_on',
    'fitness_center',
    'directions_run',
    'self_improvement',
    'sports_basketball',
    'home',
    'pets',
    'travel_explore',
    'music_note',
    'book',
    'games',
  ];

  final List<Color> _availableColors = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.teal,
    Colors.pink,
    Colors.indigo,
    Colors.amber,
    Colors.cyan,
    Colors.deepOrange,
    Colors.lightGreen,
    Colors.deepPurple,
    Colors.brown,
  ];

  bool get _isEditing => widget.category != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      _nameController.text = widget.category!['name'] ?? '';
      _selectedIcon = widget.category!['icon'] ?? 'category';
      _selectedColor =
          Color(widget.category!['color'] as int? ?? Colors.blue.value);
      if (widget.categoryType == 'budget') {
        _budgetController.text =
            (widget.category!['budget'] as double? ?? 0.0).toString();
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _budgetController.dispose();
    super.dispose();
  }

  void _saveCategory() {
    if (_formKey.currentState!.validate()) {
      final category = <String, dynamic>{
        'name': _nameController.text.trim(),
        'icon': _selectedIcon,
        'color': _selectedColor.value,
      };

      switch (widget.categoryType) {
        case 'habits':
          category['itemCount'] = widget.category?['itemCount'] ?? 0;
          break;
        case 'budget':
          category['budget'] = double.tryParse(_budgetController.text) ?? 0.0;
          category['spent'] = widget.category?['spent'] ?? 0.0;
          break;
        case 'exercises':
          category['itemCount'] = widget.category?['itemCount'] ?? 0;
          break;
      }

      widget.onAddCategory(category);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 80.h,
        decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        child: Column(children: [
          _buildHeader(),
          Expanded(
              child: SingleChildScrollView(
                  padding: EdgeInsets.all(4.w),
                  child: Form(
                      key: _formKey,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildNameField(),
                            SizedBox(height: 3.h),
                            if (widget.categoryType == 'budget') ...[
                              _buildBudgetField(),
                              SizedBox(height: 3.h),
                            ],
                            _buildIconSelection(),
                            SizedBox(height: 3.h),
                            _buildColorSelection(),
                            SizedBox(height: 4.h),
                            _buildPreview(),
                            SizedBox(height: 4.h),
                            _buildSaveButton(),
                          ])))),
        ]));
  }

  Widget _buildHeader() {
    return Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                  color: AppTheme.shadowLight,
                  blurRadius: 4,
                  offset: Offset(0, 2)),
            ]),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(_isEditing ? 'Edit Category' : 'Add Category',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.w600)),
          IconButton(
              onPressed: () => Navigator.pop(context),
              icon: CustomIconWidget(
                  iconName: 'close',
                  color: Theme.of(context).textTheme.titleLarge?.color ??
                      Colors.black,
                  size: 24)),
        ]));
  }

  Widget _buildNameField() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Category Name',
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.w600)),
      SizedBox(height: 1.h),
      TextFormField(
          controller: _nameController,
          decoration: InputDecoration(
              hintText: 'Enter category name',
              prefixIcon: Padding(
                  padding: EdgeInsets.all(3.w),
                  child: CustomIconWidget(
                      iconName: _selectedIcon,
                      color: _selectedColor,
                      size: 20))),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter a category name';
            }
            return null;
          }),
    ]);
  }

  Widget _buildBudgetField() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Monthly Budget',
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.w600)),
      SizedBox(height: 1.h),
      TextFormField(
          controller: _budgetController,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
              hintText: 'Enter budget amount',
              prefixIcon: Padding(
                  padding: EdgeInsets.all(3.w),
                  child: CustomIconWidget(
                      iconName: 'attach_money',
                      color: AppTheme.lightTheme.primaryColor,
                      size: 20))),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter a budget amount';
            }
            if (double.tryParse(value) == null) {
              return 'Please enter a valid number';
            }
            return null;
          }),
    ]);
  }

  Widget _buildIconSelection() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Select Icon',
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.w600)),
      SizedBox(height: 2.h),
      Container(
          height: 12.h,
          child: GridView.builder(
              scrollDirection: Axis.horizontal,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1,
                  crossAxisSpacing: 2.w,
                  mainAxisSpacing: 2.w),
              itemBuilder: (context, index) {
                final icon = _availableIcons[index];
                final isSelected = _selectedIcon == icon;
                return GestureDetector(
                    onTap: () => setState(() => _selectedIcon = icon),
                    child: Container(
                        decoration: BoxDecoration(
                            color: isSelected
                                ? _selectedColor.withValues(alpha: 0.2)
                                : Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                color: isSelected
                                    ? _selectedColor
                                    : Theme.of(context).dividerColor,
                                width: isSelected ? 2 : 1)),
                        child: Center(
                            child: CustomIconWidget(
                                iconName: icon,
                                color:
                                    isSelected ? _selectedColor : Colors.grey,
                                size: 24))));
              })),
    ]);
  }

  Widget _buildColorSelection() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Select Color',
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.w600)),
      SizedBox(height: 2.h),
      Wrap(
          spacing: 2.w,
          runSpacing: 2.w,
          children: _availableColors.map((color) {
            final isSelected = _selectedColor.value == color.value;
            return GestureDetector(
                onTap: () => setState(() => _selectedColor = color),
                child: Container(
                    width: 12.w,
                    height: 12.w,
                    decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: Border.all(
                            color:
                                isSelected ? Colors.black : Colors.transparent,
                            width: isSelected ? 3 : 0)),
                    child: isSelected
                        ? Center(
                            child: CustomIconWidget(
                                iconName: 'check',
                                color: Colors.white,
                                size: 16))
                        : null));
          }).toList()),
    ]);
  }

  Widget _buildPreview() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Preview',
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.w600)),
      SizedBox(height: 2.h),
      Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Theme.of(context).dividerColor)),
          child: Row(children: [
            Container(
                width: 12.w,
                height: 12.w,
                decoration: BoxDecoration(
                    color: _selectedColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8)),
                child: Center(
                    child: CustomIconWidget(
                        iconName: _selectedIcon,
                        color: _selectedColor,
                        size: 24))),
            SizedBox(width: 4.w),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text(
                      _nameController.text.isNotEmpty
                          ? _nameController.text
                          : 'Category Name',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.w600)),
                  if (widget.categoryType == 'budget' &&
                      _budgetController.text.isNotEmpty)
                    Text('Budget: \$${_budgetController.text}',
                        style: Theme.of(context).textTheme.bodySmall),
                ])),
          ])),
    ]);
  }

  Widget _buildSaveButton() {
    return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
            onPressed: _saveCategory,
            style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.lightTheme.primaryColor,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 2.h),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12))),
            child: Text(_isEditing ? 'Update Category' : 'Save Category',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white, fontWeight: FontWeight.w600))));
  }
}
