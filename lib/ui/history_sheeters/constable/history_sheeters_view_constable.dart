import 'package:beatapp/base_statefull.dart';
import 'package:beatapp/custom_view/common_list_item.dart';
import 'package:beatapp/ui/history_sheeters/constable/subview/cons_completed_view_history_sheeters.dart';
import 'package:beatapp/ui/history_sheeters/constable/subview/cons_pending_view_history_sheeters.dart';
import 'package:beatapp/utility/extentions/int_ext.dart';
import 'package:beatapp/utility/resource_provider.dart';
import 'package:flutter/material.dart';

class HistorySheetersActivityConstable extends StatefulWidget {
  const HistorySheetersActivityConstable({super.key});

  @override
  State<HistorySheetersActivityConstable> createState() => _HistorySheetersActivityConstableState();
}

class _HistorySheetersActivityConstableState extends BaseFullState<HistorySheetersActivityConstable> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(ColorProvider.color_window_bg),
      appBar: AppBar(
        title: const Text("History Sheetors"),
        backgroundColor: Color(ColorProvider.colorPrimary),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListenableBuilder(
          listenable: stateChanger,
          builder:(context,child)=> Column(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ConsPendingFragmentHistorySheeters(),
                        ));
                  },
                  child: TotalPendingCompletedItem(
                    title: "TOTAL LIST",
                    value: stateChanger.dashCounts.TotalHistorySheeter.toString(),
                  ),
                ),
                12.height,
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ConsCompletedFragmentHistorySheeters(),
                        ));
                  },
                  child: TotalPendingCompletedItem(
                    title: "VERIFICATION ENQUIRY\nCOMPLETED",
                    value: stateChanger.dashCounts.TotalEnquiryCompletedHistorySheeter.toString(),
                  ),
                ),
              ]),
        ),
      ),
    );
  }
}
