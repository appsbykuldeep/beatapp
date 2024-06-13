import 'package:beatapp/utility/resource_provider.dart';
import 'package:flutter/material.dart';

class TotalPendingCompletedItem extends StatelessWidget {
  const TotalPendingCompletedItem({Key? key, this.title = '', this.value = ''})
      : super(key: key);
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(6)),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    color: ColorProvider.redColor,
                    height: 5,
                  ),
                  Container(
                    color: ColorProvider.blueColor,
                    height: 5,
                  )
                ],
              ),
            ),
            Container(
              color: Colors.white,
              alignment: Alignment.center,
              height: 90,
              padding: const EdgeInsets.all(10),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title.toUpperCase(),
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      "Total : $value",
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    )
                  ]),
            ),
          ],
        ),
      ),
    );
  }
}
