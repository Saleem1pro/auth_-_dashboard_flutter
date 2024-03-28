// ignore_for_file: avoid_print, library_private_types_in_public_api, unused_student, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// ignore: unused_import

class EditPage extends StatefulWidget {
  const EditPage({super.key});

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  late List<Student> students;
  List<Map<String, dynamic>> studentList = [];
  late List<Student> filteredStudents;
  late List<Student> selectedStudents = [];
  
  get nameController => null;
  get ageController => null;


  @override
  void initState() {
    super.initState();
    getData();
  }
    void togglestudent(Student student) {
  setState(() {
    student.isSelected = !student.isSelected;
    if (student.isSelected) {
      selectedStudents.add(student);
    } else {
      selectedStudents.remove(student);
    }
  });
}
 

void deleteSelectedStudents() async {
  // Vérifiez s'il y a des étudiants sélectionnés
  if (selectedStudents.isNotEmpty) {
    // Prenez l'ID du premier étudiant sélectionné
    int id = selectedStudents.first.id;
  
    List<String> idsToDelete = selectedStudents.map((student) => student.id).cast<String>().toList();
    
    try {
      var url = Uri.parse("http://192.168.249.1/dashboard_app/delete.php");
      var response = await http.delete(url, body: {
        'ids': jsonEncode(idsToDelete),
      });
  
      if (response.statusCode == 200) {
        // Si la requête a réussi
        setState(() {
          studentList.removeWhere((student) => student['id'] == id);
        });
        print('Étudiants supprimés avec succès');
        
        // 1. Créer une nouvelle liste mise à jour sans les étudiants supprimés
        List<Student> updatedStudents = List.of(students);
        updatedStudents.removeWhere((student) => student.isSelected);
        
        // 2. Mettre à jour l'état "students" avec la nouvelle liste
        setState(() {
          students = updatedStudents;
          filteredStudents = students;
          selectedStudents.clear();
        });
  
        // 3. Appeler getData() pour rafraîchir la liste depuis la base de données
        await getData();
      } else {
        // Si la requête a échoué
        print('Échec de la suppression des étudiants. Code d\'état : ${response.statusCode}');
      }
    } catch (e) {
      // En cas d'erreur
      print('Erreur lors de la suppression des étudiants : $e');
    }
  } else {
    // Aucun étudiant n'est sélectionné, affichez un message d'erreur ou une action appropriée
  }
}

// Dans votre IconButton pour la suppression

Future<void> updateStudent(int id, String name, int age) async {
  try {
    var url = Uri.parse("http://192.168.249.1/dashboard_app/update.php");
    var response = await http.put(url, body: {
      'id': id.toString(),
      'name': name,
      'age': age.toString(),
    });

    if (response.statusCode == 200) {
      final updatedStudentList = json.decode(response.body);
      setState(() {
          int index = studentList.indexWhere((student) => student['id'] == id);
          if (index != -1) {
            studentList[index] = updatedStudentList;
          }
        });

        await getData();
      print('Étudiant mis à jour avec succès');
      // Rafraîchir les données pour afficher les changements
    } else {
      print('Échec de la mise à jour de l\'étudiant. Code d\'état : ${response.statusCode}');
    }
  } catch (e) {
    print('Erreur lors de la mise à jour de l\'étudiant : $e');
  }
}

//udpateSelectedStudent
void updateSelectedStudent() {
  // Vérifiez d'abord s'il y a un étudiant sélectionné
  if (selectedStudents.isNotEmpty) {
    // On suppose ici que vous ne permettez de sélectionner qu'un seul étudiant à la fois
    Student selectedStudent = selectedStudents.first;

    // Récupérer les valeurs actuelles de l'étudiant sélectionné
    String originalName = selectedStudent.name;
    int originalAge = selectedStudent.age;

    // Variables pour les nouvelles valeurs de l'étudiant
    String updatedName = originalName;
    int updatedAge = originalAge;

    // Afficher un dialog pour mettre à jour les données
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController nameController = TextEditingController(text: updatedName);
        TextEditingController ageController = TextEditingController(text: updatedAge.toString());

        return AlertDialog(
          title: const Text('Mettre à jour l\'étudiant'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                onChanged: (value) {
                  updatedName = value;
                },
                decoration: const InputDecoration(labelText: 'Nom de l\'étudiant'),
              ),
              TextField(
                controller: ageController,
                onChanged: (value) {
                  updatedAge = int.tryParse(value) ?? 0;
                },
                decoration: const InputDecoration(labelText: 'Âge de l\'étudiant'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Ferme le dialogue
              },
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                // Mettre à jour l'étudiant avec les nouvelles valeurs
                updateStudent(selectedStudent.id, updatedName, updatedAge);
                Navigator.of(context).pop(); // Ferme le dialogue
              },
              child: const Text('Enregistrer'),
            ),
          ],
        );
      },
    );
  } else {
    // Aucun étudiant n'est sélectionné, affichez un message d'erreur ou une action appropriée
  }
}

   
       
  Future<void> getData() async {
    var url = Uri.parse("http://192.168.249.1/dashboard_app/list.php");
    var response = await http.get(url);
    var responseBody = jsonDecode(response.body);
    // ignore: no_leading_underscores_for_local_identifiers
    List<Student> studentList = [];
    for (var data in responseBody) {
      Student student = Student(id: data['id'],name: data['name'], age: data['age']);
      studentList.add(student);
    }
    setState(() {
      students = studentList;
      filteredStudents = students;
    });
  }

  void _runFilter(String enteredKeyword) {
    setState(() {
      filteredStudents = students
          .where((student) =>
              student.name.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
      print(filteredStudents.length);
    });
  }
  
  
  

  
  void _showAddStudentDialog() {
    TextEditingController nameController = TextEditingController();
    TextEditingController ageController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Ajouter un nouvel étudiant'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nom de l\'étudiant'),
              ),
              TextField(
                controller: ageController,
                decoration: const InputDecoration(labelText: 'Âge de l\'étudiant'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Ferme le dialogue
              },
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                // Appel de la méthode pour ajouter un étudiant avec les valeurs des champs de texte
                addStudent(nameController.text, ageController.text);
                Navigator.of(context).pop(); // Ferme le dialogue
              },
              child: const Text('Enregistrer'),
            ),
          ],
        );
      },
    );
  }

  void addStudent(String name, String age) async {
    try {

      var url = Uri.parse("http://192.168.249.1/dashboard_app/create.php");
      var response = await http.post(url, body: {
        'name': name,
        'age': age,
      });

      if (response.statusCode == 200) {
        // Si la requête a réussi
        print('Nouvel étudiant ajouté avec succès');
        // Rafraîchissez les données pour afficher le nouvel étudiant ajouté
        getData();
      } else {
        // Si la requête a échoué
        print('Échec de l\'ajout de l\'étudiant. Code d\'état : ${response.statusCode}');
      }
    } catch (e) {
      // En cas d'erreur
      print('Erreur lors de l\'ajout de l\'étudiant : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Search Page'),
            ElevatedButton(
              onPressed: _showAddStudentDialog,
              child: const Icon(Icons.add),
            ),
            ElevatedButton(
              onPressed: updateSelectedStudent,
              child: const Icon(Icons.edit),
            ),
            ElevatedButton(
              onPressed: () {
    if (selectedStudents.isNotEmpty) {
      // Confirmer la suppression avec une boîte de dialogue
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Supprimer les étudiants'),
            content: const Text('Êtes-vous sûr de vouloir supprimer les étudiants sélectionnés ?'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Annuler'),
              ),
              ElevatedButton(
                onPressed: () {
                  deleteSelectedStudents();
                  Navigator.of(context).pop();
                },
                child: const Text('Supprimer'),
              ),
            ],
          );
        },
      );
    }
  },
              child: const Icon(Icons.delete),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              onChanged: _runFilter,
              decoration: const InputDecoration(
                labelText: 'Search',
                suffixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredStudents.length,
              itemBuilder: (context, index) {
                Student student = filteredStudents[index];
                return ListTile(
                  title: Text('Id: ${student.id} , Name: ${student.name}'),
                  subtitle: Text('Age: ${student.age}'),
                  trailing: TextButton(
                    onPressed: () {
                      togglestudent(student);
                    },
                    child: Icon(
                      student.isSelected ? Icons.check_box : Icons.check_box_outline_blank,
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

class Student {
  late int id;
  late String name;
  late int age;
  bool isSelected;

  Student({required this.id,required this.name, required this.age, this.isSelected = false});
}
