import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projeto_tarefa_pk/projeto_tarefa_pk.dart';

class TarefaProvider extends ChangeNotifier {
  FirebaseFirestore db = FirebaseFirestore.instance;
  String collection = "tarefas";

  List<Tarefa> tarefass = [];

  //int number = 0;

  void addTarefas(Tarefa tarfs) {
    tarefass.add(tarfs);
    notifyListeners();
  }

  list() {
    db.collection(collection).orderBy('isConcluido', descending: false).get().then((QuerySnapshot qs) {
      for (var doc in qs.docs) {
        var tfs = doc.data() as Map<String, dynamic>;
        DateTime dt = (tfs['dataHora'] as Timestamp).toDate();
        tfs['dataHora'] = dt;
        tarefass.add(Tarefa.fromMap(doc.id, tfs));
        notifyListeners();
      }
    });
  }

  int _recordCount = 0;
  int get recordCount => _recordCount;

  // Função para contar documentos em uma coleção específica
  Future<void> countDocuments(String collectionName) async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection(collectionName).get();
    _recordCount = snapshot.size;

    notifyListeners(); // Notifica ouvintes sobre a mudança
  }

  int _recordCountC = 0;
  int get recordCountC => _recordCountC;

  // Função para contar documentos em uma coleção específica
  Future<void> countDocumentsC(String collectionName) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection(collectionName)
        .where('isConcluido', isEqualTo: 'SIM')
        .get();
    _recordCountC = snapshot.size;

    notifyListeners(); // Notifica ouvintes sobre a mudança
  }

  int _recordCountP = 0;
  int get recordCountP => _recordCountP;
  Future<void> countDocumentsP(String collectionName) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection(collectionName)
        .where('isConcluido', isEqualTo: 'NAO')
        .get();
    _recordCountP = snapshot.size;

    notifyListeners(); // Notifica ouvintes sobre a mudança
  }

  insert(Tarefa tarfs) {
    var data = <String, dynamic>{
      'nome': tarfs.nome,
      'dataHora': tarfs.dataHora,
      'geolocalizacao': tarfs.geolocalizacao,
      'isConcluido': tarfs.isConcluido
    };

    var future = db.collection(collection).add(data);

    future.then((DocumentReference doc) {
      String id = doc.id;
      tarfs.id = id;
      tarefass.add(tarfs);
      notifyListeners();
    });
  }

  update(Tarefa tarfs) {
    var data = <String, dynamic>{
      'nome': tarfs.nome,
      'dataHora': tarfs.dataHora,
      'geolocalizacao': tarfs.geolocalizacao,
      'isConcluido': tarfs.isConcluido
    };

    db.collection(collection).doc(tarfs.id).update(data);
    notifyListeners();
  }

  delete(Tarefa tarfs) {
    var future = db.collection(collection).doc(tarfs.id).delete();
    future.then((_) {
      tarefass.remove(tarfs);
      notifyListeners();
    });
  }
}
