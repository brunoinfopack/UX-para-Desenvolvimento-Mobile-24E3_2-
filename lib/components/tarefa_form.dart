import 'dart:io';
import 'package:auto_control_panel/providers/tarefa_provider.dart';
import 'package:auto_control_panel/providers/weather_provider.dart';
import 'package:auto_control_panel/routes.dart';
import 'package:flutter/material.dart';
import 'package:projeto_tarefa_pk/projeto_tarefa_pk.dart';
import 'package:provider/provider.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:location/location.dart';

class TarefaForm extends StatelessWidget {
  TarefaForm({super.key});

  final nomeController = TextEditingController();
  final datahoraController = TextEditingController();
  final geoController = TextEditingController();
  final cidadeController = TextEditingController();
  final tempController = TextEditingController();
  final umidadeController = TextEditingController();
  String concluidoValue = 'NAO'; // Valor inicial do campo multiselect

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
    final tarefaProvider = context.watch<TarefaProvider>();
    final insert = tarefaProvider.insert;
    final weatherProvider = Provider.of<WeatherProvider>(context);

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
                'Nova Tarefa',
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
                value: concluidoValue,
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
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Informe a Descrição da Tarefa')));
                  } else if (datahoraController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Informe a Data e Hora')));
                  } else {
                    String name = nomeController.text;
                    DateTime datehour = DateTime.parse(datahoraController.text);
                    String geoloc = geoController.text;
                    String isConcluido = concluidoValue; // Valor do campo multiselect

                    final tarefs = Tarefa(name, datehour, geoloc, isConcluido);

                    insert(tarefs);
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Salvo com Sucesso')));
                    Navigator.pushNamed(context, Routes.HOME);
                  }
                },
                child: const Text(
                  'Salvar',
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
