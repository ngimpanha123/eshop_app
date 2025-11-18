import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'customer_home_page.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({Key? key}) : super(key: key);

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  int _currentIndex = 0;
  String _selectedRole = 'Admin'; // Default role


  // Dummy data
  final int totalProducts = 28;
  final int totalUsers = 15;
  final double totalSales = 3566;
  final int expireProducts = 60;

  final List<_Cashier> cashiers = [
    _Cashier(name: 'Leang Serey Sophea', role: 'Admin', sales: 223000, rate: 0.10, imageUrl: null),
    _Cashier(name: 'Khem Soksombath', role: 'Cashier', sales: 251000, rate: 0.14, imageUrl: null),
  ];

  // Chart data
  final List<double> expenseData = [4000, 4200, 3500, 3000, 2800, 2600, 3200, 4100, 4300, 3800, 3600, 3400];
  final List<double> incomeData = [5000, 5200, 4800, 5100, 5400, 5600, 6000, 6200, 6500, 6600, 6800, 7000];

  // ---------------------- Role Switch ----------------------
  void _showRoleSwitchDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 4,
                width: 60,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              _buildRoleTile('Admin', FontAwesomeIcons.userTie),
              const SizedBox(height: 8),
              _buildRoleTile('Cashier', FontAwesomeIcons.userGroup),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRoleTile(String role, IconData icon) {
    bool isSelected = _selectedRole == role;
    return ListTile(
      leading: Icon(icon, color: Colors.grey.shade800),
      title: Text(
        role,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: isSelected ? Colors.black : Colors.grey.shade700,
        ),
      ),
      trailing: isSelected ? const Icon(Icons.check_circle, color: Colors.green) : null,
      onTap: () {
        setState(() {
          _selectedRole = role;
        });
        Navigator.pop(context);

        if (role == 'Cashier') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const CustomerHomePage()),
          );
        }
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    final primary = const Color(0xFF003D6B);
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('medi',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: primary,
                        height: 1.0)),
                Text('stock',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: primary,
                        height: 1.0)),
              ],
            ),
            const SizedBox(width: 6),
            //Icon(Icons.auto_awesome, color: primary, size: 18),
            IconButton(
              icon: const Icon(Icons.auto_awesome, color: Color(0xFF003D6B)),
              onPressed: _showRoleSwitchDialog,
            ),
            const SizedBox(width: 8),
            Text(
              _selectedRole,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF003D6B)),
            ),
          ],
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.notifications_outlined, color: Colors.grey[700]),
                onPressed: () {},
              ),
              Positioned(
                right: 12,
                top: 12,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.auto_awesome, color: Color(0xFF003D6B)),
                onPressed: _showRoleSwitchDialog,
              ),
            ],
          ),
          IconButton(
            icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey[700]),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Summary cards
              Wrap(
                runSpacing: 12,
                spacing: 12,
                children: [
                  _SummaryCard(title: 'Product', value: '$totalProducts', width: MediaQuery.of(context).size.width * 0.44),
                  _SummaryCard(title: 'User', value: '$totalUsers', width: MediaQuery.of(context).size.width * 0.44),
                  _SummaryCard(title: 'Sales', value: '\$${_formatNumber(totalSales)}', width: MediaQuery.of(context).size.width * 0.44),
                  _SummaryCard(title: 'Expire products', value: '$expireProducts', width: MediaQuery.of(context).size.width * 0.44),
                ],
              ),
              const SizedBox(height: 12),

              // Warning box
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3E0),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange.shade100),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning_amber_rounded, color: Colors.orange.shade800),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Warning: Paracetamol 500mg (Batch #A123) expired on June 10, 2025',
                        style: TextStyle(fontSize: 13, color: Colors.orange.shade900),
                      ),
                    ),
                    Icon(Icons.close, color: Colors.orange.shade900),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Chart header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Monthly Sale Analytics',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87)),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.filter_list, size: 16),
                    label: const Text('Filter', style: TextStyle(fontSize: 13)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.grey[700],
                      elevation: 0,
                      side: BorderSide(color: Colors.grey.shade200),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Chart container
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 2))
                  ],
                ),
                child: SizedBox(height: 220, child: _buildLineChart(primary)),
              ),
              const SizedBox(height: 18),

              // Cashier list
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Text('Cashier', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                TextButton.icon(onPressed: () {}, icon: const Icon(Icons.sort, size: 18), label: const Text('Sort'))
              ]),
              const SizedBox(height: 8),

              Column(
                children: cashiers.map((c) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.green.shade50),
                    ),
                    child: Row(children: [
                      CircleAvatar(
                        radius: 22,
                        backgroundColor: Colors.grey.shade200,
                        child: c.imageUrl == null
                            ? Icon(Icons.person, color: primary)
                            : null,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(c.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                              const SizedBox(height: 4),
                              Text(c.role, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                            ]),
                      ),
                      Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                        Text(_formatNumber(c.sales.toDouble()), style: const TextStyle(fontWeight: FontWeight.w700)),
                        const SizedBox(height: 4),
                        Text('${(c.rate * 100).toStringAsFixed(0)}%',
                            style: TextStyle(color: Colors.green.shade600, fontWeight: FontWeight.w600)),
                      ])
                    ]),
                  );
                }).toList(),
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
          selectedItemColor: primary,
          unselectedItemColor: Colors.grey[400],
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.auto_graph_outlined), activeIcon: Icon(Icons.auto_graph), label: 'Sales'),
            BottomNavigationBarItem(icon: Icon(Icons.medication_outlined), activeIcon: Icon(Icons.medication), label: 'Product'),
            BottomNavigationBarItem(icon: Icon(Icons.account_circle_outlined), activeIcon: Icon(Icons.account_circle), label: 'Account'),
          ],
        ),
      ),
    );
  }

  String _formatNumber(double n) {
    if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(0)}k';
    return n.toStringAsFixed(n % 1 == 0 ? 0 : 1);
  }

  Widget _buildLineChart(Color primary) {
    List<FlSpot> expenseSpots = [];
    List<FlSpot> incomeSpots = [];
    for (int i = 0; i < 12; i++) {
      expenseSpots.add(FlSpot(i.toDouble(), expenseData[i] / 1000));
      incomeSpots.add(FlSpot(i.toDouble(), incomeData[i] / 1000));
    }

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          horizontalInterval: 2,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (v) =>
              FlLine(color: Colors.grey.shade200, strokeWidth: 1),
        ),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              getTitlesWidget: (value, meta) {
                const months = [
                  'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct',
                  'Nov', 'Dec', 'Jan', 'Feb', 'Mar', 'Apr'
                ];
                final idx = value.toInt();
                if (idx < 0 || idx >= months.length) return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(months[idx], style: const TextStyle(fontSize: 10)),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 2,
              getTitlesWidget: (value, meta) =>
                  Text('${(value * 1000).toInt()}', style: const TextStyle(fontSize: 10)),
            ),
          ),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        minY: 0,
        maxY: 8,
        borderData: FlBorderData(show: false),
        lineBarsData: [
          // Expense line
          LineChartBarData(
            spots: expenseSpots,
            isCurved: true,
            color: Colors.redAccent,
            barWidth: 3,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(show: false),
          ),
          // Income line
          LineChartBarData(
            spots: incomeSpots,
            isCurved: true,
            color: primary,
            barWidth: 3,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                radius: 4,
                color: primary,
                strokeWidth: 0,
              ),
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  primary.withOpacity(0.3),
                  primary.withOpacity(0.0),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
      ),
      duration: const Duration(milliseconds: 800), // smooth animation
    );
  }
}

// Summary card widget
class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final double width;

  const _SummaryCard({Key? key, required this.title, required this.value, required this.width}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8, offset: const Offset(0, 3))
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
      ]),
    );
  }
}

class _Cashier {
  final String name;
  final String role;
  final int sales;
  final double rate;
  final String? imageUrl;
  _Cashier({required this.name, required this.role, required this.sales, required this.rate, this.imageUrl});
}
