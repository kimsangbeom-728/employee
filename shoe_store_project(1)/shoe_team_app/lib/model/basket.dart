class Basket {
  final int basketSeq;
  final String storeCode;
  final String buyProductCode;
  final String buyProductName;
  final int buyProductPrice;
  final int buyProductQuantity;
  final int salePrice;


  Basket({
    required this.basketSeq,
    required this.storeCode,
    required this.buyProductCode,
    required this.buyProductName,
    required this.buyProductPrice,
    required this.buyProductQuantity,
    required this.salePrice
  });

  Basket.fromMap(Map<String,dynamic> res)
  :basketSeq = res['basketSeq'],
  storeCode = res['storeCode'],
  buyProductCode = res['buyProductCode'],
  buyProductName = res['buyProductName'],
  buyProductPrice = res['buyProductPrice'],
  buyProductQuantity = res['buyProductQuantity'],
  salePrice = res['salePrice'];
}