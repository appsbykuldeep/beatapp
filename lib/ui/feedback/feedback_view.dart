import 'package:beatapp/localization/app_translations.dart';
import 'package:beatapp/utility/resource_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';


class FeedbackView extends StatefulWidget {
  const FeedbackView({Key? key}) : super(key: key);

  @override
  State<FeedbackView> createState() => _FeedbackViewState();
}

class _FeedbackViewState extends State<FeedbackView> {
  String getTranlateString(String key) {
    return AppTranslations.of(context)!.text(key);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(ColorProvider.color_window_bg),
      appBar: AppBar(
        title: Text(getTranlateString("profile")),
        backgroundColor: Color(ColorProvider.colorPrimary),
      ),
      body: Container(
          margin: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 10),
                alignment: Alignment.center,
                child: RatingBar.builder(
                  initialRating: 3,
                  minRating: 1,
                  direction: Axis.horizontal,
                  wrapAlignment: WrapAlignment.center,
                  allowHalfRating: true,
                  itemSize: 50,
                  itemCount: 5,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    //print(rating);
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20),
                child: Text(
                  getTranlateString("feedback"),
                  textAlign: TextAlign.left,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 5),
                child: InkWell(
                  child: Container(
                    width: MediaQuery.of(context).size.width * .90,
                    padding:
                        const EdgeInsets.only(right: 5, top: 8, left: 5, bottom: 8),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.all(Radius.circular(5)),
                        border: Border.all(color: Colors.black, width: 1.0)),
                    child: const TextField(
                      style: TextStyle(),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(top: 25),
                child: InkWell(
                  onTap: () => {},
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
                    decoration: BoxDecoration(
                      color: Color(ColorProvider.colorPrimary),
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                    ),
                    child: Text(
                      AppTranslations.of(context)!.text("submit"),
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              )
            ],
          )),
    );
  }
}
