import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:salary_budget/Presentation/Screens/view_record/model/view_model.dart';

class ViewRecordScreen extends StatefulWidget {
  @override
  _ViewRecordScreenState createState() => _ViewRecordScreenState();
}

class _ViewRecordScreenState extends State<ViewRecordScreen> {
  CollectionReference users = FirebaseFirestore.instance
      .collection('salary_data')
      .doc('7493008905')
      .collection('2020')
      .doc('Jun_salary')
      .collection('Expensed');

  late Stream<QuerySnapshot> _dataStream;

  @override
  void initState() {
    super.initState();
    _dataStream =
        users.snapshots(); // Listen for changes in the Firestore collection
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Firestore Data Table View'),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: _dataStream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            }
            // Extract the documents from the snapshot
            List<QueryDocumentSnapshot> documents = snapshot.data!.docs;
            return DataTable(
              columns: [
                DataColumn(
                  label: Text('Col1'),
                ),
                DataColumn(
                  label: Text('Col2'),
                ),
                DataColumn(
                  label: Text('Col1'),
                ),
                DataColumn(
                  label: Text('Col2'),
                ),
                DataColumn(
                  label: Text('Col1'),
                ),
                DataColumn(
                  label: Text('Col2'),
                ),
              ],
              rows: documents.map((document) {
                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;

                return DataRow(cells: [
                  DataCell(Text(data['expensed_particular'])),
                  DataCell(Text(data['expensed_date'])),
                  DataCell(Text(data['expensed_particular'])),
                  DataCell(Text(data['expensed_date'])),
                  DataCell(Text(data['expensed_particular'])),
                  DataCell(Text(data['expensed_date'])),
                ]);
              }).toList(),
            );
          },
        ));
  }
}