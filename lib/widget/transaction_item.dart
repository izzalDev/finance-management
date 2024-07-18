import 'package:flutter/material.dart';

class TransactionItem extends StatelessWidget {
  final String category;
  final String title;
  final String date;
  final String amount;

  const TransactionItem({
    super.key,
    required this.category,
    required this.title,
    required this.date,
    required this.amount,
  });
  

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(12),
            child: Icon(
              getIcon(),
              size: 28,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: amount.startsWith('-') ? Colors.red : Colors.green,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  IconData getIcon(){
    switch(category){
      case 'Top up':
        return Icons.payment;
      case 'Tagihan':
        return Icons.directions_bus;
      case 'Tiket':
        return Icons.local_activity;
      case 'Debit':
        return Icons.arrow_downward;
      case 'Transfer':
        return Icons.arrow_upward;
      default:
        return Icons.error;
    }
  }
}
