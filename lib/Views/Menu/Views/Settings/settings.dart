import 'package:flutter/material.dart';
import 'package:zaitoon_invoice/Views/Menu/Views/Settings/Views/about.dart';
import 'package:zaitoon_invoice/Views/Menu/Views/Settings/Views/database_settings.dart';
import 'package:zaitoon_invoice/Views/Menu/Views/Settings/Views/general.dart';
import 'package:zaitoon_invoice/Views/Menu/Views/Settings/Views/invoice_settings.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    isExpanded = true;
    isSelected = false;
    _tabController = TabController(length: 4, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  bool isSelected = false;
  int isSelectedIndex = 0;
  bool isExpanded = true;

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return AlertDialog(
        contentPadding: EdgeInsets.zero,
        insetPadding: EdgeInsets.zero,
        titlePadding: EdgeInsets.zero,   // Removes padding around the title
        actionsPadding: EdgeInsets.zero,
        content: Container(
        padding: EdgeInsets.zero,
        height: MediaQuery.sizeOf(context).height *.93,
    width: MediaQuery.sizeOf(context).width *.93,
    decoration: BoxDecoration(
    color: Theme.of(context).colorScheme.surfaceContainer,
    borderRadius: BorderRadius.circular(8)
    ),
    child: Column(
      children: [
        //Header
        Container(
          margin: EdgeInsets.zero,
          padding: const EdgeInsets.all(0),
          height: 106,
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(8),
                  topLeft: Radius.circular(8)
              )
          ),
          child: Column(
            children: [
              //Title
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Icon(Icons.settings),
                        const SizedBox(width: 10),
                        Text(localization.settings,style: const TextStyle(fontSize: 17),)
                      ],
                    ),
                    IconButton(
                        onPressed: (){
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.clear))
                  ],
                ),
              ),

              //Tab bar
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TabBar(
                    controller: _tabController,
                    tabAlignment: TabAlignment.start,
                    isScrollable: true,
                    padding: EdgeInsets.zero,
                    indicatorPadding: EdgeInsets.zero,
                    labelPadding: const EdgeInsets.symmetric(horizontal: 8),
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicatorWeight: 3,
                    tabs:  [
                      //General Tab
                      Tab(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(Icons.settings),
                            const SizedBox(width: 6),
                            Text(AppLocalizations.of(context)!.general),
                          ],
                        ),

                      ),
                      //Invoice Settings Tab
                      Tab(
                        child: Row(
                          children: [
                            const Icon(Icons.fact_check_outlined),
                            const SizedBox(width: 6),
                            Text(localization.invoiceSettings),
                          ],
                        ),
                      ),

                      //Database Tab
                      Tab(
                        child: Row(
                          children: [
                            const Icon(Icons.storage_rounded),
                            const SizedBox(width: 6),
                            Text(localization.databaseSettings),
                          ],
                        ),
                      ),

                      //About Tab
                      Tab(
                        child: Row(
                          children: [
                            const Icon(Icons.info),
                            const SizedBox(width: 6),
                            Text(AppLocalizations.of(context)!.about),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              )

            ],
          ),
        ),
        //Body
        Expanded(
          child: TabBarView(
            physics: const AlwaysScrollableScrollPhysics(),
            controller: _tabController,
            children: const [
              GeneralSettings(),
              InvoiceSettings(),
              DatabaseSettings(),
              AboutView(),
            ],
          ),
        ),
      ],
    ),
        ));
  }
}
