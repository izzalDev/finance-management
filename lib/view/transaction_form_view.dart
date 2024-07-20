import 'package:dropdown_search/dropdown_search.dart';
import 'package:file_picker/file_picker.dart';
import 'package:finance_management/model/transaction.dart';
import 'package:finance_management/repository/transaction_repository.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionFormView extends StatefulWidget {
  final Transaction? transaction;
  const TransactionFormView({super.key, this.transaction});

  @override
  State<TransactionFormView> createState() => _TransactionFormViewState();
}

class _TransactionFormViewState extends State<TransactionFormView> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _filenameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  DateTime? _selectedDate;
  String? _selectedCategory = 'Debit';

  @override
  void initState() {
    super.initState();
    if (widget.transaction != null) {
      _nameController.text = widget.transaction!.name;
      _amountController.text = widget.transaction!.amount.toString();
      _descriptionController.text = widget.transaction!.description;
      _filenameController.text = widget.transaction!.photo;
      _selectedDate = widget.transaction!.date;
      _dateController.text = _formatDate(_selectedDate!);
      _selectedCategory = widget.transaction!.category;
    } else {
      _selectedDate = DateTime.now();
      _dateController.text = _formatDate(_selectedDate!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        toolbarHeight: 100,
        title: const Text(
          'Tambah Transaksi',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(28),
        children: [
          const SizedBox(height: 20),
          const Text(
            'Transaksi Baru',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Nama Transaksi',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            onTap: () async {
              final DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: _selectedDate ?? DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );
              if (pickedDate != null && pickedDate != _selectedDate) {
                setState(() {
                  _selectedDate = pickedDate;
                  _dateController.text = _formatDate(_selectedDate!);
                });
              }
            },
            controller: _dateController,
            readOnly: true,
            decoration: const InputDecoration(
              labelText: 'Tanggal',
              border: OutlineInputBorder(),
              suffixIcon: Icon(Icons.calendar_today, color: Colors.blue),
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            keyboardType: TextInputType.number,
            controller: _amountController,
            decoration: const InputDecoration(
              labelText: 'Nominal',
              border: OutlineInputBorder(),
              suffixIcon: Icon(Icons.attach_money, color: Colors.blue),
            ),
          ),
          const SizedBox(height: 20),
          DropdownSearch<String>(
            selectedItem: _selectedCategory ?? 'Debit',
            items: const ['Top up', 'Tagihan', 'Tiket', 'Debit', 'Transfer'],
            onChanged: (value) {
              setState(() {
                _selectedCategory = value!;
              });
            },
            dropdownDecoratorProps: const DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                labelText: 'Kategori',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            onTap: _pickImage,
            readOnly: true,
            controller: _filenameController,
            decoration: const InputDecoration(
              labelText: 'Tambahkan File',
              border: OutlineInputBorder(),
              suffixIcon: Icon(Icons.attach_file, color: Colors.blue),
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _descriptionController,
            minLines: 5,
            maxLines: null,
            decoration: const InputDecoration(
              alignLabelWithHint: true,
              labelText: 'Keterangan',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              save();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Container(
              height: 50,
              width: double.infinity,
              alignment: Alignment.center,
              child: const Text(
                'Tambah Transaksi',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image, // Hanya izinkan file gambar
    );
    if (result != null) {
      setState(() {
        _filenameController.text = result.files.single.name;
      });
    }
  }

  String _formatDate(DateTime dateTime) {
    final DateFormat dateFormatter = DateFormat('d MMMM yyyy', 'id_ID');
    return dateFormatter.format(dateTime);
  }

  void save() {
    if (_nameController.text.isEmpty || 
        _amountController.text.isEmpty || 
        _selectedCategory == null || 
        _selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan lengkapi semua field.')),
      );
      return;
    }

    Transaction transaction = Transaction(
      name: _nameController.text,
      date: _selectedDate!,
      amount: int.parse(_amountController.text),
      category: _selectedCategory!,
      description: _descriptionController.text,
      photo: _filenameController.text,
    );

    if (widget.transaction == null) {
      TransactionRepository().add(transaction);
    } else {
      TransactionRepository().update(transaction); // Assuming you have an update method
    }

    Navigator.pop(context);
  }
}
