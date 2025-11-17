import 'dart:async';

import 'package:flutter/material.dart';

import '../models/counter_model.dart';
import '../storage/memory_storage.dart';

class CounterDetailScreen extends StatefulWidget {
  final CounterModel counter;

  const CounterDetailScreen({super.key, required this.counter});

  @override
  State<CounterDetailScreen> createState() => _CounterDetailScreenState();
}

class _CounterDetailScreenState extends State<CounterDetailScreen> {
  final storage = MemoryStorage.instance;
  // Cópia local do contador para podermos modificar seu valor na tela
  late CounterModel _counter;

  // Controle do cronômetro
  Timer? _timer;
  bool _isAutoIncrementing = false;
  int _intervalSeconds = 1; // Intervalo em segundos

  @override
  void initState() {
    super.initState();
    // Inicializa a cópia local com os dados recebidos
    _counter = widget.counter;
  }

  @override
  void dispose() {
    // Cancela o timer quando sair da tela
    _timer?.cancel();
    super.dispose();
  }

  // Inicia o incremento automático
  void _startAutoIncrement() {
    setState(() => _isAutoIncrementing = true);
    _timer = Timer.periodic(Duration(seconds: _intervalSeconds), (timer) async {
      setState(() => _counter.value++);
      await storage.updateCounter(_counter);
      // Registra log apenas a cada 10 incrementos para não poluir
      if (_counter.value % 10 == 0) {
        await storage.insertLog(
          'Contador "${_counter.name}" atingiu ${_counter.value} (auto).',
        );
      }
    });
    storage.insertLog('Cronômetro iniciado para "${_counter.name}".');
  }

  // Para o incremento automático
  void _stopAutoIncrement() {
    _timer?.cancel();
    setState(() => _isAutoIncrementing = false);
    storage.insertLog(
      'Cronômetro parado para "${_counter.name}" em ${_counter.value}.',
    );
  }

  // Altera a velocidade do cronômetro
  void _changeInterval(int seconds) {
    final wasRunning = _isAutoIncrementing;
    if (wasRunning) {
      _stopAutoIncrement();
    }
    setState(() => _intervalSeconds = seconds);
    if (wasRunning) {
      _startAutoIncrement();
    }
  }

  Future<void> _increment() async {
    setState(() => _counter.value++);
    await storage.updateCounter(_counter);
    await storage.insertLog(
      'Contador "${_counter.name}" incrementado para ${_counter.value}.',
    );
  }

  Future<void> _decrement() async {
    // Impede que o contador fique negativo
    if (_counter.value == 0) return;

    setState(() => _counter.value--);
    await storage.updateCounter(_counter);
    await storage.insertLog(
      'Contador "${_counter.name}" decrementado para ${_counter.value}.',
    );
  }

  Future<void> _reset() async {
    // Para o cronômetro se estiver rodando
    if (_isAutoIncrementing) {
      _stopAutoIncrement();
    }
    setState(() => _counter.value = 0);
    await storage.updateCounter(_counter);
    await storage.insertLog('Contador "${_counter.name}" resetado para 0.');
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
      // Para o cronômetro se estiver rodando
      _timer?.cancel();
      await storage.deleteCounter(_counter.id!);
      await storage.insertLog('Contador "${_counter.name}" deletado.');
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
            Text('Valor atual:', style: Theme.of(context).textTheme.titleLarge),
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
            const SizedBox(height: 30),

            // Botões Manuais
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FloatingActionButton.large(
                  onPressed: _isAutoIncrementing ? null : _decrement,
                  child: const Icon(Icons.remove),
                ),
                FloatingActionButton.large(
                  onPressed: _isAutoIncrementing ? null : _increment,
                  child: const Icon(Icons.add),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // Controles do Cronômetro
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Cronômetro',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Botão Play/Pause
                        IconButton.filled(
                          onPressed: _isAutoIncrementing
                              ? _stopAutoIncrement
                              : _startAutoIncrement,
                          icon: Icon(
                            _isAutoIncrementing
                                ? Icons.pause
                                : Icons.play_arrow,
                          ),
                          iconSize: 32,
                          tooltip: _isAutoIncrementing ? 'Pausar' : 'Iniciar',
                        ),
                        const SizedBox(width: 20),
                        // Seletor de velocidade
                        SegmentedButton<int>(
                          segments: const [
                            ButtonSegment(value: 1, label: Text('1s')),
                            ButtonSegment(value: 2, label: Text('2s')),
                            ButtonSegment(value: 5, label: Text('5s')),
                          ],
                          selected: {_intervalSeconds},
                          onSelectionChanged: (Set<int> newSelection) {
                            _changeInterval(newSelection.first);
                          },
                        ),
                      ],
                    ),
                    if (_isAutoIncrementing)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          '🟢 Incrementando a cada $_intervalSeconds segundo(s)',
                          style: Theme.of(
                            context,
                          ).textTheme.bodySmall?.copyWith(color: Colors.green),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
