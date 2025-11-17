import '../models/counter_model.dart';

class LogEntry {
  final int id;
  final DateTime timestamp;
  final String message;

  LogEntry({required this.id, required this.timestamp, required this.message});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'timestamp': timestamp.toIso8601String(),
      'message': message,
    };
  }
}

class MemoryStorage {
  static final MemoryStorage instance = MemoryStorage._internal();

  factory MemoryStorage() {
    return instance;
  }

  MemoryStorage._internal();

  // Listas em memória
  final List<CounterModel> _counters = [];
  final List<LogEntry> _logs = [];

  // Contadores de ID
  int _counterIdSequence = 1;
  int _logIdSequence = 1;

  // --- LOGS ---
  Future<void> insertLog(String message) async {
    final log = LogEntry(
      id: _logIdSequence++,
      timestamp: DateTime.now(),
      message: message,
    );
    _logs.add(log);
  }

  Future<List<Map<String, dynamic>>> getAllLogs() async {
    // Retorna logs do mais recente para o mais antigo
    return _logs.reversed.map((log) => log.toMap()).toList();
  }

  // --- COUNTERS ---
  Future<int> insertCounter(CounterModel counter) async {
    final newCounter = CounterModel(
      id: _counterIdSequence++,
      name: counter.name,
      value: counter.value,
    );
    _counters.add(newCounter);
    return newCounter.id!;
  }

  Future<List<CounterModel>> getAllCounters() async {
    // Retorna contadores do mais recente para o mais antigo
    return _counters.reversed.toList();
  }

  Future<int> updateCounter(CounterModel counter) async {
    final index = _counters.indexWhere((c) => c.id == counter.id);
    if (index != -1) {
      _counters[index] = counter;
      return 1; // Sucesso
    }
    return 0; // Não encontrado
  }

  Future<int> deleteCounter(int id) async {
    final initialLength = _counters.length;
    _counters.removeWhere((c) => c.id == id);
    return initialLength - _counters.length; // Retorna quantidade deletada
  }

  // Método auxiliar para limpar todos os dados (útil para testes)
  void clearAll() {
    _counters.clear();
    _logs.clear();
    _counterIdSequence = 1;
    _logIdSequence = 1;
  }
}
