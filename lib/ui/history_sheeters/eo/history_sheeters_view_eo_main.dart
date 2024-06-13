import 'package:beatapp/base_statefull.dart';
import 'package:beatapp/custom_view/common_list_item.dart';

import 'package:beatapp/ui/history_sheeters/eo/subview/completed_view_history_sheeter.dart';
import 'package:beatapp/ui/history_sheeters/eo/subview/pending_view_history_sheeters.dart';
import 'package:beatapp/utility/extentions/int_ext.dart';
import 'package:beatapp/utility/resource_provider.dart';
import 'package:flutter/material.dart';

class HistorySheetersActivityEOMain extends StatefulWidget {
   const HistorySheetersActivityEOMain({super.key});

  @override
  State<HistorySheetersActivityEOMain> createState() => _HistorySheetersActivityEOMainState();
}

class _HistorySheetersActivityEOMainState extends BaseFullState<HistorySheetersActivityEOMain> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(ColorProvider.color_window_bg),
      appBar: AppBar(
        title: const Text("History Sheeters"),
        backgroundColor: Color(ColorProvider.colorPrimary),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListenableBuilder(
          listenable: stateChanger,
          builder:(context,child)=>  Column(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PendingFragmentHistorySheeters(),
                        ));
                  },
                  child: TotalPendingCompletedItem(
                    title: "Pending History Sheeter",
                    value: stateChanger.dashCounts.PendingHistorySheeter.toString(),
                  ),
                ),
                12.height,
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CompletedFragmentHistorySheeter(),
                        ));
                  },
                  child: TotalPendingCompletedItem(
                    title: "VERIFICATION ENQUIRY\nCOMPLETED",
                    value: stateChanger.dashCounts.CompletedHistorySheeter.toString(),
                  ),
                ),
              ]),
        ),
      ),
    );
  }
}
