import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salary_budget/Data/Core/Utils/app_constants.dart';
import 'package:salary_budget/Presentation/Screens/calculation/view/calculation_view.dart';
import 'package:salary_budget/Presentation/Screens/update_record/controller/update_controller.dart';
import 'package:salary_budget/Presentation/Screens/view_record/controller/view_controller.dart';
import 'package:salary_budget/Presentation/Screens/view_record/widgets/current_year_data.dart';
import 'package:salary_budget/Presentation/Screens/view_record/widgets/custom_year_data.dart';
import 'package:salary_budget/Data/Core/Utils/app_decoration.dart';

class ViewRecordScreen extends StatelessWidget {
  ViewRecordController viewRecordController = Get.put(ViewRecordController());

  UpdateRecordController updateRecordController =
      Get.put(UpdateRecordController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('View Record'),
          backgroundColor: Colors.white,
        ),
        bottomNavigationBar: CalculationNavbar(
          viewRecordController: viewRecordController,
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Column(
                    children: [
                      selectRadioButton(),
                      viewReceivedIncome(context),
                      dataTable(context),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  Widget selectRadioButton() {
    return Row(
      children: [
        Expanded(
          child: Obx(() => Row(
                children: List<Widget>.generate(
                    viewRecordController.radioOptions.length, (index) {
                  return Expanded(
                    child: RadioListTile(
                        title: Text(viewRecordController.radioOptions[index]
                            .toString()),
                        value: index,
                        groupValue: viewRecordController.selectedRadio.value,
                        onChanged: (int? value) {
                          viewRecordController.selectedRadio.value = value!;
                          viewRecordController.changeSelectedValue();
                        }),
                  );
                }),
              )),
        ),
      ],
    );
  }

  Widget viewReceivedIncome(BuildContext ctx) {
    return Obx(() {
      return viewRecordController.selectedRadio.value.isEqual(0)
          ? CurrentYearIncomeRecords(
              currentYearRecordsController: viewRecordController,
              incomeContext: ctx,
            )
          : CustomYearIncomeRecords(
              customYearRecordsController: viewRecordController,
              incomeContext: ctx,
            );
    });
  }

  Widget dataTable(BuildContext? ctx) {
    return Obx(() {
      return Visibility(
        visible: viewRecordController.isIncomeNull.value,
        child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: (viewRecordController.recordList.length == 0)
                ? Center(
                    child: Text('No record added.Firstly add the record.'),
                  )
                : DataTable(
                    columnSpacing: 20.0,
                    columns: <DataColumn>[
                      DataColumn(
                        label: Text('Date'),
                      ),
                      DataColumn(
                        label: Text('Particulars'),
                      ),
                      DataColumn(
                        label: Text('Type'),
                      ),
                      DataColumn(
                        label: Text('Amount'),
                      ),
                      DataColumn(
                        label: Text('Status'),
                      ),
                      DataColumn(
                        label: Text('Remarks'),
                      ),
                      DataColumn(
                        label: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Update'),
                            SizedBox(
                              width: 20,
                            ),
                            Text('Delete'),
                          ],
                        ),
                      ),
                    ],
                    rows: viewRecordController.recordList.map((data) {
                      return DataRow(cells: <DataCell>[
                        DataCell(
                          Text(data.transDate.toString()),
                        ),
                        DataCell(Text(data.transParticular.toString())),
                        DataCell(Text(data.transType.toString())),
                        DataCell(Text(data.transAmount.toString())),
                        DataCell(Text(data.transStatus.toString())),
                        DataCell(Text(data.transRemarks.toString())),
                        DataCell(Row(
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.edit,
                                color: Colors.blue,
                              ),
                              onPressed: () {
                                // Your update/edit button logic here
                                print(
                                    'Update button pressed for John ${data.docId}');
                                updateRecordController.getUpdateForm(
                                    ctx,
                                    data.docId.toString(),
                                    data.transDate.toString(),
                                    data.transParticular.toString(),
                                    data.transType.toString(),
                                    data.transAmount.toString(),
                                    data.transStatus.toString(),
                                    data.transRemarks.toString());
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                // Your delete button logic here
                                print('Delete button pressed for John');
                              },
                            ),
                          ],
                        ))
                      ]);
                    }).toList(),
                  )),
      );
    });
  }
}
