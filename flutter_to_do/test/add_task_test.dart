import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/view_models/app_view_model.dart';
import 'package:todo_list/views/bottom_sheets/add_task_bottom_sheet_view.dart';

void main() {
  testWidgets("Add Task button adds a task to the AppViewModel", (WidgetTester tester) async {
    // Arrange: Create a mock AppViewModel
    final viewModel = AppViewModel();

    // Build the widget
    await tester.pumpWidget(
      ChangeNotifierProvider<AppViewModel>.value(
        value: viewModel,
        child: const MaterialApp(
          home: Scaffold(
            body: AddTaskBottomSheetView(),
          ),
        ),
      ),
    );

    // Act: Simulate user input and form submission
    final textFieldFinder = find.byType(TextField);
    await tester.enterText(textFieldFinder, "New Task");
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump(); // Rebuild UI after state change

    // Assert: Verify that the task was added to the ViewModel
    expect(viewModel.tasks.length, 1);
    expect(viewModel.tasks.first.title, "New Task");
  });
}
