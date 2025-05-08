import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoe_team_project/model/employee.dart';
import 'package:shoe_team_project/model/enum.dart';
import 'package:shoe_team_project/view/inventory_check_store.dart';
import 'package:shoe_team_project/view/proposal_page.dart';
import 'package:shoe_team_project/view/traninfo_page.dart';
import 'package:shoe_team_project/view_model/database_handler.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // Property
  late DatabaseHandler handler; // db handler
  late List<Employee> employeeLevel01List; // 1차 결제 권한자
  late List<Employee> employeeLevel02List; // 2차 결제 권한자

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
    employeeLevel01List = [];
    employeeLevel02List = [];

    setInitData();
  }

  setInitData() async {
    employeeLevel01List = await handler.queryEmployeeAuthority(
      AuthorityEnum.authorLevel01.index,
    );
    employeeLevel02List = await handler.queryEmployeeAuthority(
      AuthorityEnum.authorLevel02.index,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 반품 접수 처리
            ElevatedButton(
              onPressed: () {
                Get.to(
                  ProposalPage(),
                  arguments: [
                    // 반품접수 테스트 (강남 대리점 사원)
                    // [0]:사번, [1]:성명, [2]:근무처, [3]:결제권한(authority)
                    '25050401',
                    '너사원',
                    StoreCodeEnum.gangnam.storeCodeEnumText,
                    0,
                  ],
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: Text('강남점 반품 접수', style: TextStyle(fontSize: 15)),
            ),
            // 1차 승인 처리
            ElevatedButton(
              onPressed: () {
                Get.to(
                  ProposalPage(),
                  arguments: [
                    // 1차 결제권자 테스트 (본사직원 과장)
                    // [0]:사번, [1]:성명, [2]:근무처, [3]:결제권한(authority)
                    '25010103',
                    '나과장',
                    StoreCodeEnum.headOffice.storeCodeEnumText,
                    1,
                  ],
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: Text('1차 승인처리', style: TextStyle(fontSize: 15)),
            ),
            // 2차 승인 처리
            ElevatedButton(
              onPressed: () {
                Get.to(
                  ProposalPage(),
                  arguments: [
                    // 2차 결제권자 테스트 (본사직원 부장)
                    // [0]:사번, [1]:성명, [2]:근무처, [3]:결제권한(authority)
                    '25010102',
                    '나부장',
                    StoreCodeEnum.headOffice.storeCodeEnumText,
                    2,
                  ],
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: Text('2차 승인처리', style: TextStyle(fontSize: 15)),
            ),
            // 발주 신청 처리
            ElevatedButton(
              onPressed: () {
                Get.to(
                  ProposalPage(),
                  arguments: [
                    // 반품접수 테스트 (강남 대리점 사원)
                    // [0]:사번, [1]:성명, [2]:근무처, [3]:결제권한(authority)
                    '25010105',
                    '나사원',
                    StoreCodeEnum.headOffice.storeCodeEnumText,
                    0,
                  ],
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: Text('발주신청', style: TextStyle(fontSize: 15)),
            ),
            // Tran Info
            ElevatedButton(
              onPressed: () {
                Get.to(TraninfoPage());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: Text('Tran Info', style: TextStyle(fontSize: 15)),
            ),
            // 매장별 재고확인
            ElevatedButton(
              onPressed: () {
                Get.to(InventoryCheckStore());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: Text('매장별 재고확인', style: TextStyle(fontSize: 15)),
            ),
          ],
        ),
      ),
    );
  }
}
