import 'package:flutter/material.dart';

import '../models/counter_model.dart';
import '../storage/memory_storage.dart';
import './counter_detail_screen.dart'; // Importa nova tela
import './log_screen.dart'; // Importa nova tela

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final storage = MemoryStorage.instance;
  List<CounterModel> counters = [];

  @override
  void initState() {
    super.initState();
    _loadCounters();
  }

  Future<void> _loadCounters() async {
    final list = await storage.getAllCounters();
    setState(() => counters = list);
  }

  Future<void> _addCounterDialog() async {
    final controller = TextEditingController();

    await showDialog(
      context: context,
      // 1. Mude o builder de (_) para (dialogContext)
      //    Isso nos dá o contexto específico do Dialog.
      builder: (dialogContext) => AlertDialog(
        title: const Text('Novo contador'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Nome do contador'),
        ),
        actions: [
          TextButton(
            // 2. Use 'dialogContext' para fechar o pop-up
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (controller.text.isNotEmpty) {
                final newCounter = CounterModel(
                  name: controller.text,
                  value: 0,
                );

                // Salva em memória
                await storage.insertCounter(newCounter);
                await storage.insertLog(
                  'Contador "${controller.text}" criado.',
                );

                // 3. (IMPORTANTE) Verifique se o widget ainda está "montado" (na tela)
                //    depois que as operações 'await' terminaram.
                if (!mounted) return;

                // 4. Use 'dialogContext' para fechar com segurança
                Navigator.pop(dialogContext);
                _loadCounters(); // Agora isso vai funcionar
              }
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  // Deleta o contador (usado pelo Dismissible)
  Future<void> _deleteCounter(CounterModel counter) async {
    await storage.deleteCounter(counter.id!);
    // LOG
    await storage.insertLog('Contador "${counter.name}" deletado.');

    // Mostra um feedback
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('"${counter.name}" deletado.')));
    }
    _loadCounters();
  }

  // Navega para a tela de Logs
  void _navigateToLogs() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LogScreen()),
    );
  }

  // Navega para a tela de Detalhe
  void _navigateToDetail(CounterModel counter) async {
    // Navega e espera o retorno. Quando "pop" for chamado na tela de detalhe,
    // o código abaixo executa, atualizando a lista.
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CounterDetailScreen(counter: counter),
      ),
    );
    // Atualiza a lista principal quando voltar
    _loadCounters();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Contadores'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.history), // Botão de logs
            tooltip: 'Ver Logs',
            onPressed: _navigateToLogs,
          ),
        ],
      ),
      body: counters.isEmpty
          ? const Center(
              child: Text('Nenhum contador ainda. Crie um no botão +.'),
            )
          : ListView.builder(
              itemCount: counters.length,
              itemBuilder: (context, index) {
                final c = counters[index];
                return Dismissible(
                  key: Key(c.id.toString()), // Chave única
                  direction: DismissDirection.endToStart, // Arrastar da direita
                  background: Container(
                    color: Colors.red.shade900,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (_) => _deleteCounter(c),
                  child: Card(
                    child: ListTile(
                      title: Text(c.name, style: const TextStyle(fontSize: 18)),
                      // Mostra o valor grande no final
                      trailing: Text(
                        '${c.value}',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      onTap: () => _navigateToDetail(c),
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
