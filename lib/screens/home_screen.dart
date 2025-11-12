import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/counter_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final dbHelper = DatabaseHelper.instance;
  List<CounterModel> counters = [];

  @override
  void initState() {
    super.initState();
    _loadCounters();
  }

  Future<void> _loadCounters() async {
    final list = await dbHelper.getAllCounters();
    setState(() => counters = list);
  }

  Future<void> _addCounterDialog() async {
    final controller = TextEditingController();

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Novo contador'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Nome do contador'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (controller.text.isNotEmpty) {
                final newCounter = CounterModel(name: controller.text, value: 0);
                await dbHelper.insertCounter(newCounter);
                Navigator.pop(context);
                _loadCounters();
              }
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  Future<void> _incrementCounter(CounterModel counter) async {
    counter.value++;
    await dbHelper.updateCounter(counter);
    _loadCounters();
  }

  Future<void> _resetCounter(CounterModel counter) async {
    counter.value = 0;
    await dbHelper.updateCounter(counter);
    _loadCounters();
  }

  Future<void> _deleteCounter(CounterModel counter) async {
    await dbHelper.deleteCounter(counter.id!);
    _loadCounters();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Contadores'),
        centerTitle: true,
      ),
      body: counters.isEmpty
          ? const Center(child: Text('Nenhum contador ainda'))
          : ListView.builder(
              itemCount: counters.length,
              itemBuilder: (context, index) {
                final c = counters[index];
                return Card(
                  child: ListTile(
                    title: Text(c.name),
                    subtitle: Text('Valor: ${c.value}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () => _incrementCounter(c),
                        ),
                        IconButton(
                          icon: const Icon(Icons.refresh),
                          onPressed: () => _resetCounter(c),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _deleteCounter(c),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addCounterDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
