import 'package:finance_management/model/transaction.dart';
import 'package:finance_management/repository/transaction_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:finance_management/widget/transaction_item.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key, required this.accountInfo}) : super(key: key);

  final User? accountInfo;

  @override
  HomeViewState createState() => HomeViewState();
}

class HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: AppBar(
            title: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(
                      18), // Penyesuaian sedikit untuk memotong foto dengan baik
                  child: Image.network(
                    'https://i.pravatar.cc/50',
                    fit: BoxFit.cover,
                    width: 50,
                    height: 50,
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Hi,',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(widget.accountInfo?.displayName ?? '',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        )),
                  ],
                )
              ],
            ), // Update title to display account info
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.logout,
                  size: 32,
                ),
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Tindakan yang diambil ketika FAB ditekan
          print('Floating Action Button pressed');
        },
        tooltip: 'Increment',
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Colors.lightBlue,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 200,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: Colors.lightBlue,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Saldo Anda saat ini',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 8),
                StreamBuilder<List<Transaction>>(
                  stream: TransactionRepository().getAllTransactions(),
                  builder: (context, snapshot){
                    if(snapshot.connectionState == ConnectionState.waiting){
                      return const CircularProgressIndicator();
                    } else {
                      List<Transaction> transactions = snapshot.data!;
                      int balance = 0;
                      for(Transaction transaction in transactions){
                        balance += transaction.amount;
                      }
                      return Text(
                        formatCurrency(balance),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }
                  }
                )
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Transaction>>(
                stream: TransactionRepository().getAllTransactions(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    List<Transaction> transactions = snapshot.data!;
                    return ListView.builder(
                      itemCount: transactions.length,
                      itemBuilder: (context, index) {
                        int amount = transactions[index].amount;
                        DateTime date = transactions[index].date;
                        return TransactionItem(
                            category: transactions[index].category,
                            title: transactions[index].name,
                            date: formatDate(date),
                            amount: formatCurrency(amount));
                      },
                    );
                  }
                }),
          ),
        ],
      ),
    );
  }

  String formatCurrency(int amount) {
    final NumberFormat currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    );
    return currencyFormatter.format(amount);
  }

  String formatDate(DateTime dateTime) {
    // Format tanggal ke format "19 Juli 2024"
    final DateFormat dateFormatter = DateFormat('d MMMM yyyy', 'id_ID');
    return dateFormatter.format(dateTime);
  }
}


