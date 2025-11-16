import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/counter_model.dart';

class CounterDetailScreen extends StatefulWidget {
  final CounterModel counter;

  const CounterDetailScreen({super.key, required this.counter});

  @override
  State<CounterDetailScreen> createState() => _CounterDetailScreenState();
}

class _CounterDetailScreenState extends State<CounterDetailScreen> {
  final dbHelper = DatabaseHelper.instance;
  // Cópia local do contador para podermos modificar seu valor na tela
  late CounterModel _counter;

  @override
  void initState() {
    super.initState();
    // Inicializa a cópia local com os dados recebidos
    _counter = widget.counter;
  }

  Future<void> _increment() async {
    setState(() => _counter.value++);
    await dbHelper.updateCounter(_counter);
    await dbHelper.insertLog('Contador "${_counter.name}" incrementado para ${_counter.value}.');
  }

  Future<void> _decrement() async {
    // Impede que o contador fique negativo
    if (_counter.value == 0) return; 
    
    setState(() => _counter.value--);
    await dbHelper.updateCounter(_counter);
    await dbHelper.insertLog('Contador "${_counter.name}" decrementado para ${_counter.value}.');
  }

  Future<void> _reset() async {
    setState(() => _counter.value = 0);
    await dbHelper.updateCounter(_counter);
    await dbHelper.insertLog('Contador "${_counter.name}" resetado para 0.');
  }

  Future<void> _delete() async {
    // Pede confirmação antes de deletar
    final bool? confirmed = await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Deletar Contador?'),
        content: Text('Tem certeza que deseja deletar "${_counter.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Deletar'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await dbHelper.deleteCounter(_counter.id!);
      await dbHelper.insertLog('Contador "${_counter.name}" deletado.');
      // Fecha a tela de detalhe após deletar
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_counter.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Resetar',
            onPressed: _reset,
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Deletar',
            onPressed: _delete,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Valor atual:',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            // Animação de "scale" (zoom) quando o número muda
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              child: Text(
                '${_counter.value}',
                // A Key é ESSENCIAL para o AnimatedSwitcher saber que o widget mudou
                key: ValueKey<int>(_counter.value),
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 100,
                ),
              ),
            ),
            const SizedBox(height: 50),
            // Botões de Ação
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FloatingActionButton.large(
                  onPressed: _decrement,
                  child: const Icon(Icons.remove),
                ),
                FloatingActionButton.large(
                  onPressed: _increment,
                  child: const Icon(Icons.add),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}