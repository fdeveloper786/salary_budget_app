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
          title: Text('Salary Budget Record View'),
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
                  label: Text('Expended Amount'),
                ),
                DataColumn(
                  label: Text('Expended Date'),
                ),
                DataColumn(
                  label: Text('Expended Particular'),
                ),
                DataColumn(
                  label: Text('Expended Type'),
                ),
                DataColumn(
                  label: Text('Payment Date'),
                ),
                DataColumn(
                  label: Text('Payment Status'),
                ),
              ],
              rows: documents.map((document) {
                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;

                return DataRow(cells: [
                  DataCell(Text(data['expensed_amount'])),
                  DataCell(Text(data['expensed_date'])),
                  DataCell(Text(data['expensed_particular'])),
                  DataCell(Text(data['expensed_type'])),
                  DataCell(Text(data['expensed_date'])),
                  DataCell(Text(data['expensed_status'])),
                ]);
              }).toList(),
            );
          },
        ));
  }
}
