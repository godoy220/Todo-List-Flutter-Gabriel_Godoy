import 'package:flutter/material.dart';

void main() {
  runApp(const MeuApp());
}

class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lista de Tarefas',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        useMaterial3: true,
      ),
      home: const TodoListScreen(),
    );
  }
}

// Classe Tarefa
class Tarefa {
  String titulo;
  bool concluida;

  Tarefa({required this.titulo, this.concluida = false});
}

// Uso de StatefulWidget para o widget principal
class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  // Lista para armazenar as tarefas
  final List<Tarefa> _tarefas = [];
  
  // Controller para gerenciar o TextField
  final TextEditingController _controller = TextEditingController();

  // Implementação do dispose() para limpar o controller
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Função para adicionar uma nova tarefa
  void _adicionarTarefa() {
    if (_controller.text.trim().isEmpty) return;

    // Chamar setState() nas modificações
    setState(() {
      _tarefas.add(Tarefa(titulo: _controller.text.trim()));
    });
    
    // Limpar o TextField após adicionar
    _controller.clear();
  }

  // Função para alternar o status da tarefa
  void _alternarStatusTarefa(int index) {
    setState(() {
      _tarefas[index].concluida = !_tarefas[index].concluida;
    });
  }

  // Função para remover uma tarefa da lista
  void _removerTarefa(int index) {
    setState(() {
      _tarefas.removeAt(index);
    });
  }

  // Botão para limpar todas as tarefas concluídas
  void _limparTarefasConcluidas() {
    setState(() {
      _tarefas.removeWhere((tarefa) => tarefa.concluida);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Contador de tarefas
    int tarefasConcluidas = _tarefas.where((t) => t.concluida).length;

    // Scaffold + AppBar como estrutura básica
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minhas Tarefas'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          // Botão para limpar concluídas
          IconButton(
            icon: const Icon(Icons.cleaning_services),
            tooltip: 'Limpar Concluídas',
            onPressed: _limparTarefasConcluidas,
          ),
        ],
      ),
      body: Column(
        children: [
          // Contador mostrando total e concluídas
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total: ${_tarefas.length}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  'Concluídas: $tarefasConcluidas',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.green),
                ),
              ],
            ),
          ),
          
          // Campo de entrada (TextField e botão)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Digite o nome da tarefa...',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _adicionarTarefa(),
                  ),
                ),
                const SizedBox(width: 8),
                FloatingActionButton(
                  onPressed: _adicionarTarefa,
                  child: const Icon(Icons.add),
                ),
              ],
            ),
          ),

          const Divider(),

          // Exibir Lista de Tarefas
          Expanded(
            child: _tarefas.isEmpty
                ? const Center(
                    child: Text(
                      'A lista está vazia. Adicione uma tarefa!',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: _tarefas.length,
                    itemBuilder: (context, index) {
                      final tarefa = _tarefas[index];
                      
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        //  Cores diferentes para pendentes e concluídas
                        color: tarefa.concluida ? Colors.green.shade50 : Colors.white,
                        child: ListTile(
                          // Checkbox ao lado de cada tarefa
                          leading: Checkbox(
                            value: tarefa.concluida,
                            onChanged: (_) => _alternarStatusTarefa(index),
                          ),
                          title: Text(
                            tarefa.titulo,
                            style: TextStyle(
                              // Texto riscado quando marcada
                              decoration: tarefa.concluida
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                              color: tarefa.concluida ? Colors.grey : Colors.black,
                            ),
                          ),
                          // Botão de delete ao lado de cada tarefa
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _removerTarefa(index),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}