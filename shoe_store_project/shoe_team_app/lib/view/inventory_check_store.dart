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
  late String selectedName; // 선택매장명
  late String selectedStoreCode; // 선택매장코드
  late String searchQuery; // 검색 쿼리
  late String selectedFilter; // = '상호'; // 기본 필터 설정

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
    storeList = [
      StoreCodeEnum.headOffice.storeCodeEnumText,
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
    selectedName = selectedFilter; // 선택 매장명 초기화
    searchQuery = '';
    selectedStoreCode = '';
    setInitData(selectedFilter);
  }

  setInitData(String storeInfo) {
    var store = storeInfo.split('(');
    if (store.length == 2) {
      selectedName = store[0];
      selectedStoreCode = store[1].replaceAll(')', '');
    } else {
      selectedStoreCode = store[0];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('대리점 재고조회'),
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
                        setInitData(selectedFilter);
                        setState(() {});
                      }
                    },
                    dropdownColor: Colors.deepPurple[500],
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
        future: handler.queryProductStore(selectedStoreCode),
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
/*
final String storeCode; // 점포코드
  final String productCode; // 제조사(2), 카테고리(2), 년월(4), SEQNO(2) - 자리 수(1101000101)
  final String detailCode; // 컬러(2),size(3) - 자리 수
  final String productName;
  final int quantity;
  final int maxquantity; // 최대
  final String color; // black(20), white(21), red(22), grey(23), blue(24)
  final String rating;
  final int marginRate;
  final int price;
  final int size; // 220 - 300 (10 단위)
  final Uint8List image; // 이미지는 알아서 찾으세요 ^^
  final String description;
  final String category; // 운동화 01, 구두 02, 슬리퍼 03, 단화 04
  final String productionYear;
  final String companyName;
  final String*/                    
                    children: [
                      Text('상품코드 : ${snapshot.data![index].productCode}'),
                      Text('상 품 명 : ${snapshot.data![index].productName}'),
                      Text('부가코드 : ${snapshot.data![index].detailCode}'),
                      Text('상품구분 : ${snapshot.data![index].category}'),
                      Text('Color : '),
                      Text('Size : '),
                      Text('단   가 : '),
                      Text('마  진 : '),
                      Text('적정재고 : '),
                      Text('현재재고 : '),
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
