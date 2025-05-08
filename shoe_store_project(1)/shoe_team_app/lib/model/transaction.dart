class Tran {
    final String transactionNo; // 자리 수 4 (0001 - 9999) 어차피 String임
    final String transactionDate; 
    final String userId;
    final String storeCode;
    final int transactionState; // 0은 주문 확정, 1은 주문 취소, 2는 반품
    final int transactionPrice; // 한 거래에서의 총 금액 
    final String? originDate;
    final String? originNo;
    final String? returnReason;
    final String? review;
    final String tranName;
    final int sumQuantity; // 한 거래의 총 수량
    

  Tran({
    required this.transactionNo,
    required this.transactionDate,
    required this.userId,
    required this.storeCode,
    required this.transactionState,
    required this.transactionPrice,
    this.originDate,
    this.originNo,
    this.returnReason,
    this.review,
    required this.tranName,
    required this.sumQuantity,
  });

    Tran.fromMap(Map<String,dynamic> res)
    :transactionNo = res['transactionNo'],
    transactionDate = res['transactionDate'],
    userId = res['userId'],
    storeCode = res['storeCode'],
    transactionState = res['transactionState'],
    transactionPrice = res['transactionPrice'],
    originDate = res['originDate'],
    originNo = res['originNo'],
    returnReason = res['returnReason'],
    review = res['review'],
    tranName = res['tranname'],
    sumQuantity = res['sumQuantity'];
}
