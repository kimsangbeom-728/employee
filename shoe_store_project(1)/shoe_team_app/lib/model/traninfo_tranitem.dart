import 'package:shoe_team_project/model/transaction.dart';
import 'package:shoe_team_project/model/transaction_item.dart';

class TraninfoTranItem {
  final Tran? tran;
  final TransactionItem item;

  TraninfoTranItem({
    this.tran,
    required this.item,
  });

  factory TraninfoTranItem.fromMap(Map<String,dynamic> res){
    return TraninfoTranItem(
      tran: Tran.fromMap(res),
      item: TransactionItem.fromMap(res)
      );
  }
}