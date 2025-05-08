import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmployeePage extends StatefulWidget {
  const EmployeePage({super.key});

  @override
  State<EmployeePage> createState() => _EmployeePageState();
}

class _EmployeePageState extends State<EmployeePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 207, 233, 255),
      ),
      backgroundColor: const Color.fromARGB(255, 207, 233, 255),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20,0,0,0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('사원 No. __________   강남지점',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
                ),
              ),
            ),
            SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                padding: EdgeInsets.all(16), // 내부 여백
                alignment: Alignment.centerLeft, // 왼쪽 정렬
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20)
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextButton(
                  onPressed: () {
                  }, 
                  child: Text('고객 주문확인 ▶️',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                  ),
                  )
                ),
                SizedBox(height: 15),
                TextButton(
                  onPressed: () {
                    //
                  }, 
                  child: Text('전체 매출확인 ▶️',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                  ),)
                ),
                SizedBox(height: 15),
                TextButton(
                  onPressed: () {
                    //
                  }, 
                  child: Text('지점 매출확인 ▶️',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                  ),
                  )
                ),
                SizedBox(height: 15),
                TextButton(
                  onPressed: () {
                    //
                  }, 
                  child: Text('재고확인 ▶️',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                  ),
                  )
                ),
                SizedBox(height: 15),
                TextButton(
                  onPressed: () {
                    //
                  }, 
                  child: Text('수발주 품위서 ▶️',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                  ),
                  )
                ),
                SizedBox(height: 15),
                TextButton(
                  onPressed: () {
                    //
                  }, 
                  child: Text('반품 품위서 ▶️',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                  ),
                  )
                ),
                SizedBox(height: 15),
                TextButton(
                  onPressed: () {
                    //
                  }, 
                  child: Text('결재 ▶️',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                  ),
                  )
                ),
                  ],
                ),
              ),
            )
            
          ],
        ),
      ),
    );
  }
}