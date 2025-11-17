import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Pacote que você adicionou

import '../storage/memory_storage.dart';

class LogScreen extends StatefulWidget {
  const LogScreen({super.key});

  @override
  State<LogScreen> createState() => _LogScreenState();
}

class _LogScreenState extends State<LogScreen> {
  final storage = MemoryStorage.instance;
  List<Map<String, dynamic>> _logs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLogs();
  }

  Future<void> _loadLogs() async {
    setState(() => _isLoading = true);
    final logList = await storage.getAllLogs();
    setState(() {
      _logs = logList;
      _isLoading = false;
    });
  }

  // Formata a data para ficar legível
  String _formatTimestamp(String isoString) {
    try {
      final dateTime = DateTime.parse(isoString);
      // Ex: 16/11/2025, 17:05:30
      return DateFormat('dd/MM/yyyy, HH:mm:ss').format(dateTime.toLocal());
    } catch (e) {
      return isoString; // Retorna original se falhar
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico de Logs'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadLogs,
            tooltip: 'Atualizar Logs',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _logs.isEmpty
          ? const Center(child: Text('Nenhum log registrado.'))
          : ListView.builder(
              itemCount: _logs.length,
              itemBuilder: (context, index) {
                final log = _logs[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.article_outlined),
                    title: Text(log['message']),
                    subtitle: Text(_formatTimestamp(log['timestamp'])),
                  ),
                );
              },
            ),
    );
  }
}
