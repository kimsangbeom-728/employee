import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoe_team_project/model/contract.dart';
import 'package:shoe_team_project/model/employee.dart';
import 'package:shoe_team_project/model/enum.dart';
import 'package:shoe_team_project/view_model/database_handler.dart';

////////////////////////////////////////////////////////////////////////////
/// 전자 결제 기안서 결제처리
////////////////////////////////////////////////////////////////////////////
class ProposalConfirm extends StatefulWidget {
  const ProposalConfirm({super.key});

  @override
  State<ProposalConfirm> createState() => _ProposalConfirmState();
}

class _ProposalConfirmState extends State<ProposalConfirm> {
  late DatabaseHandler handler;
  late TextEditingController titleEditingController; // 전자결제 제목
  late TextEditingController detailEditingController; // 전자결제 상세내용
  late TextEditingController documentTypeEditingController; // 전자결제 종류 (반품, 발주)
  late TextEditingController productCodeTypeEditingController; // 제품코드
  late TextEditingController qtyEditingController; // 수량입력
  late TextEditingController priceEditingController; // 금액입력
  late DateTime writeDate; // 작성일자
  late int qty; // 수량 (반품/발주)
  late int price; // 금액 (반품금액/발주금액)
  late int documentSeqNo; // 전자결제 SeqNo
  late String documentSeqNoText; // 전자결제 번호
  late String documentDateText; // 전자결제 작성일자 표시용
  late bool isHeadOffice; // True:본사, False:대리점점
  late List<Employee> employeeLevel01List; // 1차 결제 권한자
  late List<Employee> employeeLevel02List; // 2차 결제 권한자
  late String writeEmpNo; // 기안작성자 사번
  late String writeEmpName; // 기안작성자 성명
  late EDApprovalStateEnum approvalStateEnum; // 승인단계 상태

  late List<String> eSignImage; // ESign Image

  // [0]:사번, [1]:성명, [2]:근무처코드, [3]:작성일, [4]:작성자명, [5]:문서번호, [6]:제품코드
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
    qty = 0;
    price = 0;
    documentSeqNo = 0;
    approvalStateEnum = EDApprovalStateEnum.writing;
    employeeLevel01List = [];
    employeeLevel02List = [];
    eSignImage = [
      'images/sign.png',
      'images/sign_0.png',
      'images/sign_2.png',
      'images/sign_3.png',
      'images/sign_6.png',
    ];
    documentSeqNoText = '';
    writeEmpNo = '';
    writeEmpName = '';

    // 근무처 코드 추출
    var storeCd = value[ContractModifyParamEnum.storeCode.index]
        .toString()
        .split('(');
    // var storeCd = storeCd[1].substring(0, 5);

    isHeadOffice = storeCd[1].replaceAll(')', '') == '10000' ? true : false;

    // isHeadOffice =
    //     value[ContractConfirmParamEnum.storeCode.index] == '10000'
    //         ? true
    //         : false;
    getInitData();
    setInitData();
  }

  getInitData() async {
    List<Contract> docInfo = await handler.queryContractConfirm(
      value[ContractConfirmParamEnum.documentNo.index],
      value[ContractConfirmParamEnum.writeDate.index],
      value[ContractConfirmParamEnum.writeEmpNo.index],
      value[ContractConfirmParamEnum.orderItemCode.index],
    );

    if (docInfo.isNotEmpty) {
      titleEditingController.text = docInfo[0].documentTitle; // 제목
      detailEditingController.text = docInfo[0].documentDetail; // 사유
      productCodeTypeEditingController.text = docInfo[0].productCode; // 제품코드
      qtyEditingController.text = docInfo[0].quantity.toString(); // 수량
      priceEditingController.text = docInfo[0].orderingPrice.toString(); // 금액
      writeEmpNo = docInfo[0].startEmployeeNo; // 기안작성자 사번

      List<Employee> employee = await handler.queryEmployee(writeEmpNo);
      if (employee.isNotEmpty) {
        writeEmpName = employee[0].name;
      }

      approvalStateEnum =
          EDApprovalStateEnum.values[docInfo[0].approvalState]; // 결제진행 상태
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
      value[ContractConfirmParamEnum.employeeNo.index],
      value[ContractConfirmParamEnum.writeDate.index],
    );
    documentSeqNo = result.length + 1;
    documentSeqNoText = value[ContractConfirmParamEnum.documentNo.index];

    setState(() {});
  }

  @override
  void dispose() {
    // handler.closeDatabase();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '품의서 결제',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
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
                        decoration: BoxDecoration(
                          color: Colors.white,
                          image: DecorationImage(
                            image: AssetImage(
                              approvalStateEnum == EDApprovalStateEnum.writing
                                  ? eSignImage[ESignImageEnum.noSign.index]
                                  : eSignImage[ESignImageEnum.sign_0.index],
                            ),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      Text(
                        writeEmpName,
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
                        onPressed: () {
                          // 1차 승인처리
                          employeeLevel01List[0].employeeNo ==
                                  value[ContractConfirmParamEnum
                                      .employeeNo
                                      .index]
                              ? _showDialog(
                                false,
                                EDApprovalStateEnum.confirmed.index,
                              )
                              : '';
                        },
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
                        decoration: BoxDecoration(
                          color: Colors.white,
                          image: DecorationImage(
                            image:
                                approvalStateEnum.index <
                                        EDApprovalStateEnum.confirmed.index
                                    ? AssetImage(
                                      eSignImage[ESignImageEnum.noSign.index],
                                    )
                                    : AssetImage(
                                      eSignImage[ESignImageEnum.sign_2.index],
                                    ),
                            fit: BoxFit.contain,
                          ),
                        ),
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
                        onPressed: () {
                          // 2차 승인처리
                          employeeLevel02List[0].employeeNo ==
                                  value[ContractConfirmParamEnum
                                      .employeeNo
                                      .index]
                              ? _showDialog(
                                false,
                                EDApprovalStateEnum.completed.index,
                              )
                              : '';
                        },
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
                        decoration: BoxDecoration(
                          color: Colors.white,
                          image: DecorationImage(
                            image:
                                approvalStateEnum ==
                                        EDApprovalStateEnum.completed
                                    ? AssetImage(
                                      eSignImage[ESignImageEnum.sign_3.index],
                                    )
                                    : AssetImage(
                                      eSignImage[ESignImageEnum.noSign.index],
                                    ),
                            fit: BoxFit.contain,
                          ),
                        ),
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
                isHeadOffice
                    ? '${value[ContractConfirmParamEnum.storeCode.index]}'
                    : '매  장  :  ${value[ContractConfirmParamEnum.storeCode.index]} 대리점',
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
                readOnly: true,
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
                readOnly: true,
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
                readOnly: true,
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
                readOnly: true,
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
                readOnly: true,
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

            SizedBox(height: 200),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      _showDialog(true, EDApprovalStateEnum.declined.index);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      fixedSize: Size(150, 40),
                      elevation: 20.0,
                    ),
                    child: Text(
                      '반려',
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
                      // 1차 승인처리
                      employeeLevel01List[0].employeeNo ==
                              value[ContractConfirmParamEnum.employeeNo.index]
                          ? _showDialog(
                            false,
                            EDApprovalStateEnum.confirmed.index,
                          )
                          : '';
                      // 2차 승인처리
                      employeeLevel02List[0].employeeNo ==
                              value[ContractConfirmParamEnum.employeeNo.index]
                          ? _showDialog(
                            false,
                            EDApprovalStateEnum.completed.index,
                          )
                          : '';
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                      fixedSize: Size(150, 40),
                      elevation: 20.0,
                    ),
                    child: Text(
                      '승인',
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
  updateAction(int approvalValue) async {
    int result = await handler.updateContractConfirm(
      value[ContractConfirmParamEnum.documentNo.index],
      value[ContractConfirmParamEnum.writeDate.index],
      value[ContractConfirmParamEnum.orderItemCode.index],
      writeEmpNo,
      approvalValue,
    );
    if (result == 0) {
      // errorsnack bar
    } else {
      _showSnackbar('안내', '결제가 정상 처리되었습니다', false);
    }
  }

  _showDialog(bool isCancel, int approvalValue) {
    if (approvalStateEnum == EDApprovalStateEnum.completed) {
      Get.snackbar(
        '안내',
        '이미 품의 결제가 완료된 상태 입니다.',
        backgroundColor: Colors.red[100],
      );
      return;
    }
    Get.dialog(
      AlertDialog(
        title: const Text('확인'),
        content:
            isCancel
                ? Text(
                  '정말로 전자결제를 반려 처리 하시겠습니까?',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                )
                : Text(
                  '전자결제를 승인 하시겠습니까?',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
        actions: [
          TextButton(child: const Text("Close"), onPressed: () => Get.back()),
          TextButton(
            child: const Text("Ok"),
            onPressed: () {
              Get.back();
              Get.back();
              updateAction(approvalValue);
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
