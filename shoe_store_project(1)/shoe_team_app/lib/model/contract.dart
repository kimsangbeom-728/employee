class Contract {
  final String documentNo; // 전자결제번호 : ED,년월일(6),SEQNO(2)
  final String writeDate; // 작성일
  final String productCode; // 제품코드
  final String startEmployeeNo; // 사원번호
  final String writeEmployeeName; // 작성자
  final String middleEmployeeNo; // 중간결제자
  final String endEmployeeNo; // 최종결제자
  final String documentTitle; // 전자결제 제목
  final String documentDetail; // 전자결제 상세
  final int approvalState; // 전자결제 상태
  final int orderingPrice; // 반품금액/발주단가
  final String? stockDate; // 입고일자 (본사 <- 제조사)
  final String? moveDate; // 대리점 이동일자
  final int quantity; // 반품수량/수발수량
  final int? orderState; // 발주상태
  final String storeCode; // 매장코드

  Contract({
    required this.documentNo,
    required this.writeDate,
    required this.productCode,
    required this.startEmployeeNo,
    required this.writeEmployeeName,
    required this.middleEmployeeNo,
    required this.endEmployeeNo,
    required this.documentTitle,
    required this.documentDetail,
    required this.approvalState,
    required this.orderingPrice,
    this.stockDate,
    this.moveDate,
    required this.quantity,
    this.orderState,
    required this.storeCode,
  });

  Contract.fromMap(Map<String, dynamic> res)
    : documentNo = res['documentNo'],
      writeDate = res['writeDate'],
      productCode = res['productCode'],
      startEmployeeNo = res['startEmployeeNo'],
      writeEmployeeName = res['writeEmployeeName'],
      middleEmployeeNo = res['middleEmployeeNo'],
      endEmployeeNo = res['endEmployeeNo'],
      documentTitle = res['documentTitle'],
      documentDetail = res['documentDetail'],
      approvalState = res['approvalState'],
      orderingPrice = res['orderingPrice'],
      stockDate = res['stockDate'],
      moveDate = res['moveDate'],
      quantity = res['quantity'],
      orderState = res['orderState'],
      storeCode = res['storeCode'];
}
