class TransactionItem {
  final int itemNo;  // 자리 수 2 ex (01 - 99)
  final String transactionitemDate;
  final String transactionitemNo;
  final String storeCodeitem;
  final String buyProductCode;
  final String buytDetailCode;
  final String buyProductName;
  final int buyProductPrice; //개당 단가
  final int buyProductQuantity; // 산 수량
  final int salePrice; // buyPrice * buyQuantity = 

  TransactionItem({
    required this.itemNo,
    required this.transactionitemDate,
    required this.transactionitemNo,
    required this.storeCodeitem,
    required this.buyProductCode,
    required this.buytDetailCode,
    required this.buyProductName,
    required this.buyProductPrice,
    required this.buyProductQuantity,
    required this.salePrice
  });

  TransactionItem.fromMap(Map<String,dynamic> res)
  :itemNo = res['itemNo'],
  transactionitemDate = res['transactionDate'],
  transactionitemNo = res['transactionNo'],
  storeCodeitem = res['storeCodeitem'],
  buyProductCode = res['buyProductCode'],
  buytDetailCode = res['buytDetailCode'],
  buyProductName = res['buyProductName'],
  buyProductPrice = res['buyProductPrice'],
  buyProductQuantity = res['buyProductQuantity'],
  salePrice = res['salePrice'];
}