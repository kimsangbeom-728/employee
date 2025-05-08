import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoe_team_project/model/employee.dart';
import 'package:shoe_team_project/model/enum.dart';
import 'package:shoe_team_project/view/proposal_confirm.dart';
import 'package:shoe_team_project/view/proposal_modify.dart';
import 'package:shoe_team_project/view/proposal_write.dart';
import 'package:shoe_team_project/view_model/database_handler.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

////////////////////////////////////////////////////////////////////////////
/// 전자 결제 목록 (Main) Page
////////////////////////////////////////////////////////////////////////////
class ProposalPage extends StatefulWidget {
  const ProposalPage({super.key});

  @override
  State<ProposalPage> createState() => _ProposalPageState();
}

class _ProposalPageState extends State<ProposalPage> {
  // Property
  late DatabaseHandler handler; // db handler
  late int searchQuery; // 검색 쿼리
  late DateTime searchDate;
  late String employeeNo; // 사번
  late String employeeName; // 성명
  late String employeeStoreCode; // 근무처코드
  late String orderProductCode; // 발주상품코드
  late int orderProductQty; // 발주상품수량
  late int authorityFilter; // 결제 대상
  late bool isEDocumentConfirm; // 전자결제 승인여부
  late List<Employee> employeeLevel01List; // 1차 결제 권한자
  late List<Employee> employeeLevel02List; // 2차 결제 권한자
  late String storeInfo; // 근무처정보
  late SelectApprovalStateEnum selectApprovalStateEnum; // 일정 카테고리
  late bool isCheckedAll;
  late bool isChecked_1;
  late bool isChecked_2;
  late bool isChecked_3;
  // late String storeCode; // 근무처 코드

  var value =
      Get.arguments ??
      ['__', '__', '__', 0]; // [0]:사번, [1]:성명, [2]:근무처, [3]:결제권한(authority)

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
    searchQuery = 0;
    employeeName = '';
    storeInfo = '';
    // storeCode = '';
    searchDate = DateTime.now();
    employeeLevel01List = [];
    employeeLevel02List = [];
    isEDocumentConfirm = false;
    isCheckedAll = false;
    isChecked_1 = false;
    isChecked_2 = false;
    isChecked_3 = false;

    // 점포정보
    storeInfo = value[ContractModifyParamEnum.storeCode.index];
    // 근무처 코드 추출
    var storeCd = value[ContractModifyParamEnum.storeCode.index]
        .toString()
        .split('(');
    employeeStoreCode = storeCd[1].substring(0, 5);

    employeeNo = value[ContractMainParamEnum.employeeNo.index]; // 사번
    employeeName = value[ContractMainParamEnum.employeeName.index]; // 이름
    orderProductCode = '';
    orderProductQty = 0;
    authorityFilter = value[ContractMainParamEnum.authority.index]; // 결제권한등급

    if (authorityFilter == 1) {
      isChecked_1 = true;
      switchChangeEnum(SelectApprovalStateEnum.waiting, true);
    } else if (authorityFilter == 2) {
      isChecked_2 = true;
      switchChangeEnum(SelectApprovalStateEnum.confirmed, true);
    } else if (authorityFilter == 3) {
      isChecked_3 = true;
      switchChangeEnum(SelectApprovalStateEnum.completed, true);
    } else {
      isCheckedAll = true;
      switchChangeEnum(SelectApprovalStateEnum.all, true);
    }

    // 1,2 차 승인권자 체크
    if (authorityFilter == 1 || authorityFilter == 2) {
      // 조건이 참일 때 실행할 코드
      isEDocumentConfirm = true;
    }
  }

  @override
  void dispose() {
    handler.closeDatabase();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '품의서',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.primaryContainer,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(40),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 전체 검색
                  SizedBox(
                    width: 250,
                    child: SwitchListTile(
                      title: Text(
                        '전체',
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      value: isCheckedAll,
                      activeColor: Colors.amber[100],
                      onChanged: (value) {
                        switchChangeEnum(SelectApprovalStateEnum.all, value);
                        setState(() {});
                      },
                    ),
                  ),
                  // 승인대기 검색
                  SizedBox(
                    width: 250,
                    child: SwitchListTile(
                      title: Text(
                        '승인대기',
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      value: isChecked_1,
                      activeColor: Colors.amber[100],
                      onChanged: (value) {
                        switchChangeEnum(
                          SelectApprovalStateEnum.waiting,
                          value,
                        );
                        setState(() {});
                      },
                    ),
                  ),
                  // 1차승인 검색
                  SizedBox(
                    width: 250,
                    child: SwitchListTile(
                      title: Text(
                        '1차승인완료',
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      value: isChecked_2,
                      activeColor: Colors.amber[100],
                      onChanged: (value) {
                        switchChangeEnum(
                          SelectApprovalStateEnum.confirmed,
                          value,
                        );
                        setState(() {});
                      },
                    ),
                  ),
                  // 2차 승인검색
                  SizedBox(
                    width: 250,
                    child: SwitchListTile(
                      title: Text(
                        '2차승인완료',
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      value: isChecked_3,
                      activeColor: Colors.amber[100],
                      onChanged: (value) {
                        switchChangeEnum(
                          SelectApprovalStateEnum.completed,
                          value,
                        );
                        setState(() {});
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: FutureBuilder(
        future:
            isEDocumentConfirm
                ? handler.queryContractConfirmAll(
                  employeeNo,
                  value[ContractMainParamEnum.authority.index],
                )
                : handler.queryContractDocumentAll(employeeNo),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData) {
            // 검색 필터링
            final eDocumentConfirmList =
                snapshot.data!.where((contract) {
                  return searchQuery == 0
                      ? contract.approvalState >= searchQuery
                      : contract.approvalState == searchQuery;
                }).toList();

            return ListView.builder(
              itemCount: eDocumentConfirmList.length, // snapshot.data!.length,
              itemBuilder: (context, index) {
                final contract = eDocumentConfirmList[index];
                return Slidable(
                  // 수정선택
                  startActionPane: ActionPane(
                    motion: BehindMotion(),
                    children: [
                      SlidableAction(
                        backgroundColor: Colors.green,
                        icon: Icons.edit,
                        label: '수정',
                        onPressed: (context) async {
                          // TODO : 수정 Page
                          contract.approvalState ==
                                  EDApprovalStateEnum.writing.index
                              ? Get.to(
                                ProposalModify(),
                                arguments: [
                                  employeeNo,
                                  employeeName,
                                  storeInfo,
                                  contract.writeDate,
                                  contract.documentNo,
                                  contract.writeEmployeeName,
                                ],
                              )!.then((value) => reloadData())
                              : _showSnackbar(
                                '경고',
                                '진행중인 결제는 수정이 불가능 합니다',
                                true,
                              );
                        },
                      ),
                    ],
                  ),
                  // 삭제 선택
                  endActionPane: ActionPane(
                    motion: BehindMotion(),
                    children: [
                      SlidableAction(
                        backgroundColor: Colors.red,
                        icon: Icons.delete,
                        label: '삭제',
                        onPressed: (context) async {
                          contract.approvalState ==
                                  EDApprovalStateEnum.writing.index
                              ? await handler.deleteContractDocument(
                                contract.documentNo,
                              )
                              : _showSnackbar(
                                '경고',
                                '진행중인 결제는 삭제가 불가능 합니다',
                                true,
                              );
                        },
                      ),
                    ],
                  ),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                      side: BorderSide(width: 0.1),
                    ),
                    elevation: 5,
                    color: index % 2 == 0 ? Colors.green[50] : Colors.amber[50],
                    shadowColor: Colors.black,
                    child: GestureDetector(
                      onTap: () {
                        orderProductCode = contract.productCode; // 제품코드
                        orderProductQty = contract.quantity; // 수량
                        showProposalDetail(
                          contract.documentNo, // 문서번호
                          contract.documentTitle, // 문서타이틀
                          contract.documentDetail, // 상세내용
                          contract.quantity, // 신청수량
                          contract.orderingPrice, // 신청금액
                          contract.productCode, // 신청제품
                          contract.writeDate, // 작성일
                          contract.startEmployeeNo, // 작성자사번
                          contract.writeEmployeeName, // 작성자성명
                        );
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // 품의서 결제 상태 색상 표시
                          Container(
                            height: 150,
                            width: 7,
                            color: getStateColor(contract.approvalState),
                          ),
                          SizedBox(width: 10),
                          // 품의서 내용
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(8, 5, 8, 1),
                                child: Text(
                                  '문서번호 : ${contract.documentNo}',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(8, 1, 8, 1),
                                child: Text(
                                  '전자결제 : ${contract.documentTitle}',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(8, 1, 8, 1),
                                child: Text(
                                  '작성일자 : ${contract.writeDate}',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(8, 1, 8, 1),
                                child: Text(
                                  '작 성 자 : ${contract.writeEmployeeName}',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(8, 1, 8, 5),
                                child: Text(
                                  '진행단계 : ${EDApprovalStateEnum.values[contract.approvalState].eDApprovalStateText}',
                                  style: TextStyle(
                                    color: getStateColor(
                                      contract.approvalState,
                                    ),
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),

      // 전자결제 추가
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(
            ProposalWrite(),
            // [0]:사번, [1]:성명, [2]:근무처코드, [3]:발주상품코드, [4]:발주수량 //[5]:기안작성자
            arguments: [employeeNo, employeeName, storeInfo, '', 0],
          )!.then((value) => reloadData());
        },
        backgroundColor: Colors.amber,
        child: Icon(Icons.add),
      ),
    );
  }

  ///////////////////////////////////////////////////////
  /// 전자결제 내용보기
  showProposalDetail(
    String docNo,
    String docTitle,
    String docContents,
    int qty,
    int price,
    String productCode,
    String writeDate,
    String writeEmpNo,
    String writeEmpName,
  ) {
    Get.bottomSheet(
      ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: Container(
          height: 300,
          width: 500,
          padding: EdgeInsets.all(16),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '문서번호 : $docNo',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              Text(
                '문서제목 : $docTitle',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              Text(
                '작 성 자 : $writeEmpName',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              Text(
                '제품코드 : $productCode',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              Text(
                '반품수량 : $qty',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              Text(
                '반품금액 : $price',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              Text(
                '문서내용 : $docContents',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                        // Get.to(ProposalConfirm())!.then((value) => reloadData());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
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
                        Get.back();
                        Get.to(
                          ProposalConfirm(),
                          arguments: [
                            // [0]:사번, [1]:성명, [2]:근무처정보, [3]:작성일, [4]:작성자사번, [5]:문서번호, [6]:제품코드
                            value[ContractMainParamEnum.employeeNo.index],
                            value[ContractMainParamEnum.employeeName.index],
                            storeInfo,
                            writeDate,
                            writeEmpNo,
                            docNo,
                            orderProductCode,
                          ],
                        )!.then((value) => reloadData());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                      child: Text(
                        '상세',
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
      ),
    );
  }

  //////////////////////////////////////////////////
  /// 카테고리 스위치 동기화
  switchChangeEnum(SelectApprovalStateEnum approvalStateEnum, bool isValue) {
    if (isValue) {
      switch (approvalStateEnum) {
        // 모든 기안 품의 보기
        case SelectApprovalStateEnum.all:
          isCheckedAll = true;
          isChecked_1 = false;
          isChecked_2 = false;
          isChecked_3 = false;
          selectApprovalStateEnum = SelectApprovalStateEnum.all;
          searchQuery = 0;
          break;
        // 승인대기
        case SelectApprovalStateEnum.waiting:
          isCheckedAll = false;
          isChecked_1 = true;
          isChecked_2 = false;
          isChecked_3 = false;
          selectApprovalStateEnum = SelectApprovalStateEnum.waiting;
          searchQuery = 1;
          break;
        // 1차 승인완료
        case SelectApprovalStateEnum.confirmed:
          isCheckedAll = false;
          isChecked_1 = false;
          isChecked_2 = true;
          isChecked_3 = false;
          selectApprovalStateEnum = SelectApprovalStateEnum.confirmed;
          searchQuery = 2;
          break;
        // 2차 승인완료
        case SelectApprovalStateEnum.completed:
          isCheckedAll = false;
          isChecked_1 = false;
          isChecked_2 = false;
          isChecked_3 = true;
          selectApprovalStateEnum = SelectApprovalStateEnum.completed;
          searchQuery = 3;
          break;

        default:
          break;
      }
    }
    setState(() {});
  }

  ///////////////////////////////////////////////////////
  /// 전자결제 상태별 Color 값 구하기
  Color getStateColor(int state) {
    Color resultColor;

    if (state == EDApprovalStateEnum.writing.index) {
      resultColor = Colors.grey; // 기안서 작성 중
    } else if (state == EDApprovalStateEnum.approval.index) {
      resultColor = Colors.blueGrey; // 승인 요청 중
    } else if (state == EDApprovalStateEnum.confirmed.index) {
      resultColor = Colors.green; // 승인 완결
    } else if (state == EDApprovalStateEnum.completed.index) {
      resultColor = Colors.blue; // 승인 완료
    } else {
      resultColor = Colors.red; // 승인 요청 중
    }
    return resultColor;
  }

  ///////////////////////////////////////////////////////
  /// DB Data Reload
  reloadData() {
    handler.queryContractDocumentAll(employeeNo);
    setState(() {});
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
