import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoe_team_project/model/contract.dart';
import 'package:shoe_team_project/model/employee.dart';
import 'package:shoe_team_project/model/enum.dart';
import 'package:shoe_team_project/view_model/database_handler.dart';

////////////////////////////////////////////////////////////////////////////
/// 전자 결제 기안서 수정
////////////////////////////////////////////////////////////////////////////
class ProposalModify extends StatefulWidget {
  const ProposalModify({super.key});

  @override
  State<ProposalModify> createState() => _ProposalModifyState();
}

class _ProposalModifyState extends State<ProposalModify> {
  late DatabaseHandler handler;
  late TextEditingController titleEditingController; // 전자결제 제목
  late TextEditingController detailEditingController; // 전자결제 상세내용
  late TextEditingController documentTypeEditingController; // 전자결제 종류 (반품, 발주)
  late TextEditingController productCodeTypeEditingController; // 제품코드
  late TextEditingController qtyEditingController; // 수량입력
  late TextEditingController priceEditingController; // 금액입력
  late DateTime writeDate; // 작성일자
  // late String formattedDate; // date format 저장용
  late int qty; // 수량 (반품/발주)
  late int price; // 금액 (반품금액/발주금액)
  late int documentSeqNo; // 전자결제 SeqNo
  late String documentSeqNoText; // 전자결제 번호
  late String documentDateText; // 전자결제 작성일자 표시용
  late bool isHeadOffice; // True:본사, False:대리점점
  late List<Employee> employeeLevel01List; // 1차 결제 권한자
  late List<Employee> employeeLevel02List; // 2차 결제 권한자
  late String storeCode; // 근무처코드(매장코드)

  // [0]:사번, [1]:성명, [2]:근무처코드, [3]:작성일, [4]:문서번호, [5]:기안작성자
  var value = Get.arguments ?? ['__', '__', '__', '__', '__', '__'];

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
    titleEditingController = TextEditingController();
    detailEditingController = TextEditingController();
    documentTypeEditingController = TextEditingController();
    productCodeTypeEditingController = TextEditingController();
    qtyEditingController = TextEditingController();
    priceEditingController = TextEditingController();
    writeDate = DateTime.now();
    // formattedDate = writeDate.toIso8601String().split('T').first;
    qty = 0;
    price = 0;
    documentSeqNo = 0;
    employeeLevel01List = [];
    employeeLevel02List = [];
    documentSeqNoText = '';
    // 근무처 코드 추출
    var storeCd = value[ContractModifyParamEnum.storeCode.index]
        .toString()
        .split('(');
    storeCode = storeCd[1].replaceAll(')', '');
    isHeadOffice = storeCode == '10000' ? true : false;

    getInitData();
    setInitData();
  }

  getInitData() async {
    List<Contract> docInfo = await handler.queryContractDocumentNo(
      value[ContractModifyParamEnum.employeeNo.index],
      value[ContractModifyParamEnum.writeDate.index],
      value[ContractModifyParamEnum.documentNo.index],
    );

    if (docInfo.isNotEmpty) {
      titleEditingController.text = docInfo[0].documentTitle; // 제목
      detailEditingController.text = docInfo[0].documentDetail; // 사유
      productCodeTypeEditingController.text = docInfo[0].productCode; // 제품코드
      qtyEditingController.text = docInfo[0].quantity.toString(); // 수량
      priceEditingController.text = docInfo[0].orderingPrice.toString(); // 금액
    }
  }

  setInitData() async {
    employeeLevel01List = await handler.queryEmployeeAuthority(
      AuthorityEnum.authorLevel01.index,
    );
    employeeLevel02List = await handler.queryEmployeeAuthority(
      AuthorityEnum.authorLevel02.index,
    );
    List<Contract> result = await handler.queryContractDocumentDate(
      value[ContractModifyParamEnum.employeeNo.index],
      value[ContractModifyParamEnum.writeDate.index],
    );
    documentSeqNo = result.length + 1;
    documentSeqNoText = value[ContractModifyParamEnum.documentNo.index];
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '품의서 수정',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '문서번호 : $documentSeqNoText',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '작성일자 : '
                        '${writeDate.year.toString().padLeft(2, '0')}-'
                        '${writeDate.month.toString().padLeft(2, '0')}-'
                        '${writeDate.day.toString().padLeft(2, '0')}',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(width: MediaQuery.of(context).size.width - 700),

                Card(
                  shape: BeveledRectangleBorder(side: BorderSide(width: 0.5)),
                  elevation: 5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          '기안자',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        height: 100,
                        width: 130,
                        decoration: BoxDecoration(color: Colors.white),
                      ),
                      Text(
                        value[ContractModifyParamEnum.employeeName.index],
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Card(
                  shape: BeveledRectangleBorder(side: BorderSide(width: 0.5)),
                  elevation: 5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          '1차승인',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        height: 100,
                        width: 130,
                        decoration: BoxDecoration(color: Colors.white),
                      ),
                      Text(
                        employeeLevel01List.isNotEmpty
                            ? employeeLevel01List[0].name
                            : '',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Card(
                  shape: BeveledRectangleBorder(side: BorderSide(width: 0.5)),
                  elevation: 5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          '2차승인',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        height: 100,
                        width: 130,
                        decoration: BoxDecoration(color: Colors.white),
                      ),
                      Text(
                        employeeLevel02List.isNotEmpty
                            ? employeeLevel02List[0].name
                            : '',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '매  장  :  ${value[ContractModifyParamEnum.storeCode.index]} 대리점',
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: Divider(thickness: 1, color: Colors.black),
            ),

            SizedBox(height: 50),
            // 기안 제목
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: titleEditingController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.title),
                  border: OutlineInputBorder(),
                  labelText: '기안 제목을 입력하세요',
                ),
                keyboardType: TextInputType.text,
                maxLength: 30,
                maxLines: 1,
              ),
            ),
            // 제품코드
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: productCodeTypeEditingController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.qr_code_2),
                  border: OutlineInputBorder(),
                  labelText: '제품코드를 입력하세요',
                ),
                keyboardType: TextInputType.text,
                maxLength: 10,
                maxLines: 1,
              ),
            ),
            // 수량
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: qtyEditingController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.price_change_outlined),
                  border: OutlineInputBorder(),
                  labelText: isHeadOffice ? '발주 수량을 입력하세요' : '반품 수량을 입력하세요',
                ),
                keyboardType: TextInputType.text,
                maxLength: 5,
                maxLines: 1,
              ),
            ),
            // 금액
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: priceEditingController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.price_change_outlined),
                  border: OutlineInputBorder(),
                  labelText: isHeadOffice ? '발주 금액을 입력하세요' : '반품 금액을 입력하세요',
                ),
                keyboardType: TextInputType.text,
                maxLength: 12,
                maxLines: 1,
              ),
            ),
            // 기안 상세
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: detailEditingController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: isHeadOffice ? '세부 사항을 입력하세요' : '반품 사유를 입력하세요',
                  hintText: '상세내용',
                ),
                keyboardType: TextInputType.text,
                maxLength: 100,
                maxLines: 4,
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      _showDialog(true);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      foregroundColor: Colors.black,
                      fixedSize: Size(150, 40),
                      elevation: 20.0,
                    ),
                    child: Text(
                      '임시저장',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                      fixedSize: Size(150, 40),
                      elevation: 20.0,
                    ),
                    child: Text(
                      '취소',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      _showDialog(false);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                      fixedSize: Size(150, 40),
                      elevation: 20.0,
                    ),
                    child: Text(
                      '신청',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /////////////////////////////////////////////
  /// 전자결제 Db Update
  updateAction(bool isSaveOnly) async {
    var contractUpdate = Contract(
      documentNo:
          value[ContractModifyParamEnum
              .documentNo
              .index], //전자결제번호 : ED,년월일(6),SEQNO(2)
      writeDate: value[ContractModifyParamEnum.writeDate.index],
      productCode: productCodeTypeEditingController.text,
      startEmployeeNo: value[ContractModifyParamEnum.employeeNo.index],
      writeEmployeeName: value[ContractModifyParamEnum.writeName.index],
      middleEmployeeNo: employeeLevel01List[0].employeeNo,
      endEmployeeNo: employeeLevel02List[0].employeeNo,
      documentTitle: titleEditingController.text,
      documentDetail: detailEditingController.text,
      approvalState:
          isSaveOnly
              ? EDApprovalStateEnum.writing.index
              : EDApprovalStateEnum.approval.index,
      orderingPrice: int.parse(priceEditingController.text),
      stockDate: null,
      moveDate: null,
      quantity: int.parse(qtyEditingController.text),
      orderState: null,
      storeCode: storeCode,
    );

    int result = await handler.updateContract(contractUpdate);
    if (result == 0) {
      // errorsnack bar
    } else {
      _showSnackbar('안내', '수정이 정상 처리되었습니다', false);
    }
  }

  _showDialog(bool isSaveOnly) {
    Get.dialog(
      AlertDialog(
        title: const Text('확인'),
        content:
            isSaveOnly ? Text('전자결제를 임시저장 하시겠습니까?') : Text('전자결제를 신청 하시겠습니까?'),
        actions: [
          TextButton(child: const Text("Close"), onPressed: () => Get.back()),
          TextButton(
            child: const Text("Ok"),
            onPressed: () {
              Get.back();
              Get.back();
              updateAction(isSaveOnly);
            },
          ),
        ],
      ),
    );
  }

  _showSnackbar(String title, String message, bool isError) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      duration: Duration(seconds: 2),
      backgroundColor: isError ? Colors.red[100] : Colors.amber[100],
      colorText: isError ? Colors.red : Colors.black,
    );
  }
}
