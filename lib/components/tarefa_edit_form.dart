import 'dart:io';

import 'package:auto_control_panel/providers/tarefa_provider.dart';
import 'package:auto_control_panel/providers/weather_provider.dart';
import 'package:auto_control_panel/routes.dart';
import 'package:flutter/material.dart';
import 'package:projeto_tarefa_pk/projeto_tarefa_pk.dart';
import 'package:provider/provider.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:location/location.dart';

class TarefaEditForm extends StatefulWidget {
  TarefaEditForm({super.key, required this.index, required this.tarfs});

  final int index;
  final Tarefa tarfs;

  @override
  State<TarefaEditForm> createState() => _TarefaEditFormState();
}

class _TarefaEditFormState extends State<TarefaEditForm> {
  final cidadeedController = TextEditingController();

  final tempedController = TextEditingController();

  final umidadeedController = TextEditingController();

  String concluidoValue = 'NAO';
  // Valor inicial do campo multiselect
  Future<LocationData?> getLocation() async {
    Location location = Location();
    bool serviceEnabledLocation;
    PermissionStatus permissionStatus;

    serviceEnabledLocation = await location.serviceEnabled();
    if (!serviceEnabledLocation) {
      serviceEnabledLocation = await location.requestService();
      if (!serviceEnabledLocation) return null;
    }

    permissionStatus = await location.hasPermission();
    if (permissionStatus == PermissionStatus.denied) {
      permissionStatus = await location.requestPermission();
      if (permissionStatus != PermissionStatus.granted) return null;
    }

    return location.getLocation();
  }

  @override
  Widget build(BuildContext context) {
    final tarefaProvider = context.read<TarefaProvider>();
    final update = tarefaProvider.update;
    final weatherProvider = Provider.of<WeatherProvider>(context);

    final nomeController =
        TextEditingController(text: widget.tarfs.nome.toString());
    final datahoraController =
        TextEditingController(text: widget.tarfs.dataHora.toString());
    final geoController =
        TextEditingController(text: widget.tarfs.geolocalizacao.toString());

    final ConcluidoController =
        TextEditingController(text: widget.tarfs.isConcluido.toString());

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Editar Tarefa',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: nomeController,
                decoration: InputDecoration(
                  labelText: 'Descrição da Tarefa',
                  labelStyle: TextStyle(
                    color: Colors.blueGrey[600],
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: datahoraController,
                decoration: InputDecoration(
                  labelText: 'Data e Hora',
                  hintText: 'YYYY-MM-DD HH:MM',
                  labelStyle: TextStyle(
                    color: Colors.blueGrey[600],
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                inputFormatters: [
                  MaskTextInputFormatter(
                    mask: '####-##-## ##:##',
                    filter: {"#": RegExp(r'[0-9]')},
                  ),
                ],
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: ConcluidoController.text,
                items: ['SIM', 'NAO'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: InputDecoration(
                  labelText: 'Concluído',
                  labelStyle: TextStyle(
                    color: Colors.blueGrey[600],
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onChanged: (String? newValue) {
                  concluidoValue = newValue!;
                  setState(() {
                    ConcluidoController.text = newValue;
                  });
                },
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlueAccent,
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 32,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  if (nomeController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Informe a Descrição da Tarefa')));
                  } else if (datahoraController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Informe a Data e Hora')));
                  } else {
                    widget.tarfs.nome = nomeController.text;
                    widget.tarfs.dataHora =
                        DateTime.parse(datahoraController.text);
                    widget.tarfs.geolocalizacao = geoController.text;
                    widget.tarfs.isConcluido = concluidoValue;
                    print(widget.tarfs.isConcluido);
                    update(widget.tarfs);
                    Navigator.pushNamed(context, Routes.HOME);
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Editado com Sucesso')));
                  }
                },
                child: const Text(
                  'Salvar Alterações',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
