import 'package:flutter/material.dart';

class EdocumentCard extends StatefulWidget {
  final Color edocumentStateColor;

  const EdocumentCard({super.key, required this.edocumentStateColor});

  @override
  State<EdocumentCard> createState() => _EdocumentCardState();
}

class _EdocumentCardState extends State<EdocumentCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
          side: BorderSide(width: 0.1),
        ),
        elevation: 5,
        color: Colors.white,
        shadowColor: Colors.black,
        child: Row(
          children: [
            Container(height: 120, width: 5, color: widget.edocumentStateColor),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

              ],
            ),
          ],
        ),
      ),
    );
  }
}
