import 'package:auto_control_panel/providers/tarefa_provider.dart';
import 'package:auto_control_panel/screens/details_screen.dart';
import 'package:flutter/material.dart';
import 'package:auto_control_panel/routes.dart';
import 'package:intl/intl.dart';
import 'package:projeto_tarefa_pk/projeto_tarefa_pk.dart';
import 'package:provider/provider.dart';

class TarefaListTile extends StatelessWidget {
  const TarefaListTile(
    this.tarfs, {
    super.key,
    required this.index,
  });

  final Tarefa tarfs;
  final int index;

  @override
  Widget build(BuildContext context) {
    final tarfsProvider = context.watch<TarefaProvider>();

    String name = tarfs.nome;
    DateTime dtHora = tarfs.dataHora;
    String geoloc = tarfs.geolocalizacao;
    bool concluido = false;
    if (tarfs.isConcluido == 'SIM') {
      concluido = true;
    }

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.pushNamed(
            context,
            Routes.DETAILS,
            arguments: {'tarefa': tarfs, 'index': index},
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Leading icon for task status
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: concluido
                      ? Colors.green.withOpacity(0.15)
                      : Colors.red.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  concluido ? Icons.check_circle : Icons.pending,
                  color: concluido ? Colors.green : Colors.red,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              // Task details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Data: ${DateFormat.yMMMd().format(dtHora)}',
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 4),
                    const SizedBox(height: 4),
                    Text(
                      'Concluído: ' + tarfs.isConcluido,
                      style: TextStyle(
                        color: concluido ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
              // Delete button
              IconButton(
                icon: Icon(
                  Icons.delete_forever,
                  color: Colors.redAccent,
                  size: 28,
                ),
                onPressed: () {
                  tarfsProvider.delete(tarfs);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
