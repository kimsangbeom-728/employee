import 'package:flutter/material.dart';
import 'package:shoe_team_project/view_model/database_handler.dart';

class InventoryCheckMain extends StatefulWidget {
  const InventoryCheckMain({super.key});

  @override
  State<InventoryCheckMain> createState() => _InventoryCheckMainState();
}

class _InventoryCheckMainState extends State<InventoryCheckMain> {
  late DatabaseHandler handler;

  @override
  void initState() {
    handler = DatabaseHandler();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('제품별 현황'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
    );
  }
}
