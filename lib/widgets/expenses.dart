import 'dart:math';

import 'package:expense_tracker/widgets/expenses_list/expenses_list.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/new_expense.dart';
import 'package:flutter/material.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpenses = [
    Expense(
      title: 'Flutter course',
      amount: 500,
      date: DateTime.now(),
      category: Category.work,
    ),
    Expense(
      title: 'Movie',
      amount: 900,
      date: DateTime.now(),
      category: Category.leisure,
    ),
    Expense(
      title: 'Flight Tickets',
      amount: 1500,
      date: DateTime.now(),
      category: Category.travel,
    ),
  ];

  void _addExpense(Expense expense) {
    setState(() {
      _registeredExpenses.add(expense);
    });
  }

  void _deleteExpense(Expense expense) {
  final expenseIndex = _registeredExpenses.indexOf(expense);


    setState(() {
      _registeredExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: const Text("Expense deleted"),
        action: SnackBarAction(label: 'Undo', onPressed: (){
          setState(() {
            _registeredExpenses.insert(expenseIndex, expense);
          });
        }),
      ),
    );
  }

  void _openExpenseOverlay() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) => NewExpense(onAddExpense: _addExpense),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget mainContent = const Center(
      child: Text('No expenses found.'),
    );

    if (_registeredExpenses.isNotEmpty) {
      mainContent = ExpensesList(
        expenses: _registeredExpenses,
        onRemoveExpense: _deleteExpense,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Expense Tracker"),
        actions: [
          IconButton(
            onPressed: _openExpenseOverlay,
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: Column(
        children: [
          const Text("The chart"),
          Expanded(
            child: mainContent,
          ),
        ],
      ),
    );
  }
}
