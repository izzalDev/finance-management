import 'dart:developer';

import 'package:finance_management/model/transaction.dart';
import 'package:finance_management/repository/transaction_repository.dart';
import 'package:finance_management/view/transaction_detail_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:finance_management/widget/transaction_item.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:finance_management/view/transaction_form_view.dart';

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
      appBar: AppBar(
        elevation: 4,
        backgroundColor: Colors.white,
        toolbarHeight: 100,
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const TransactionFormView();
          }));
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
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else {
                        List<Transaction> transactions = snapshot.data!;
                        int balance = 0;
                        for (Transaction transaction in transactions) {
                          balance += transaction.amount;
                        }
                        return Text(
                          _formatCurrency(balance),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }
                    })
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
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TransactionDetailView(
                                  transaction: transactions[index],
                                ),
                              ),
                            );
                          },
                          onLongPress: () {
                            _showBottomDrawer(context, transactions[index]);
                          },
                          child: TransactionItem(
                              category: transactions[index].category,
                              title: transactions[index].name,
                              date: _formatDate(date),
                              amount: _formatCurrency(amount)),
                        );
                      },
                    );
                  }
                }),
          ),
        ],
      ),
    );
  }

  String _formatCurrency(int amount) {
    final NumberFormat currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    );
    return currencyFormatter.format(amount);
  }

  String _formatDate(DateTime dateTime) {
    // Format tanggal ke format "19 Juli 2024"
    final DateFormat dateFormatter = DateFormat('d MMMM yyyy', 'id_ID');
    return dateFormatter.format(dateTime);
  }

  void _showBottomDrawer(BuildContext context, Transaction transaction) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          width: double.infinity,
          height: 200,
          child: ListView(
            children: [
              const SizedBox(height: 10),
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Edit'),
                onTap: () {
                  log("${transaction.id}======================================");
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return TransactionFormView(transaction: transaction);
                  }));
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text('Delete'),
                onTap: () {
                  TransactionRepository().delete(transaction.id);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
