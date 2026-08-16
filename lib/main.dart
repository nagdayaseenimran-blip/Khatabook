import 'package:flutter/material.dart';

void main() {
  runApp(const KhatabookApp());
}

class KhatabookApp extends StatelessWidget {
  const KhatabookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Khatabook',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class Transaction {
  final String title;
  final double amount;
  final bool isCredit; // true = Diye (Gave), false = Liye (Got)

  Transaction({required this.title, required this.amount, required this.isCredit});
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Transaction> _transactions = [];

  double get _totalGave => _transactions
      .where((item) => item.isCredit)
      .fold(0.0, (sum, item) => sum + item.amount);

  double get _totalGot => _transactions
      .where((item) => !item.isCredit)
      .fold(0.0, (sum, item) => sum + item.amount);

  void _addTransaction(String title, double amount, bool isCredit) {
    setState(() {
      _transactions.add(Transaction(title: title, amount: amount, isCredit: isCredit));
    });
  }

  void _showAddDialog(bool isCredit) {
    final titleController = TextEditingController();
    final amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(isCredit ? 'Aapne Diye (You Gave)' : 'Aapko Mile (You Got)'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Naam / Details'),
            ),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Amount (Rs.)'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final title = titleController.text;
              final amount = double.tryParse(amountController.text) ?? 0.0;
              if (title.isNotEmpty && amount > 0) {
                _addTransaction(title, amount, isCredit);
                Navigator.pop(ctx);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Khatabook'),
        centerTitle: true,
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.teal.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    const Text('Aapne Diye', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                    Text('Rs. ${_totalGave.toStringAsFixed(0)}', style: const TextStyle(fontSize: 18, color: Colors.red)),
                  ],
                ),
                Column(
                  children: [
                    const Text('Aapko Mile', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                    Text('Rs. ${_totalGot.toStringAsFixed(0)}', style: const TextStyle(fontSize: 18, color: Colors.green)),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: _transactions.isEmpty
                ? const Center(child: Text('Abhi koi transaction nahi hai.'))
                : ListView.builder(
                    itemCount: _transactions.length,
                    itemBuilder: (ctx, index) {
                      final tx = _transactions[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        child: ListTile(
                          title: Text(tx.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                          trailing: Text(
                            'Rs. ${tx.amount.toStringAsFixed(0)}',
                            style: TextStyle(
                              color: tx.isCredit ? Colors.red : Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                onPressed: () => _showAddDialog(true),
                child: const Text('Aapne Diye Rs.'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                onPressed: () => _showAddDialog(false),
                child: const Text('Aapko Mile Rs.'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
