import 'package:get/get.dart';

//////////////////////////////////////
/// 전자결제 상태 Enum
enum EDApprovalStateEnum {
  writing, // 기안서작성중중
  approval, // 전자결제승인요청
  confirmed, // 1차 승인완료
  completed, // 2차 승인완결
  declined; // 승인거부

  String get eDApprovalStateText {
    switch (this) {
      case EDApprovalStateEnum.writing:
        return '기안서 작성중';
      case EDApprovalStateEnum.approval:
        return '전자결제 승인요청';
      case EDApprovalStateEnum.confirmed:
        return '전자결제 1차 승인완료';
      case EDApprovalStateEnum.completed:
        return '전자결제 2차 승인완결';
      case EDApprovalStateEnum.declined:
        return '전자결제 반려';
    }
  }
}

//////////////////////////////////////
/// 전자결제 상태 Enum
enum SelectApprovalStateEnum {
  all, // 전체보기
  waiting, // 결제대기
  confirmed, // 1차 승인완료 보기
  completed, // 2차 승인완결 보기
  declined, // 승인거부 보기
}

//////////////////////////////////////
/// 직책 (0:사원, 1:대리, 2:과장, 3:부장, 4:이사, 5:상무, 6:대표이사)
enum EmpPositionEnum {
  staff, // 사원
  associate, // 대리
  manager, // 과장
  depart, // 부장
  director, // 이사
  senior, // 상무
  ceo, // 대표이사
}

//////////////////////////////////////
/// 전자결제 권한
enum AuthorityEnum {
  normal, // 기안서 작성
  authorLevel01, // 1차 승인 권한
  authorLevel02, // 2차 승인 권한
}

//////////////////////////////////////
/// 전자결제 UI Main Parameta
/// [0]:사번, [1]:성명, [2]:근무처, [3]:결제권한(authority)
enum ContractMainParamEnum {
  employeeNo,
  employeeName,
  storeCode,
  // orderItemCode,
  // orderItemQty,
  authority,
}

//////////////////////////////////////
/// 전자결제 UI Write Parameta
/// [0]:사번, [1]:성명, [2]:근무처코드, [3]:발주상품코드, [4]:발주수량, //[5]:기안작성자
enum ContractWriteParamEnum {
  employeeNo,
  employeeName,
  storeCode,
  orderItemCode,
  orderItemQty,
  // writeName,
}

//////////////////////////////////////
/// 전자결제 UI Modify Parameta
/// [0]:사번, [1]:성명, [2]:근무처코드, [3]:작성일, [4]:문서번호, [5]:기안작성자
enum ContractModifyParamEnum {
  employeeNo,
  employeeName,
  storeCode,
  writeDate,
  documentNo,
  writeName,
}

//////////////////////////////////////
/// 전자결제 UI Confirm Parameta
/// [0]:사번, [1]:성명, [2]:근무처코드, [3]:작성일, [4]:작성자사번 [5]:문서번호, [6]:제품코드
enum ContractConfirmParamEnum {
  employeeNo,
  employeeName,
  storeCode,
  writeDate,
  writeEmpNo,
  documentNo,
  orderItemCode,
}

//////////////////////////////////////
/// 전자결제 싸인 이미지
enum ESignImageEnum { noSign, sign_0, sign_2, sign_3, sign_6 }

//////////////////////////////////////
/// 서울 지자치구 25곳, 본사
enum StoreCodeEnum {
  headOffice, // 본사사
  gangnam, // 강남구
  gangdong, // 강동구
  gangseo, // 강서구
  gwanak, // 관약구
  gwangjin, // 광진구
  guro, // 구로구
  geumcheon, // 금천구
  nowon, // 노원구
  dobong, // 도봉구
  dongdaemun, // 동대문구
  dongjak, // 동작구
  mapo, // 마포구
  seodaemun, // 서대문구
  seocho, // 서초구
  seongdong, // 성동구
  seongbuk, // 성북구
  songpa, // 송파구
  yangcheon, // 양천구
  yeongdeungpo, // 영등포구
  yongsan, // 용산구
  eunpyeong, // 은평구
  jongno, // 종로구
  junggu, // 중구
  jungnang, // 중랑구
  gangbuk; // 강북구

  String get storeCodeEnumText {
    switch (this) {
      case StoreCodeEnum.headOffice:
        return '본  사(10000)';
      case StoreCodeEnum.gangnam:
        return '강남구(11680)';
      case StoreCodeEnum.gangdong:
        return '강동구(11681)';
      case StoreCodeEnum.gangseo:
        return '강서구(11682)';
      case StoreCodeEnum.gwanak:
        return '관약구(11683)';
      case StoreCodeEnum.gwangjin:
        return '광진구(11684)';
      case StoreCodeEnum.guro:
        return '구로구(11685)';
      case StoreCodeEnum.geumcheon:
        return '금천구(11686)';
      case StoreCodeEnum.nowon:
        return '노원구(11687)';
      case StoreCodeEnum.dobong:
        return '도봉구(11688)';
      case StoreCodeEnum.dongdaemun:
        return '동대문구(11689)';
      case StoreCodeEnum.dongjak:
        return '동작구(11690)';
      case StoreCodeEnum.mapo:
        return '마포구(11691)';
      case StoreCodeEnum.seodaemun:
        return '서대문구(11692)';
      case StoreCodeEnum.seocho:
        return '서초구(11693)';
      case StoreCodeEnum.seongdong:
        return '성동구(11694)';
      case StoreCodeEnum.seongbuk:
        return '성북구(11695)';
      case StoreCodeEnum.songpa:
        return '송파구(11696)';
      case StoreCodeEnum.yangcheon:
        return '양천구(11697)';
      case StoreCodeEnum.yeongdeungpo:
        return '영등포구(11698)';
      case StoreCodeEnum.yongsan:
        return '용산구(11699)';
      case StoreCodeEnum.eunpyeong:
        return '은평구(11700)';
      case StoreCodeEnum.jongno:
        return '종로구(11701)';
      case StoreCodeEnum.junggu:
        return '중구(11702)';
      case StoreCodeEnum.jungnang:
        return '중랑구(11703)';
      case StoreCodeEnum.gangbuk:
        return '강북구(11704)';
    }
  }
}
