import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salary_budget/Presentation/Screens/dashboard/bottom_navbar_controller.dart';
import 'package:salary_budget/Presentation/Screens/view_record/controller/view_controller.dart';
import 'package:salary_budget/Presentation/Screens/view_record/view/view_record_tile_model.dart';


class Dashboard extends StatelessWidget {
  Dashboard({super.key});

  final BottomNavController controller = Get.put(BottomNavController());
  final ViewRecordController recordController =
  Get.put(ViewRecordController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Good Evening'),
      ),
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavBar(controller: controller),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
      body: Obx(() {
        if (recordController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return SingleChildScrollView(
          child: Column(
            children: [
              _buildChartSection(recordController),
              _buildRecentTransactions(recordController),
            ],
          ),
        );
      }),
    );
  }

  // ---------------- CHART SECTION ----------------

  Widget _buildChartSection(ViewRecordController c) {
    final income = double.tryParse(c.fieldValue.value) ?? 0.0;
    final debit = c.totalDebitedAmount.value;
    final credit = c.totalCreditedAmount.value;
    final savings = income - debit + credit;

    final total = debit + credit + savings;
    double percent(double v) => total == 0 ? 0 : (v / total) * 100;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "This Month Overview",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              SizedBox(
                height: 180,
                width: 180,
                child: PieChart(
                  PieChartData(
                    centerSpaceRadius: 40,
                    sections: [
                  _pie("Credit", credit, Colors.green, total),
                  _pie("Debit", debit, Colors.red, total),
                  _pie("Savings", savings, Colors.blue, total),
                  ],
                  ),
            swapAnimationDuration: const Duration(milliseconds: 800),
            swapAnimationCurve: Curves.easeInOut,
                ),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  children: [
                    _legendRow(Colors.green, "Credit", percent(credit)),
                    _legendRow(Colors.red, "Debit", percent(debit)),
                    _legendRow(Colors.blue, "Savings", percent(savings)),
                  ],
                ),
              )
            ],
          ),

          const SizedBox(height: 12),
          _profitLossTile(income, savings),
        ],
      ),
    );
  }

  PieChartSectionData _pie(
      String title,
      double value,
      Color color,
      double total,
      ) {
    final percent = (value / total) * 100;

    return PieChartSectionData(
      value: value,
      color: color,
      radius: 55,
      title: "${percent.toStringAsFixed(1)}%",
      titleStyle: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }


  Widget _legendRow(Color color, String label, double value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            height: 10,
            width: 10,
            decoration:
            BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Text(label),
          const Spacer(),
          Text(
            "${value.toStringAsFixed(1)}%",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

 /* Widget _profitLossTile(double income, double balance) {
    final isProfit = balance >= income;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isProfit ? Colors.green.shade50 : Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            isProfit ? Icons.trending_up : Icons.trending_down,
            color: isProfit ? Colors.green : Colors.red,
          ),
          const SizedBox(width: 8),
          Text(
            isProfit ? "Profit this month" : "Loss this month",
            style: TextStyle(
              color: isProfit ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }*/

  Widget _profitLossTile(double income, double balance) {
    final isProfit = balance >= 20000 && balance <= 35000;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isProfit ? Colors.green.shade50 : Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            isProfit ? Icons.trending_up : Icons.trending_down,
            color: isProfit ? Colors.green : Colors.red,
          ),
          const SizedBox(width: 8),
          Text(
            isProfit
                ? "Good savings this month"
                : "Savings below/above expected range",
            style: TextStyle(
              color: isProfit ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- RECENT TRANSACTIONS ----------------

  Widget _buildRecentTransactions(ViewRecordController c) {
    final lastFive = c.recordList.reversed.take(5).toList();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Recent Transactions",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: lastFive.length,
            itemBuilder: (_, i) => TransactionTile(item: lastFive[i]),
          ),

          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => Get.to(() => ViewAllTransactionsScreen()),
              child: const Text(
                "View all",
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BottomNavBarScreen extends StatelessWidget {
  final BottomNavController controller = Get.put(BottomNavController());

  final List<Widget> pages = [
    Center(child: Text("Home Screen")),
    Center(child: Text("Analytics Screen")),
    Center(child: Text("Accounts Screen")),
    Center(child: Text("More Screen")),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => pages[controller.selectedIndex.value]),
      bottomNavigationBar: BottomNavBar(controller: controller),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        shape: CircleBorder(),
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}


class BottomNavBar extends StatelessWidget {
  final BottomNavController controller;

  BottomNavBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(
          () =>
          BottomAppBar(
            shape: CircularNotchedRectangle(),
            notchMargin: 8.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(Icons.home, "Home", 0),
                _buildNavItem(Icons.analytics, "Analytics", 1),
                SizedBox(width: 40), // Space for FAB
                _buildNavItem(Icons.account_circle, "Accounts", 2),
                _buildNavItem(Icons.menu, "More", 3),
              ],
            ),
          ),
    );
  }
  Widget _buildNavItem(IconData icon, String label, int index) {
    return InkWell(
      onTap: () => controller.changeIndex(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: controller.selectedIndex.value == index ? Colors.blue : Colors.grey),
          Text(label, style: TextStyle(color: controller.selectedIndex.value == index ? Colors.blue : Colors.grey)),
        ],
      ),
    );
  }
}


// ---------------- VIEW ALL TRANSACTIONS ----------------

class ViewAllTransactionsScreen extends StatelessWidget {
  final ViewRecordController c = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("All Transactions")),
      body: Column(
        children: [
         // _searchBar(),
          _filterRow(c),
          Expanded(
            child: GetBuilder<ViewRecordController>(
              builder: (c) {
                final list = c.filteredList;

                if (list.isEmpty) {
                  return const Center(child: Text("No transactions found"));
                }

                return ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (_, i) =>
                      TransactionTile(item: list[i]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _searchBar() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: TextField(
        onChanged: (value) => c.setSearch(value),
        decoration: InputDecoration(
          hintText: "Search by name or amount",
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }


/*  Widget _filterRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: const [
          Chip(label: Text("All")),
          SizedBox(width: 8),
          Chip(label: Text("Debit")),
          SizedBox(width: 8),
          Chip(label: Text("Credit")),
        ],
      ),
    );
  }*/

  Widget _filterRow(ViewRecordController c) {
    return Obx(() {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            _filterChip(
              label: "All",
              selected: c.selectedFilter.value == TransactionFilter.all,
              color: Colors.blue,
              onTap: () => c.setFilter(TransactionFilter.all),
            ),
            _filterChip(
              label: "Debit",
              selected: c.selectedFilter.value == TransactionFilter.debit,
              color: Colors.red,
              onTap: () => c.setFilter(TransactionFilter.debit),
            ),
            _filterChip(
              label: "Credit",
              selected: c.selectedFilter.value == TransactionFilter.credit,
              color: Colors.green,
              onTap: () => c.setFilter(TransactionFilter.credit),
            ),
          ],
        ),
      );
    });
  }

  Widget _filterChip({
    required String label,
    required bool selected,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : color,
            fontWeight: FontWeight.bold,
          ),
        ),
        selected: selected,
        selectedColor: color,
        backgroundColor: color.withOpacity(0.1),
        onSelected: (_) => onTap(),
      ),
    );
  }


}

// ---------------- TRANSACTION TILE (REUSABLE) ----------------


class TransactionTile extends StatelessWidget {
  final ViewRecordTileModel item;

  const TransactionTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final isDebit = item.transType == 'Debit';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor:
          isDebit ? Colors.red.shade100 : Colors.green.shade100,
          child: Icon(
            isDebit ? Icons.arrow_upward : Icons.arrow_downward,
            color: isDebit ? Colors.red : Colors.green,
          ),
        ),
        title: Text(
          item.transParticular ?? '',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(item.transDate ?? ''),
        trailing: Text(
          "${isDebit ? '-' : '+'}₹${item.transAmount}",
          style: TextStyle(
            color: isDebit ? Colors.red : Colors.green,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}


