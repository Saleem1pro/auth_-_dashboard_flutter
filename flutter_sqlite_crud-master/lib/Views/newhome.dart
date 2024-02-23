// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:sqlite_flutter_crud/Views/edit.dart';

class Newhome extends StatefulWidget {
  const Newhome({super.key, required id});

  @override
  _NewhomeState createState() => _NewhomeState();
}

class _NewhomeState extends State<Newhome> {
  late List<Student> students;

  Future<List<Student>> getData() async {
    var url = Uri.parse("http://192.168.249.1/dashboard_app/list.php");
    var response = await http.get(url);
    var responseBody = jsonDecode(response.body);
    List<Student> studentList = [];
    for (var data in responseBody) {
      Student student = Student(id: data['id'],name: data['name'], age: data['age']);
      studentList.add(student);
    }
    return studentList;
  }
  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Reading Data From SQL'),
            ElevatedButton(
              onPressed: () {
                            //Navigate to Notes
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const EditPage()));
                          },
              child: const Text('CRUD Page'),
            ),
          ],
        ),

        ),
        body: FutureBuilder(
          future: getData(),
          builder: (BuildContext context, AsyncSnapshot<List<Student>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              return PaginatedDataTable(
                columns: const [
                  DataColumn(label: Text('Id')),
                  DataColumn(label: Text('Name')),
                  DataColumn(label: Text('Age')),
                ],
                source: StudentDataSource(snapshot.data!),
                header: const Text('List of Students'),
                rowsPerPage: 10,
              );
            } else {
              return const Center(child: Text('No data available'));
            }
          },
        ),
      ),
    );
  }
}

class Student {
  late int id;
  late String name;
  late int age;

  Student({required this.id,required this.name, required this.age});
}

class StudentDataSource extends DataTableSource {
  final List<Student> students;

  StudentDataSource(this.students);

  @override
  DataRow? getRow(int index) {
    if (index >= students.length) return null;
    final student = students[index];
    return DataRow(cells: [
      DataCell(Text(student.id.toString())),
      DataCell(Text(student.name)),
      DataCell(Text(student.age.toString())),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => students.length;

  @override
  int get selectedRowCount => 0;
}