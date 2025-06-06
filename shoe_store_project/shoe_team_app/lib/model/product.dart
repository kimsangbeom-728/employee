import 'dart:typed_data';

class Product {
  final String storeCode; // 점포코드
  final String
  productCode; // 제조사(2), 카테고리(2), 년월(4), SEQNO(2) - 자리 수(1101000101)
  final String detailCode; // 컬러(2),size(3) - 자리 수
  final String productName;
  final int quantity;
  final int? maxquantity; // 최대
  final String color; // black(20), white(21), red(22), grey(23), blue(24)
  final int cost; // 원가
  final int marginRate;
  final int price; // 판매가
  final int size; // 220 - 300 (10 단위)
  final Uint8List? image; // 이미지는 알아서 찾으세요 ^^
  final String description;
  final String category; // 운동화 01, 구두 02, 슬리퍼 03, 단화 04
  final String productionYear;
  final String companyName;
  final String
  companyCode; // nike 11(운동화 1개,슬리퍼 1개), newbalance(운동화 2개) 12, adidas(운동화 1개,슬리퍼 1개) 13, prospecs(운동화 2개) 14, puma(운동화 2개) 15, dr.martin(구두 1종류) 16, 엘칸토(구두 1종류) 17, 반스(단화 2종류) 18, 컨버스(단화 2종류) 19

  Product({
    required this.storeCode,
    required this.productCode,
    required this.detailCode,
    required this.productName,
    required this.quantity,
    required this.maxquantity,
    required this.color,
    required this.cost,
    required this.marginRate,
    required this.price,
    required this.size,
    this.image,
    required this.description,
    required this.category,
    required this.productionYear,
    required this.companyName,
    required this.companyCode,
  });

  Product.fromMap(Map<String, dynamic> res)
    : storeCode = res['storeCode'],
      productCode = res['productCode'],
      detailCode = res['detailCode'],
      productName = res['productName'],
      quantity = res['quantity'],
      maxquantity = res['maxquantity'],
      color = res['color'],
      cost = res['cost'],
      marginRate = res['marginRate'],
      price = res['price'],
      size = res['size'],
      image = res['image'],
      description = res['description'],
      category = res['category'],
      productionYear = res['productionYear'],
      companyName = res['companyName'],
      companyCode = res['companyCode'];
}
