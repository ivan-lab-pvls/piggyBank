import 'package:financial_piggy_bank/pages/home_page.dart';
import 'package:financial_piggy_bank/pages/show.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  EPageOnSelect page = EPageOnSelect.settingsPage;
  @override
  Widget build(BuildContext context) {
    return getContent();
  }

  Widget getContent() {
    return Padding(
        padding: const EdgeInsets.fromLTRB(18, 60, 18, 0),
        child: Column(children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Settings',
                  style: TextStyle(
                      fontFamily: 'HK Grotesk',
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      fontSize: 24)),
            ],
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                    builder: (BuildContext context) =>
                        const PLTRMS(
                          link: 'https://docs.google.com/document/d/15ooe_ij2W-zrZK7-P0axjXSMr4VPbAoBwgaHX2_4mGI/edit?usp=sharing',
                        )),
              );
            },
            child: Container(
              padding: const EdgeInsets.only(top: 35, bottom: 18),
              child: Row(
                children: [
                  Image.asset(
                    'assets/icons/privacy.png',
                    color: const Color(0xFF64607D),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 15),
                    child: Text('Privacy Policy',
                        style: TextStyle(
                            fontFamily: 'HK Grotesk',
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500)),
                  )
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                    builder: (BuildContext context) =>
                        const PLTRMS(
                          link: 'https://docs.google.com/document/d/1GhleYZmsB3ZCptxus1wAIDYWHZolXQxJOk0Rx659svQ/edit?usp=sharing',
                        )),
              );
            },
            child: Container(
              padding: const EdgeInsets.only(top: 18, bottom: 18),
              child: Row(
                children: [
                  Image.asset(
                    'assets/icons/chat.png',
                    color: const Color(0xFF64607D),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 15),
                    child: Text('Terms of Use',
                        style: TextStyle(
                            fontFamily: 'HK Grotesk',
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500)),
                  )
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
                InAppReview.instance.openStoreListing(
                    appStoreId: '6474137437',
                  );
            },
            child: Container(
              padding: const EdgeInsets.only(top: 18, bottom: 18),
              child: Row(
                children: [
                  Image.asset(
                    'assets/icons/star.png',
                    color: const Color(0xFF64607D),
                  ),
                  const Flexible(
                    child: Padding(
                      padding: EdgeInsets.only(left: 15),
                      child: Text('Rate app',
                          style: TextStyle(
                              fontFamily: 'HK Grotesk',
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500)),
                    ),
                  )
                ],
              ),
            ),
          ),
        ]));
  }
}
