import 'package:flutter/material.dart';
import 'package:shoe_team_project/view_model/database_handler.dart';

class InventoryCheckDate extends StatefulWidget {
  const InventoryCheckDate({super.key});

  @override
  State<InventoryCheckDate> createState() => _InventoryCheckDateState();
}

class _InventoryCheckDateState extends State<InventoryCheckDate> {
  late DatabaseHandler handler;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('일자별 재고 현황'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
    );
  }
}
