import 'package:flutter/material.dart';
import 'package:shoe_team_project/model/enum.dart';
import 'package:shoe_team_project/view_model/database_handler.dart';

class InventoryCheckStore extends StatefulWidget {
  const InventoryCheckStore({super.key});

  @override
  State<InventoryCheckStore> createState() => _InventoryCheckStoreState();
}

class _InventoryCheckStoreState extends State<InventoryCheckStore> {
  // Property
  late DatabaseHandler handler; // db handler
  late List<String> storeList; // 매장목록
  late String selectedValue; // 선택매장명

  late String searchQuery; // 검색 쿼리
  late String selectedFilter; // = '상호'; // 기본 필터 설정

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
    storeList = [
      StoreCodeEnum.dobong.storeCodeEnumText,
      StoreCodeEnum.dongdaemun.storeCodeEnumText,
      StoreCodeEnum.dongjak.storeCodeEnumText,
      StoreCodeEnum.eunpyeong.storeCodeEnumText,
      StoreCodeEnum.gangbuk.storeCodeEnumText,
      StoreCodeEnum.gangdong.storeCodeEnumText,
      StoreCodeEnum.gangnam.storeCodeEnumText,
      StoreCodeEnum.gangseo.storeCodeEnumText,
      StoreCodeEnum.geumcheon.storeCodeEnumText,
      StoreCodeEnum.guro.storeCodeEnumText,
      StoreCodeEnum.gwanak.storeCodeEnumText,
      StoreCodeEnum.gwangjin.storeCodeEnumText,
      StoreCodeEnum.jongno.storeCodeEnumText,
      StoreCodeEnum.junggu.storeCodeEnumText,
      StoreCodeEnum.jungnang.storeCodeEnumText,
      StoreCodeEnum.mapo.storeCodeEnumText,
      StoreCodeEnum.nowon.storeCodeEnumText,
      StoreCodeEnum.seocho.storeCodeEnumText,
      StoreCodeEnum.seodaemun.storeCodeEnumText,
      StoreCodeEnum.seongbuk.storeCodeEnumText,
      StoreCodeEnum.seongdong.storeCodeEnumText,
      StoreCodeEnum.songpa.storeCodeEnumText,
      StoreCodeEnum.yangcheon.storeCodeEnumText,
      StoreCodeEnum.yeongdeungpo.storeCodeEnumText,
      StoreCodeEnum.yongsan.storeCodeEnumText,
    ];
    selectedFilter = (storeList.isNotEmpty ? storeList[0] : null)!;
    selectedValue = selectedFilter; // 선택 매장명 초기화
    searchQuery = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('대리점 재고파악'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.primaryContainer,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    '선택 점포  :  ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  DropdownButton<String>(
                    value: storeList.isNotEmpty ? selectedFilter : null,
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        selectedFilter = newValue; // 선택된 필터 업데이트
                        setState(() {});
                      }
                    },
                    dropdownColor: Colors.deepPurple[500],
                    onTap: () {
                      //
                    },
                    items:
                        storeList.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: FutureBuilder(
        future: handler.queryStore(selectedValue),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return Card(
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
                  child: Row(
                    children: [
                      Text('data'),
                      Text('data'),
                      Text('data'),
                      Text('data'),
                    ],
                  ),
                );
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
