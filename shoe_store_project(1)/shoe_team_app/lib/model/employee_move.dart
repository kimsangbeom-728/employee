class EmployeeMove {
  final String employeeNo;
  final String storeCode;
  final String workDate;

  EmployeeMove({
    required this.employeeNo,
    required this.storeCode,
    required this.workDate
  });

  EmployeeMove.fromMap(Map<String,dynamic> res)
  :employeeNo = res['employeeNo'],
  storeCode = res['storeCode'],
  workDate = res['workDate'];

}