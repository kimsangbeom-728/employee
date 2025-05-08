import 'package:shoe_team_project/model/contract.dart';
import 'package:shoe_team_project/model/employee.dart';
import 'package:shoe_team_project/model/employee_move.dart';
import 'package:shoe_team_project/model/product_image.dart';
import 'package:shoe_team_project/model/product.dart';
import 'package:shoe_team_project/model/register.dart';
import 'package:shoe_team_project/model/store.dart';
import 'package:shoe_team_project/model/traninfo_tranitem.dart';
import 'package:shoe_team_project/model/transaction.dart';
import 'package:shoe_team_project/model/transaction_item.dart';
import 'package:shoe_team_project/model/user.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHandler {
  Database? _database;

  Future<Database> initializeDB() async {
    if (_database != null) return _database!;

    String path = await getDatabasesPath();
    String dbFilePath = join(path, "shoestore.db");
    print("db 경로: $dbFilePath");
    _database = await openDatabase(
      join(path, 'shoestore.db'),
      onCreate: (db, version) async {
        await db.execute('''
        create table user(
          id text primary key,
          pw text,
          phone text,
          adminDate date,
          address text,
          name text
        )
        ''');
        await db.execute('''
        create table store(
          storeCode text primary key,
          storeName text,
          longitude real,
          latitude real
        )
        ''');
        await db.execute('''
        create table employee(
          employeeNo text primary key,
          pw text,
          name text,
          employeeDate date,
          position int,
          authority int,
          storeCode text
        )
        ''');
        await db.execute(
          // 수량과 카테고리는 숫자지만 text로 받는다
          '''
        create table product(
          storeCode text,
          productCode text,
          detailCode text,
          productName text,
          quantity integer,
          maxQuantity integer,
          color text,
          cost integer,
          marginRate integer,
          price integer,
          size integer,
          image blob,
          description text,
          category text,
          productionYear text,
          companyName text,
          companyCode text,
          PRIMARY KEY(storeCode, productCode, detailCode)
        )
        ''',
        );
        await db.execute('''
        create table tranInfo (
            transactionNo text,
            transactionDate date,
            userId text,
            storeCode text,
            transactionState integer,
            transactionPrice integer,
            originDate date,
            originNo text,
            returnReason text,
            review text,
            tranname text,
            sumQuantity integer,
            primary key (transactionNo, transactionDate, userId, storeCode)
        )
        ''');
        await db.execute(
          // orderState 0은 발주, 1은 수주, 2는 본사에서 대리점 이동
          '''
        create table contract(
          documentNo text,
          writeDate date,
          productCode text,
          startEmployeeNo text,
          writeEmployeeName text,
          middleEmployeeNo text,
          endEmployeeNo text,
          documentTitle text,
          documentDetail text,
          approvalState integer,
          orderingPrice integer,
          stockDate date,
          moveDate date,
          quantity integer,
          orderState integer,
          storeCode text,
          primary key (documentNo, writeDate, startEmployeeNo, productCode)
        )
        ''',
        );
        await db.execute('''
        create table imageregister(
          productCode text,
          imageId text,
          primary key (productCode, imageId)
        )
        ''');
        await db.execute('''
        create table productimage(
          imageId text primary key,
          image blob
        )
        ''');
        await db.execute('''
        create table employeemove(
          employeeNo text,
          storeCode text,
          workDate date,
          primary key (employeeNo, storeCode)
        )
        ''');
        await db.execute('''
        create table transactionitem(
          itemNo integer,
          transactionDate date,
          transactionNo text,
          storeCodeitem text,
          buyProductCode text,
          buyDetailCode text,
          buyProductName text,
          buyProductPrice integer,
          buyProductQuantity integer,
          salePrice integer,
          PRIMARY KEY(itemNo, transactionNo, transactionDate)
        )
        ''');
        await db.execute('''
        create table basket(
          basketSeq integer primary key autoincrement,
          storeCode text,
          buyProductCode text,
          buyProductName text,
          buyProductPrice text,
          buyProductQuantity integer,
          salePrice integer,
          unique (storeCode)
        )
        ''');
      },
      version: 1,
    );
    return _database!;
  }

  /////////////////////////////////////////////////////////////
  /// 데이터베이스 닫기
  Future<void> closeDatabase() async {
    if (_database != null) {
      await _database!.close();
      _database = null; // 데이터베이스 객체를 null로 설정하여 재사용할 수 없도록 합니다.
      print("Database closed.");
    }
  }

  // 기본 쿼리(양식 보시고 바꿔서 쓰셔유)
  Future<List<User>> queryUser(String id) async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.rawQuery(
      'select * from user where id = ?',
    );
    return queryResult.map((e) => User.fromMap(e)).toList();
  }

  Future<List<Product>> queryProduct() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.rawQuery(
      'select * from product',
    );
    return queryResult.map((e) => Product.fromMap(e)).toList();
  }

  /////////////////////////////////////////////////////////////
  /// 직원 : 직원정보 조회
  Future<List<Employee>> queryEmployee(String employeeNo) async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.rawQuery(
      'select * from employee where employeeNo = ?',
      [employeeNo],
    );
    return queryResult.map((e) => Employee.fromMap(e)).toList();
  }

  /////////////////////////////////////////////////////////////
  /// 직원 : 권한 조회
  Future<List<Employee>> queryEmployeeAuthority(int authority) async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.rawQuery(
      'select * from employee where authority = ?',
      [authority],
    );
    return queryResult.map((e) => Employee.fromMap(e)).toList();
  }

  Future<List<ProductImage>> queryProductImage(String imageId) async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.rawQuery(
      'select * from productimage where imageId = ?',
    );
    return queryResult.map((e) => ProductImage.fromMap(e)).toList();
  }

  Future<List<Store>> queryStore(String storeCode) async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.rawQuery(
      'select * from store where storeCode = ?',
    );
    return queryResult.map((e) => Store.fromMap(e)).toList();
  }

  Future<List<Tran>> queryTransactionAll() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.rawQuery(
      'select * from tranInfo',
    );
    return queryResult.map((e) => Tran.fromMap(e)).toList();
  }

  Future<List<TraninfoTranItem>> queryTranAndTranItem() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.rawQuery(
      'select * from tranInfo t, transactionitem ti where t.transactionNo = ti.transactionNo and t.transactionDate = ti.transactionDate',
    );
    return queryResult.map((e) => TraninfoTranItem.fromMap(e)).toList();
  }

  Future<List<TransactionItem>> queryTransactionItemAll(
    String transactionDate,
    String transactionNo,
  ) async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.rawQuery(''' 
          select * 
          from transactionitem, transaction, store
          where transaction.transactionDate = transactionitem.transactionDate
          and transaction.transactionNo = transactionitem.transactionNo
          and store.storeCode = transactionitem.storeCode
          and transactionitem.transactionDate = ?
          and transactionitem.transactionNo = ?
      ''');
    return queryResult.map((e) => TransactionItem.fromMap(e)).toList();
  }

  Future<List<TransactionItem>> queryBasketAll() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.rawQuery(''' 
          select * 
          from basket, user, product
          where basket.productCode = product.productCode
          order by basket.basketSeq
      ''');
    return queryResult.map((e) => TransactionItem.fromMap(e)).toList();
  }

  /////////////////////////////////////////////////////////////
  /// 전자결제 : 기안작성자 전체 조회
  Future<List<Contract>> queryContractDocumentAll(String employee) async {
    // 결재 기준
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.rawQuery(
      'select * '
      '  from contract, employee '
      ' where employee.employeeNo = contract.startEmployeeNo '
      '   and contract.startEmployeeNo = ? '
      ' order by documentNo',
      [employee],
    );
    return queryResult.map((e) => Contract.fromMap(e)).toList();
  }

  /////////////////////////////////////////////////////////////
  /// 전자결제 : 전자결제 대상 전체 조회
  Future<List<Contract>> queryContractConfirmAll(
    String employee,
    int authority,
  ) async {
    // 결재 기준
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult;
    authority == 1
        ? queryResult = await db.rawQuery(
          'select * '
          '  from contract, employee '
          ' where employee.employeeNo = contract.middleEmployeeNo '
          '   and contract.middleEmployeeNo = ? '
          '   and employee.authority = ?'
          ' order by documentNo',
          [employee, authority],
        )
        : queryResult = await db.rawQuery(
          'select * '
          '  from contract, employee '
          ' where employee.employeeNo = contract.endEmployeeNo '
          '   and contract.endEmployeeNo = ? '
          '   and employee.authority = ?'
          ' order by documentNo',
          [employee, authority],
        );

    return queryResult.map((e) => Contract.fromMap(e)).toList();
  }

  /////////////////////////////////////////////////////////////
  /// 전자결제 : 일자별 조회
  Future<List<Contract>> queryContractDocumentDate(
    String employee,
    String date,
  ) async {
    // 결재 기준
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.rawQuery(
      'select * '
      '  from contract, employee '
      ' where employee.employeeNo = contract.startEmployeeNo '
      '   and contract.startEmployeeNo = ? '
      '   and contract.writeDate = ? ',
      [employee, date],
    );
    return queryResult.map((e) => Contract.fromMap(e)).toList();
  }

  /////////////////////////////////////////////////////////////
  /// 전자결제 : 문서번호 조회
  Future<List<Contract>> queryContractDocumentNo(
    String employee,
    String date,
    String docNo,
  ) async {
    // 결재 기준
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.rawQuery(
      'select * '
      '  from contract, employee '
      ' where employee.employeeNo = contract.startEmployeeNo '
      '   and contract.startEmployeeNo = ? '
      '   and contract.writeDate = ? '
      '   and contract.documentNo = ? ',
      [employee, date, docNo],
    );
    return queryResult.map((e) => Contract.fromMap(e)).toList();
  }

  /////////////////////////////////////////////////////////////
  /// 전자결제 : 문서번호 1차/2차 승인자 결제대상 조회
  Future<List<Contract>> queryContractConfirm(
    String docNo, // 결제문서
    String date, // 작성일자
    String writeEmployee, // 작성자 사번
    String productCode, // 제폼코드
  ) async {
    // 결재 기준
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.rawQuery(
      'select * '
      '  from contract, employee '
      ' where employee.employeeNo = contract.startEmployeeNo '
      '   and contract.documentNo = ? '
      '   and contract.writeDate = ? '
      '   and contract.productCode = ? '
      '   and contract.startEmployeeNo = ? ',
      [docNo, date, productCode, writeEmployee],
    );
    return queryResult.map((e) => Contract.fromMap(e)).toList();
  }

  /////////////////////////////////////////////////////////////
  /// 전자결제 : 조회
  Future<List<Contract>> queryContractDocument(
    String employee,
    String documentNo,
  ) async {
    // 결재 기준
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.rawQuery(
      'select * '
      '  from contract, product, employee '
      ' where product.productCode = contract.productCode '
      '   and employee.employeeNo = contract.employeeNo '
      '   and contract.employeeNo = ? '
      '   and contract.documentNo = ? ',
      [employee, documentNo],
    );
    return queryResult.map((e) => Contract.fromMap(e)).toList();
  }

  /////////////////////////////////////////////////////////////
  // 전자결제 : 추가
  Future<int> insertContract(Contract contract) async {
    int result = 0;

    final Database db = await initializeDB();
    result = await db.rawInsert(
      ' insert into contract ( '
      '        documentNo, writeDate, productCode, startEmployeeNo, writeEmployeeName, '
      '        middleEmployeeNo, endEmployeeNo, documentTitle, documentDetail,'
      '        approvalState, orderingPrice, stockDate, moveDate, quantity, orderState, storeCode) '
      'values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)',
      [
        contract.documentNo,
        contract.writeDate,
        contract.productCode,
        contract.startEmployeeNo,
        contract.writeEmployeeName,
        contract.middleEmployeeNo,
        contract.endEmployeeNo,
        contract.documentTitle,
        contract.documentDetail,
        contract.approvalState,
        contract.orderingPrice,
        contract.stockDate,
        contract.moveDate,
        contract.quantity,
        contract.orderState,
        contract.storeCode,
      ],
    );
    return result;
  }

  /////////////////////////////////////////////////////////////
  // 전자결제 : Update
  Future<int> updateContract(Contract contract) async {
    int result = 0;
    final Database db = await initializeDB();
    result = await db.rawUpdate(
      'update contract set middleEmployeeNo = ?, endEmployeeNo = ?, documentTitle = ?, '
      '       documentDetail = ?, approvalState = ?, orderingPrice = ?, stockDate = ?, '
      '       moveDate = ?, quantity = ?, orderState = ?, storeCode = ? '
      ' where documentNo = ? '
      '   and writeDate = ? '
      '   and productCode = ? '
      '   and startEmployeeNo = ?',
      [
        contract.middleEmployeeNo,
        contract.endEmployeeNo,
        contract.documentTitle,
        contract.documentDetail,
        contract.approvalState,
        contract.orderingPrice,
        contract.stockDate,
        contract.moveDate,
        contract.quantity,
        contract.orderState,
        contract.storeCode,
        contract.documentNo,
        contract.writeDate,
        contract.productCode,
        contract.startEmployeeNo,
      ],
    );
    return result;
  }

  /////////////////////////////////////////////////////////////
  // 전자결제 : 1차/2차 승인 Update
  Future<int> updateContractConfirm(
    String documentNo,
    String writeDate,
    String productCode,
    String startEmployeeNo,
    int confirmValue,
  ) async {
    int result = 0;
    final Database db = await initializeDB();
    result = await db.rawUpdate(
      'update contract set approvalState = ? '
      ' where documentNo = ? '
      '   and writeDate = ? '
      '   and productCode = ? '
      '   and startEmployeeNo = ? ',
      [confirmValue, documentNo, writeDate, productCode, startEmployeeNo],
    );
    return result;
  }

  /////////////////////////////////////////////////////////////
  // 전자결제 : 삭제
  Future<void> deleteContractDocument(String docNo) async {
    final Database db = await initializeDB();
    await db.rawDelete('delete from contract where documentNo = ?', [docNo]);
  }

  Future<List<Contract>> queryContractOrder(String orderState) async {
    // 수, 발주 기준
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.rawQuery(''' 
          select * 
          from contract,product,employee
          where product.productCode = contract.productCode
          and employee.employeeNo = contract.employeeNo
          and contract.orderState = ?
      ''');
    return queryResult.map((e) => Contract.fromMap(e)).toList();
  }

  Future<List<ImageRegister>> queryImageRegister(String imageId) async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.rawQuery(''' 
          select * 
          from imageregister,product,productimage
          where product.productCode = imageregister.productCode
          and productimage.imageId = imageregister.imageId
          and imageregister.imageId = ?
      ''');
    return queryResult.map((e) => ImageRegister.fromMap(e)).toList();
  }



////////////////////////////////
///로그인 관련 쿼리

    Future<List<EmployeeMove>> queryEmplyeeMove(String workDate) async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.rawQuery(''' 
          select * 
          from employeemove, store, employee
          where employee.employeeNo = employeemove.employeeNo
          and store.storeCode = employee.storeCode
          and employmove.workDate = ?
      ''');
    return queryResult.map((e) => EmployeeMove.fromMap(e)).toList();
  }

  Future<List<Employee>> queryEmployeeLogin(String employeeNo) async {
      final Database db = await initializeDB();
      print(await db.rawQuery('SELECT name FROM sqlite_master WHERE type = "table"'));
      final List<Map<String, Object?>> queryResult = await db.rawQuery(
        'select * from employee where employeeNo = ?',
        [employeeNo]
      );
      return queryResult.map((e) => Employee.fromMap(e)).toList();
      
    }

  Future<List<Employee>> queryEmployeeSearch(String keyword) async {
      final Database db = await initializeDB();
      print(await db.rawQuery('SELECT name FROM sqlite_master WHERE type = "table"'));
      final List<Map<String, Object?>> queryResult = await db.rawQuery(
        "select * from employee where employeeNo like '%$keyword%'",
      );
      return queryResult.map((e) => Employee.fromMap(e)).toList();
  
    }


 //////////////////////////////////////////
 ///로그인 관련 쿼리들

  Future<void> insertInitialStores() async {
  final Database db = await initializeDB();

  final List<Map<String, dynamic>> stores = [
    {'storeCode': 1168001, 'storeName': '강남구', 'latitude': 37.501, 'longitude': 127.001},
    {'storeCode': 1168101, 'storeName': '강동구', 'latitude': 37.502, 'longitude': 127.002},
    {'storeCode': 1168201, 'storeName': '강서구', 'latitude': 37.503, 'longitude': 127.003},
    {'storeCode': 1168301, 'storeName': '관악구', 'latitude': 37.504, 'longitude': 127.004},
    {'storeCode': 1168401, 'storeName': '광진구', 'latitude': 37.505, 'longitude': 127.005},
    {'storeCode': 1168501, 'storeName': '구로구', 'latitude': 37.506, 'longitude': 127.006},
    {'storeCode': 1168601, 'storeName': '금천구', 'latitude': 37.507, 'longitude': 127.007},
    {'storeCode': 1168701, 'storeName': '노원구', 'latitude': 37.508, 'longitude': 127.008},
    {'storeCode': 1168801, 'storeName': '도봉구', 'latitude': 37.509, 'longitude': 127.009},
    {'storeCode': 1168901, 'storeName': '동대문구', 'latitude': 37.510, 'longitude': 127.010},
    {'storeCode': 1169001, 'storeName': '동작구', 'latitude': 37.511, 'longitude': 127.011},
    {'storeCode': 1169101, 'storeName': '마포구', 'latitude': 37.512, 'longitude': 127.012},
    {'storeCode': 1169201, 'storeName': '서대문구', 'latitude': 37.513, 'longitude': 127.013},
    {'storeCode': 1169301, 'storeName': '서초구', 'latitude': 37.514, 'longitude': 127.014},
    {'storeCode': 1169401, 'storeName': '성동구', 'latitude': 37.515, 'longitude': 127.015},
    {'storeCode': 1169501, 'storeName': '성북구', 'latitude': 37.516, 'longitude': 127.016},
    {'storeCode': 1169601, 'storeName': '송파구', 'latitude': 37.517, 'longitude': 127.017},
    {'storeCode': 1169701, 'storeName': '양천구', 'latitude': 37.518, 'longitude': 127.018},
    {'storeCode': 1169801, 'storeName': '영등포구', 'latitude': 37.519, 'longitude': 127.019},
    {'storeCode': 1169901, 'storeName': '용산구', 'latitude': 37.520, 'longitude': 127.020},
    {'storeCode': 1170001, 'storeName': '은평구', 'latitude': 37.521, 'longitude': 127.021},
    {'storeCode': 1170101, 'storeName': '종로구', 'latitude': 37.522, 'longitude': 127.022},
    {'storeCode': 1170201, 'storeName': '중구', 'latitude': 37.523, 'longitude': 127.023},
    {'storeCode': 1170301, 'storeName': '중랑구', 'latitude': 37.524, 'longitude': 127.024},
    {'storeCode': 1170401, 'storeName': '강북구', 'latitude': 37.525, 'longitude': 127.025},
    {'storeCode': 1000001, 'storeName': '본사', 'latitude': 37.526, 'longitude': 127.026},
  ];

  for (var store in stores) {
    await db.insert(
      'store',
      store,
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }
  print(stores);
}

Future<String?> queryStoreCodeChoice(String storeName) async {
  final Database db = await initializeDB();
  try {
    final List<Map<String, Object?>> result = await db.rawQuery(
      'SELECT storeCode FROM store WHERE storeName = ?',
      [storeName],
    );

    if (result.isNotEmpty) {
      final code = result.first['storeCode'];
      return code?.toString(); // int든 String이든 안전하게 문자열로 반환
    } else {
      return null; // 매장명 일치 없음
    }
  } catch (e) {
    print("🚨 오류 발생: $e");
    return null;
  }
}

Future<int> insertEmployee(Employee employee)async{
    int result = 0;
    final Database db = await initializeDB();
    result = await db.rawInsert(
      'insert into employee(employeeNo, pw, name, employeeDate, position, authority, storeCode) values (?, ?, ?, ?, ?, ?, ?)',
      [employee.employeeNo, employee.pw, employee.name, employee.employeeDate, employee.position, employee.authority, employee.storeCode]
    );
    return result;
  }

  Future<void> deleteEmployee(String employeeNo) async{
    final Database db = await initializeDB();
    await db.rawDelete('delete from employee where employeeNo = ?',
          [employeeNo]
    );
  }

  Future<int> updateEmployee(Employee employee)async{
    int result = 0;
    final Database db = await initializeDB();
    result = await db.rawUpdate(
      'update employee set employeeNo = ?, pw = ?, name = ?, employeeDate = ?, position = ?, authority = ?, storeCode =?',
      [employee.employeeNo, employee.pw, employee.name, employee.employeeDate, employee.position, employee.authority, employee.storeCode]
    );
    return result;
  }

}
