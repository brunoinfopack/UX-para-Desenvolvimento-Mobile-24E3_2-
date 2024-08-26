import 'package:auto_control_panel/providers/tarefa_provider.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:projeto_tarefa_pk/projeto_tarefa_pk.dart';
import 'package:provider/provider.dart'; // Biblioteca de gráficos

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tarefProvider = context.watch<TarefaProvider>();
    //final List<Tarefa> listaTarefa = tarefProvider.tarefass;

    // Dados para demonstração
    tarefProvider.countDocuments('tarefas');
    int totalTarefas = tarefProvider.recordCount;

    tarefProvider.countDocumentsC('tarefas');
    int tarefasConcluidas = tarefProvider.recordCountC;

    tarefProvider.countDocumentsP('tarefas');
    int tarefasPendentes =  tarefProvider.recordCountP;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context, "Vai Curintia");
          },
          icon: Icon(Icons.arrow_back),
        ),
        backgroundColor: Colors.blueAccent,
        title: const Text("Dashboard"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context, "Lista de Tarefas");
            },
            icon: const Icon(Icons.home),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Totalizadores de Tarefas
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildTotalizador(
                    context,
                    'Total de Tarefas',
                    totalTarefas,
                    Colors.blueAccent,
                    Icons.list,
                  ),
                  _buildTotalizador(
                    context,
                    'Tarefas Concluídas',
                    tarefasConcluidas,
                    Colors.green,
                    Icons.check_circle_outline,
                  ),
                  _buildTotalizador(
                    context,
                    'Tarefas Pendentes',
                    tarefasPendentes,
                    Colors.redAccent,
                    Icons.pending_actions,
                  ),
                ],
              ),
              const SizedBox(height: 30),
              // Gráfico de Tarefas Pendentes e Concluídas
              Text(
                'Tarefas Pendentes e Concluídas',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 300,
                child: _buildTarefasPendentesConcluidasChart(
                    tarefasPendentes, tarefasConcluidas),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Método para construir os totalizadores
  Widget _buildTotalizador(BuildContext context, String titulo, int total,
      Color color, IconData iconData) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        width: 120,
        height: 120,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(iconData, size: 30, color: color),
            const SizedBox(height: 10),
            Text(
              '$total',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              titulo,
              style: const TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // Método para construir o gráfico de tarefas pendentes e concluídas
  Widget _buildTarefasPendentesConcluidasChart(int pendentes, int concluidas) {
    return PieChart(
      PieChartData(
        sections: [
          PieChartSectionData(
            value: pendentes.toDouble(),
            color: Colors.redAccent,
            title: '$pendentes Pendentes',
            radius: 60,
            titleStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          PieChartSectionData(
            value: concluidas.toDouble(),
            color: Colors.green,
            title: '$concluidas Concluídas',
            radius: 60,
            titleStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
        centerSpaceRadius: 40,
        sectionsSpace: 4,
      ),
    );
  }
}
