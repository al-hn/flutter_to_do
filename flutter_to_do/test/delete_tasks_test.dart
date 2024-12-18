import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/view_models/app_view_model.dart';
import 'package:todo_list/models/task_model.dart';
import 'package:todo_list/views/bottom_sheets/delete_bottom_sheet_view.dart';

void main() {
  testWidgets("Delete All button clears tasks in the AppViewModel", (WidgetTester tester) async {
    // Arrange: Create a mock AppViewModel with some tasks
    final viewModel = AppViewModel();
    viewModel.addTask(Task("Task 1", false));
    viewModel.addTask(Task("Task 2", true));

    // Build the widget
    await tester.pumpWidget(
      ChangeNotifierProvider<AppViewModel>.value(
        value: viewModel,
        child: const MaterialApp(
          home: Scaffold(
            body: DeleteBottomSheetView(),
          ),
        ),
      ),
    );

    // Act: Tap the "Delete All" button
    final deleteAllButtonFinder = find.text("Delete All");
    await tester.tap(deleteAllButtonFinder);
    await tester.pump(); // Rebuild UI after state change

    // Assert: Verify that all tasks were deleted
    expect(viewModel.tasks.isEmpty, true);
  });

  testWidgets("Delete Completed button removes only completed tasks", (WidgetTester tester) async {
    // Arrange: Create a mock AppViewModel with some tasks
    final viewModel = AppViewModel();
    viewModel.addTask(Task("Task 1", false));
    viewModel.addTask(Task("Task 2", true)); // Completed

    // Build the widget
    await tester.pumpWidget(
      ChangeNotifierProvider<AppViewModel>.value(
        value: viewModel,
        child: const MaterialApp(
          home: Scaffold(
            body: DeleteBottomSheetView(),
          ),
        ),
      ),
    );

    // Act: Tap the "Delete Completed" button
    final deleteCompletedButtonFinder = find.text("Delete Completed");
    await tester.tap(deleteCompletedButtonFinder);
    await tester.pump(); // Rebuild UI after state change

    // Assert: Verify that only completed tasks were deleted
    expect(viewModel.tasks.length, 1);
    expect(viewModel.tasks.first.title, "Task 1");
  });
}
