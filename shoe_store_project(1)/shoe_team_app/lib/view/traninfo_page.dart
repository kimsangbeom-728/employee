import 'package:flutter/material.dart';
import 'package:shoe_team_project/model/enum.dart';
import 'package:shoe_team_project/view_model/database_handler.dart';

class TraninfoPage extends StatefulWidget {
  const TraninfoPage({super.key});

  @override
  State<TraninfoPage> createState() => _TraninfoPageState();
}
 // 여기의 권한은 본사 직원이 들어가야 됨
class _TraninfoPageState extends State<TraninfoPage> {
    // Property
  late DatabaseHandler handler; // db handler
  late List<String> storeList; // 매장목록
  late List<String> months; // 월별 목록
  late String selectedValue; // 선택 매장명
  late String selectedMonthsValue; // 선택 월

  late String searchQuery; // 검색 쿼리
  late String searchMonth; // 월별 검색 쿼리
  late String selectedFilter; // = '상호';
  late String selectedMonthFilter; // = '월별';
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
    months = ['01월', '02월', '03월', '04월', '05월', '06월', '07월', '08월', '09월', '10월', '11월', '12월'];
    selectedFilter = (storeList.isNotEmpty ? storeList[0]: null)!;
    selectedValue = selectedFilter; // 선택 매장명 초기화
    selectedMonthFilter = (months.isNotEmpty ? months[0] : null)!;
    selectedMonthsValue = selectedMonthFilter; // 선택 월 초기화
    searchQuery = '';
    searchMonth = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('전체 지점 매출 파악'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.primaryContainer,
        bottom: PreferredSize(preferredSize: Size.fromHeight(60),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  '선택 점포  :   ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                DropdownButton<String>(
                  value: storeList.isNotEmpty ? selectedFilter : null,
                  onChanged: (value){
                    if(value != null){
                      selectedFilter = value;
                      setState(() {});
                    }
                  },
                  dropdownColor: Colors.deepPurple[500],
                  onTap: () {
                    //
                  },
                  items:storeList.map<DropdownMenuItem<String>>((String value) {
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
                Text(
                  '선택 월  :   ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                DropdownButton<String>(
                  value: months.isNotEmpty ? selectedMonthFilter : null,
                  onChanged: (value){
                    if(value != null){
                      selectedMonthFilter = value; // 선택한 월별 필터 업데이트
                      setState(() {});
                    }
                  },
                  dropdownColor: Colors.deepPurple[500],
                  onTap: () {
                    //
                  },
                  items:months.map<DropdownMenuItem<String>>((String value) {
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
            )
          ],
        )),
      ),
      body: FutureBuilder(
        future: handler.queryTransactionAll(), 
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (context, index) {
                return Card(
                  child: Column(
                    children: [
                      Text("거래번호 : ${snapshot.data![index].transactionNo}"),
                      Text("거래일자 : ${snapshot.data![index].transactionDate}"),
                      Text("고객 ID : ${snapshot.data![index].userId}"),
                      Text("점포 코드 : ${snapshot.data![index].storeCode}"),
                      Text("거래 상태 : ${snapshot.data![index].transactionState.toString()}"),
                      Text("거래 제품 명 : ${snapshot.data![index].tranName}"),
                      Text('${snapshot.data![index].transactionPrice.toString()}원'),
                    ],
                  ),
                );
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        }
      ),
    );
  }//build

  //--function--
  querySearch(){

  }


}//class