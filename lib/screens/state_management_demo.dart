import 'package:flutter/material.dart';

/// State Management Demo for StreetBuzz
/// Demonstrates the use of setState() for local UI state management
/// Features: Counter, Theme Toggle, Order Tracker, and Dynamic UI Updates
class StateManagementDemo extends StatefulWidget {
  const StateManagementDemo({super.key});

  @override
  State<StateManagementDemo> createState() {
    debugPrint('🏗️ StateManagementDemo: Creating state instance');
    return _StateManagementDemoState();
  }
}

class _StateManagementDemoState extends State<StateManagementDemo> {
  // 📊 STATE VARIABLES
  int _counter = 0;
  int _likeCount = 0;
  int _orderCount = 3;
  bool _isDarkMode = false;
  bool _isVipMember = false;
  String _selectedCategory = 'All';
  double _rating = 3.0;
  final List<String> _orderHistory = ['Pizza', 'Burger', 'Tacos'];

  @override
  void initState() {
    super.initState();
    debugPrint('🚀 StateManagementDemo: Widget initialized');
    debugPrint('📊 Initial State - Counter: $_counter, Likes: $_likeCount');
  }

  @override
  void dispose() {
    debugPrint('🗑️ StateManagementDemo: Widget disposed');
    super.dispose();
  }

  // 🔄 STATE UPDATE METHODS

  void _incrementCounter() {
    setState(() {
      _counter++;
      debugPrint('➕ Counter incremented: $_counter');
    });
  }

  void _decrementCounter() {
    setState(() {
      if (_counter > 0) {
        _counter--;
        debugPrint('➖ Counter decremented: $_counter');
      } else {
        debugPrint('⚠️ Counter already at 0, cannot decrement');
      }
    });
  }

  void _resetCounter() {
    setState(() {
      debugPrint('🔄 Resetting counter from $_counter to 0');
      _counter = 0;
    });
  }

  void _toggleLike() {
    setState(() {
      _likeCount++;
      debugPrint('❤️ Like count: $_likeCount');
    });
  }

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
      debugPrint(
        '🎨 Theme toggled: ${_isDarkMode ? "Dark Mode" : "Light Mode"}',
      );
    });
  }

  void _toggleVipStatus() {
    setState(() {
      _isVipMember = !_isVipMember;
      debugPrint('👑 VIP Status: ${_isVipMember ? "Active" : "Inactive"}');
    });
  }

  void _changeCategory(String category) {
    setState(() {
      debugPrint('📂 Category changed: $_selectedCategory → $category');
      _selectedCategory = category;
    });
  }

  void _updateRating(double newRating) {
    setState(() {
      debugPrint('⭐ Rating updated: $_rating → $newRating');
      _rating = newRating;
    });
  }

  void _addOrder(String item) {
    setState(() {
      _orderHistory.insert(0, item);
      _orderCount++;
      debugPrint('🛒 Order added: $item (Total: $_orderCount)');
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$item added to orders! 🎉'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _clearOrders() {
    setState(() {
      final count = _orderHistory.length;
      _orderHistory.clear();
      _orderCount = 0;
      debugPrint('🗑️ Cleared $count orders');
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('🔄 StateManagementDemo: Widget rebuilding');

    // Dynamic background color based on theme state
    Color bgColor = _isDarkMode ? Colors.grey.shade900 : Colors.grey.shade50;
    Color textColor = _isDarkMode ? Colors.white : Colors.black87;
    Color cardColor = _isDarkMode ? Colors.grey.shade800 : Colors.white;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          'State Management Demo',
          style: TextStyle(color: textColor),
        ),
        backgroundColor: _isDarkMode
            ? Colors.deepOrange.shade900
            : Colors.deepOrange,
        iconTheme: IconThemeData(color: textColor),
        actions: [
          // Theme Toggle Button in AppBar
          IconButton(
            icon: Icon(_isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: _toggleTheme,
            tooltip: 'Toggle Theme',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🎯 SECTION 1: Basic Counter Demo
            _buildSectionHeader('1. Basic Counter (setState Demo)', textColor),
            const SizedBox(height: 12),
            _buildCounterCard(cardColor, textColor),

            const SizedBox(height: 24),

            // ❤️ SECTION 2: Like Button with Conditional UI
            _buildSectionHeader(
              '2. Like Counter with Conditional Styling',
              textColor,
            ),
            const SizedBox(height: 12),
            _buildLikeCard(cardColor, textColor),

            const SizedBox(height: 24),

            // 👑 SECTION 3: VIP Toggle with Dynamic UI
            _buildSectionHeader('3. VIP Status Toggle', textColor),
            const SizedBox(height: 12),
            _buildVipCard(cardColor, textColor),

            const SizedBox(height: 24),

            // 📂 SECTION 4: Category Selector
            _buildSectionHeader('4. Category Selection', textColor),
            const SizedBox(height: 12),
            _buildCategoryCard(cardColor, textColor),

            const SizedBox(height: 24),

            // ⭐ SECTION 5: Rating Slider
            _buildSectionHeader('5. Rating Slider', textColor),
            const SizedBox(height: 12),
            _buildRatingCard(cardColor, textColor),

            const SizedBox(height: 24),

            // 🛒 SECTION 6: Order Tracker
            _buildSectionHeader('6. Order History (List State)', textColor),
            const SizedBox(height: 12),
            _buildOrderCard(cardColor, textColor),

            const SizedBox(height: 24),

            // 📊 SECTION 7: State Summary
            _buildSectionHeader('7. Current State Summary', textColor),
            const SizedBox(height: 12),
            _buildStateSummary(cardColor, textColor),
          ],
        ),
      ),
    );
  }

  // 🎨 UI BUILDER METHODS

  Widget _buildSectionHeader(String title, Color textColor) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
    );
  }

  Widget _buildCounterCard(Color cardColor, Color textColor) {
    // Conditional styling based on counter value
    Color counterColor = _counter >= 10
        ? Colors.green
        : _counter >= 5
        ? Colors.orange
        : Colors.red;

    return Card(
      color: cardColor,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              'Button Pressed:',
              style: TextStyle(fontSize: 18, color: textColor),
            ),
            const SizedBox(height: 12),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: counterColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: counterColor, width: 2),
              ),
              child: Text(
                '$_counter',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: counterColor,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _counter >= 10
                  ? '🎉 You\'re on fire!'
                  : _counter >= 5
                  ? '💪 Keep going!'
                  : '👆 Tap to start',
              style: TextStyle(fontSize: 16, color: textColor.withOpacity(0.7)),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: _decrementCounter,
                  icon: const Icon(Icons.remove),
                  label: const Text('Decrement'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade400,
                    foregroundColor: Colors.white,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _incrementCounter,
                  icon: const Icon(Icons.add),
                  label: const Text('Increment'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade400,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: _resetCounter,
              icon: const Icon(Icons.refresh),
              label: const Text('Reset'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLikeCard(Color cardColor, Color textColor) {
    bool isPopular = _likeCount >= 10;

    return Card(
      color: cardColor,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(
              Icons.favorite,
              size: 64,
              color: _likeCount > 0 ? Colors.red : Colors.grey,
            ),
            const SizedBox(height: 12),
            Text(
              '$_likeCount Likes',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 8),
            if (isPopular)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.star, size: 16, color: Colors.white),
                    SizedBox(width: 4),
                    Text(
                      'POPULAR',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _toggleLike,
              icon: const Icon(Icons.favorite),
              label: const Text('Like'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade400,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVipCard(Color cardColor, Color textColor) {
    return Card(
      color: _isVipMember ? Colors.amber.shade50 : cardColor,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(
              _isVipMember ? Icons.workspace_premium : Icons.person,
              size: 64,
              color: _isVipMember ? Colors.amber.shade700 : Colors.grey,
            ),
            const SizedBox(height: 12),
            Text(
              _isVipMember ? 'VIP Member' : 'Regular Member',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: _isVipMember ? Colors.amber.shade900 : textColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _isVipMember
                  ? '✨ Enjoy exclusive benefits!'
                  : 'Upgrade to VIP for special perks',
              style: TextStyle(fontSize: 14, color: textColor.withOpacity(0.7)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            SwitchListTile(
              title: Text(
                'VIP Membership',
                style: TextStyle(color: textColor, fontWeight: FontWeight.w600),
              ),
              value: _isVipMember,
              onChanged: (value) => _toggleVipStatus(),
              activeThumbColor: Colors.amber.shade700,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard(Color cardColor, Color textColor) {
    List<String> categories = ['All', 'Pizza', 'Burgers', 'Desserts', 'Drinks'];

    return Card(
      color: cardColor,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              'Selected: $_selectedCategory',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: categories.map((category) {
                bool isSelected = _selectedCategory == category;
                return ChoiceChip(
                  label: Text(category),
                  selected: isSelected,
                  onSelected: (selected) => _changeCategory(category),
                  selectedColor: Colors.deepOrange.shade300,
                  backgroundColor: Colors.grey.shade300,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.black87,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingCard(Color cardColor, Color textColor) {
    return Card(
      color: cardColor,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 32),
                const SizedBox(width: 8),
                Text(
                  _rating.toStringAsFixed(1),
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '/ 5.0',
                  style: TextStyle(
                    fontSize: 18,
                    color: textColor.withOpacity(0.5),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Slider(
              value: _rating,
              min: 0,
              max: 5,
              divisions: 10,
              label: _rating.toStringAsFixed(1),
              onChanged: _updateRating,
              activeColor: Colors.amber.shade700,
            ),
            Text(
              _rating >= 4.5
                  ? '🌟 Excellent!'
                  : _rating >= 3.5
                  ? '👍 Good'
                  : _rating >= 2.5
                  ? '😐 Average'
                  : '👎 Needs Improvement',
              style: TextStyle(fontSize: 16, color: textColor.withOpacity(0.7)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderCard(Color cardColor, Color textColor) {
    return Card(
      color: cardColor,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Orders: $_orderCount',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: _orderHistory.isEmpty ? null : _clearOrders,
                  tooltip: 'Clear All',
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (_orderHistory.isEmpty)
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'No orders yet! Add some items below.',
                  style: TextStyle(
                    color: textColor.withOpacity(0.5),
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _orderHistory.length > 5 ? 5 : _orderHistory.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.deepOrange.shade100,
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    title: Text(
                      _orderHistory[index],
                      style: TextStyle(color: textColor),
                    ),
                    subtitle: Text(
                      'Order #${_orderHistory.length - index}',
                      style: TextStyle(color: textColor.withOpacity(0.5)),
                    ),
                    trailing: const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                    ),
                  );
                },
              ),
            if (_orderHistory.length > 5)
              Text(
                'Showing latest 5 of ${_orderHistory.length} orders',
                style: TextStyle(
                  fontSize: 12,
                  color: textColor.withOpacity(0.5),
                ),
              ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            Text(
              'Quick Add Items:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                _buildQuickAddButton('🍕 Pizza', textColor),
                _buildQuickAddButton('🍔 Burger', textColor),
                _buildQuickAddButton('🌮 Tacos', textColor),
                _buildQuickAddButton('🍟 Fries', textColor),
                _buildQuickAddButton('🥤 Drink', textColor),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAddButton(String item, Color textColor) {
    return ElevatedButton(
      onPressed: () => _addOrder(item),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepOrange.shade400,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      child: Text(item, style: const TextStyle(fontSize: 14)),
    );
  }

  Widget _buildStateSummary(Color cardColor, Color textColor) {
    return Card(
      color: cardColor,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSummaryRow('Counter', '$_counter', textColor),
            _buildSummaryRow('Likes', '$_likeCount', textColor),
            _buildSummaryRow(
              'VIP Status',
              _isVipMember ? 'Active' : 'Inactive',
              textColor,
            ),
            _buildSummaryRow('Category', _selectedCategory, textColor),
            _buildSummaryRow(
              'Rating',
              '${_rating.toStringAsFixed(1)} / 5.0',
              textColor,
            ),
            _buildSummaryRow('Orders', '$_orderCount', textColor),
            _buildSummaryRow(
              'Theme',
              _isDarkMode ? 'Dark' : 'Light',
              textColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, Color textColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 16, color: textColor.withOpacity(0.7)),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
