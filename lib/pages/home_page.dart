import 'dart:convert';

import 'package:dotted_border/dotted_border.dart';
import 'package:financial_piggy_bank/model/transactions_item.dart';
import 'package:financial_piggy_bank/pages/expense_page.dart';
import 'package:financial_piggy_bank/pages/income_page.dart';
import 'package:financial_piggy_bank/pages/settings_page.dart';
import 'package:financial_piggy_bank/widget/line_chart_widget.dart';
import 'package:financial_piggy_bank/widget/pie_chart_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum EPageOnSelect { mainPage, mounthlyResult, compoundInterest, settingsPage }

enum EMounthlyResult { allIncomes, allExpenses, showMounthlyData }

enum ECategoryType {
  food("Food"),
  transport("Transport"),
  entertaiment("Entertaiment"),
  other('Other'),
  housing('Housing'),
  income('Income');

  const ECategoryType(this.text);
  final String text;
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final DateTime _selectedDate = DateTime.now();
  DateTime filterDate = DateTime.now();
  List<ECategoryType> categoryTypeList = [
    ECategoryType.housing,
    ECategoryType.food,
    ECategoryType.transport,
    ECategoryType.entertaiment,
    ECategoryType.other,
  ];
  EPageOnSelect page = EPageOnSelect.mainPage;
  TextEditingController textController = TextEditingController();
  TextEditingController textControllerDeposit = TextEditingController();
  TextEditingController textControllerRate = TextEditingController();
  TextEditingController textControllerPeriod = TextEditingController();
  List<TransactionItem> transactionsList = [];
  EMounthlyResult current = EMounthlyResult.allExpenses;
  var deposit = 0.0;
  var rate = 0.0;
  var period = 0.0;
  var totalIncome = 0.0;
  @override
  void initState() {
    super.initState();
    getSP();
  }

  Future<void> addToSP(
    List<TransactionItem>? transactionList,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    // await prefs.clear();

    if (transactionList != null) {
      prefs.setString('transactionLists', jsonEncode(transactionList));
    }
  }

  void getSP() async {
    final prefs = await SharedPreferences.getInstance();

    final List<dynamic> jsonData =
        jsonDecode(prefs.getString('transactionLists') ?? '[]');

    transactionsList = jsonData.map<TransactionItem>((jsonList) {
      {
        return TransactionItem.fromJson(jsonList);
      }
    }).toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF171030),
      body: Column(children: [
        Expanded(
            child: SingleChildScrollView(
                child: Column(
          children: [getContent()],
        ))),
        if (page == EPageOnSelect.compoundInterest && totalIncome != 0.0)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 17),
            child: Container(
              decoration: BoxDecoration(
                  color: const Color(0xFF28233E),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(width: 3, color: const Color(0xFf8600F2))),
              padding: const EdgeInsets.all(20),
              width: double.infinity,
              child: Column(
                children: [
                  Text(
                    '+${totalIncome.toStringAsFixed(2)}\$',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontFamily: 'HK Grotesk',
                        fontSize: 11,
                        color: Color(0xFF05FF00),
                        fontWeight: FontWeight.w400),
                  ),
                  Text(
                    '${deposit.toStringAsFixed(2)}\$',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontFamily: 'HK Grotesk',
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w800),
                  ),
                  const Text('Your result',
                      style: TextStyle(
                          fontFamily: 'HK Grotesk',
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF928EB0),
                          fontSize: 11))
                ],
              ),
            ),
          ),
        if (page == EPageOnSelect.mounthlyResult &&
            current == EMounthlyResult.allExpenses)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 17),
            child: InkWell(
              onTap: () {
                current = EMounthlyResult.showMounthlyData;
                setState(() {});
              },
              child: Container(
                  width: double.infinity,
                  height: 60,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      gradient: const LinearGradient(
                          colors: [Color(0xFF770ea7), Color(0xFF8600f2)]),
                      borderRadius: BorderRadius.circular(8)),
                  child: const Text(
                    'Show monthly data',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'HK Grotesk',
                        fontSize: 13,
                        color: Colors.white,
                        fontWeight: FontWeight.w800),
                  )),
            ),
          ),
        if (page == EPageOnSelect.compoundInterest)
          if (textControllerDeposit.text.isNotEmpty &&
              textControllerRate.text.isNotEmpty &&
              textControllerPeriod.text.isNotEmpty)
            // 100 000 ₽ × (6 / 100) / 365 × 31
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 17),
              child: InkWell(
                onTap: () {
                  deposit =
                      num.tryParse(textControllerDeposit.text)!.toDouble();
                  rate = num.tryParse(textControllerRate.text)!.toDouble();
                  period = num.tryParse(textControllerPeriod.text)!.toDouble();
                  var result = 0.0;
                  // var finalResult= num.tryParse(textControllerDeposit.text)!.toDouble();
                  for (var i = 0; i < period; i++) {
                    result = deposit * (rate / 100) / 365 * 30;
                    deposit = result + deposit;
                  }
                  totalIncome = deposit -
                      num.tryParse(textControllerDeposit.text)!.toDouble();

                  setState(() {});
                },
                child: Container(
                    width: double.infinity,
                    height: 60,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        gradient: const LinearGradient(
                            colors: [Color(0xFF770ea7), Color(0xFF8600f2)]),
                        borderRadius: BorderRadius.circular(8)),
                    child: const Text(
                      'Calculate',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'HK Grotesk',
                          fontSize: 13,
                          color: Colors.white,
                          fontWeight: FontWeight.w800),
                    )),
              ),
            ),
        customBottomNavigation()
      ]),
    );
  }

  Widget customBottomNavigation() {
    return Container(
      padding: const EdgeInsets.fromLTRB(35, 14, 35, 14),
      decoration: const BoxDecoration(color: Color(0xFF28233E)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              page = EPageOnSelect.mainPage;
              setState(() {});
            },
            child: SizedBox(
                height: 50,
                width: 50,
                child: Image.asset(
                  'assets/icons/mainPageIcon.png',
                  color: page != EPageOnSelect.mainPage ? null : Colors.white,
                )),
          ),
          InkWell(
            onTap: () {
              page = EPageOnSelect.mounthlyResult;
              setState(() {});
            },
            child: SizedBox(
                height: 70,
                width: 70,
                child: Image.asset(
                  'assets/icons/mounthlyResultIcon.png',
                  color: page != EPageOnSelect.mounthlyResult
                      ? null
                      : Colors.white,
                )),
          ),
          InkWell(
            onTap: () {
              page = EPageOnSelect.compoundInterest;
              setState(() {});
            },
            child: SizedBox(
                height: 70,
                width: 70,
                child: Image.asset(
                  'assets/icons/compoundInterestIcon.png',
                  color: page != EPageOnSelect.compoundInterest
                      ? null
                      : Colors.white,
                )),
          ),
          InkWell(
            onTap: () {
              page = EPageOnSelect.settingsPage;
              setState(() {});
            },
            child: SizedBox(
                height: 50,
                width: 50,
                child: Image.asset(
                  'assets/icons/setting.png',
                  color:
                      page != EPageOnSelect.settingsPage ? null : Colors.white,
                )),
          ),
        ],
      ),
    );
  }

  Widget getContent() {
    if (page == EPageOnSelect.settingsPage) {
      return const SettingsPage();
    } else if (page == EPageOnSelect.mainPage) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 60, 18, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('My Expenses',
                    style: TextStyle(
                        fontFamily: 'HK Grotesk',
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        fontSize: 24)),
                Text(
                  DateFormat("MMMM dd, yyyy").format(DateTime.now()),
                  style: const TextStyle(
                    color: Color(0xFF928EB0),
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    decorationColor: Color(0xFF928EB0),
                    decorationThickness: 2,
                    fontFamily: 'HK Grotesk',
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 35, 16, 35),
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                      builder: (BuildContext context) => AddExpensePage(
                            categoryTypeList: categoryTypeList,
                            callback: (item) {
                              transactionsList.add(item);
                              addToSP(
                                transactionsList,
                              );
                              setState(() {});
                            },
                          )),
                );
              },
              child: DottedBorder(
                borderType: BorderType.RRect,
                radius: const Radius.circular(4),
                color: const Color(0xFF928EB0),
                strokeWidth: 1,
                dashPattern: const [8, 8],
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(99, 40, 99, 40),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Add new expense',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: 'HK Grotesk',
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              fontSize: 13)),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 35),
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                      builder: (BuildContext context) => AddIncomePage(
                            categoryTypeList: categoryTypeList,
                            callback: (item) {
                              transactionsList.add(item);
                              addToSP(
                                transactionsList,
                              );
                              setState(() {});
                            },
                          )),
                );
              },
              child: const Text(
                'Add income',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.white,
                  decorationThickness: 2,
                  fontFamily: 'HK Grotesk',
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(15, 0, 15, 35),
            child: Divider(
              thickness: 0.5,
              height: 0,
              color: Color(0xFF28233E),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 17),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Categories',
                    style: TextStyle(
                        fontFamily: 'HK Grotesk',
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF928EB0),
                        fontSize: 10)),
                InkWell(
                    onTap: () {
                      showModalBottomSheet(
                          shape: const ContinuousRectangleBorder(
                              side: BorderSide()),
                          backgroundColor: const Color(0xFF28233E),
                          context: context,
                          constraints: BoxConstraints(
                              maxHeight:
                                  MediaQuery.of(context).size.height - 300),
                          builder: (context) {
                            return SizedBox(
                              width: double.infinity,
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Column(
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.only(
                                              top: 23, bottom: 18),
                                          child: Text('Sort by',
                                              style: TextStyle(
                                                  fontFamily: 'HK Grotesk',
                                                  fontWeight: FontWeight.w400,
                                                  color: Color(0xFF928EB0),
                                                  fontSize: 10)),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            transactionsList.sort((a, b) => a
                                                .type!.text
                                                .compareTo(b.type!.text));
                                            setState(() {});
                                            Navigator.pop(context);
                                          },
                                          child: const Padding(
                                            padding:
                                                EdgeInsets.only(bottom: 15),
                                            child: Text('Category',
                                                style: TextStyle(
                                                    fontFamily: 'HK Grotesk',
                                                    fontWeight: FontWeight.w800,
                                                    color: Colors.white,
                                                    fontSize: 15)),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            transactionsList.sort((a, b) =>
                                                b.cost!.compareTo(a.cost!));
                                            setState(() {});
                                            Navigator.pop(context);
                                          },
                                          child: const Padding(
                                            padding:
                                                EdgeInsets.only(bottom: 15),
                                            child: Text('Amount growth',
                                                style: TextStyle(
                                                    fontFamily: 'HK Grotesk',
                                                    fontWeight: FontWeight.w800,
                                                    color: Colors.white,
                                                    fontSize: 15)),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            transactionsList.sort((a, b) =>
                                                a.cost!.compareTo(b.cost!));
                                            setState(() {});
                                            Navigator.pop(context);
                                          },
                                          child: const Padding(
                                            padding:
                                                EdgeInsets.only(bottom: 15),
                                            child: Text('Amount decreasing',
                                                style: TextStyle(
                                                    fontFamily: 'HK Grotesk',
                                                    fontWeight: FontWeight.w800,
                                                    color: Colors.white,
                                                    fontSize: 15)),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            transactionsList.sort((a, b) =>
                                                b.date!.compareTo(a.date!));
                                            setState(() {});
                                            Navigator.pop(context);
                                          },
                                          child: const Padding(
                                            padding:
                                                EdgeInsets.only(bottom: 15),
                                            child: Text('Date (new)',
                                                style: TextStyle(
                                                    fontFamily: 'HK Grotesk',
                                                    fontWeight: FontWeight.w800,
                                                    color: Colors.white,
                                                    fontSize: 15)),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            transactionsList.sort((a, b) =>
                                                a.date!.compareTo(b.date!));
                                            setState(() {});
                                            Navigator.pop(context);
                                          },
                                          child: const Text('Date (ancient)',
                                              style: TextStyle(
                                                  fontFamily: 'HK Grotesk',
                                                  fontWeight: FontWeight.w800,
                                                  color: Colors.white,
                                                  fontSize: 15)),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Divider(
                                    thickness: 5,
                                    height: 0,
                                    color: Colors.black,
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(
                                        top: 27, bottom: 27),
                                    child: const Text('Cancel',
                                        style: TextStyle(
                                            fontFamily: 'HK Grotesk',
                                            fontWeight: FontWeight.w800,
                                            color: Colors.white,
                                            fontSize: 15)),
                                  ),
                                ],
                              ),
                            );
                          });
                    },
                    child: Image.asset('assets/icons/sorting.png'))
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: getTransactions(),
          )
        ],
      );
    } else if (page == EPageOnSelect.compoundInterest) {
      return Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(15, 60, 18, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Compound interest',
                    style: TextStyle(
                        fontFamily: 'HK Grotesk',
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        fontSize: 24)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 35, 16, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Text('Deposit amount ',
                      style: TextStyle(
                          fontFamily: 'HK Grotesk',
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF928EB0),
                          fontSize: 10)),
                ),
                Container(
                    decoration: BoxDecoration(
                        color: const Color(0xFF28233E),
                        borderRadius: BorderRadius.circular(4)),
                    child: TextField(
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      controller: textControllerDeposit,
                      style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'HK Grotesk',
                          fontWeight: FontWeight.w700,
                          fontSize: 15),
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.only(left: 30),
                        border: InputBorder.none,
                      ),
                      onEditingComplete: () {
                        setState(() {});
                      },
                    )),
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 35),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: Text('Deposit amount ',
                            style: TextStyle(
                                fontFamily: 'HK Grotesk',
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF928EB0),
                                fontSize: 10)),
                      ),
                      Container(
                          decoration: BoxDecoration(
                              color: const Color(0xFF28233E),
                              borderRadius: BorderRadius.circular(4)),
                          child: TextField(
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            controller: textControllerRate,
                            style: const TextStyle(
                                color: Colors.white,
                                fontFamily: 'HK Grotesk',
                                fontWeight: FontWeight.w700,
                                fontSize: 15),
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.only(left: 30),
                              border: InputBorder.none,
                            ),
                            onEditingComplete: () {
                              setState(() {});
                            },
                          )),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 35),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: Text('Deposit amount ',
                            style: TextStyle(
                                fontFamily: 'HK Grotesk',
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF928EB0),
                                fontSize: 10)),
                      ),
                      Container(
                          decoration: BoxDecoration(
                              color: const Color(0xFF28233E),
                              borderRadius: BorderRadius.circular(4)),
                          child: TextField(
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            controller: textControllerPeriod,
                            style: const TextStyle(
                                color: Colors.white,
                                fontFamily: 'HK Grotesk',
                                fontWeight: FontWeight.w700,
                                fontSize: 15),
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.only(left: 30),
                              border: InputBorder.none,
                            ),
                            onEditingComplete: () {
                              setState(() {});
                            },
                          )),
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      );
    } else if (page == EPageOnSelect.mounthlyResult) {
      if (current == EMounthlyResult.allExpenses ||
          current == EMounthlyResult.allIncomes) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 60, 18, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Monthly result',
                      style: TextStyle(
                          fontFamily: 'HK Grotesk',
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          fontSize: 24)),
                  InkWell(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) => Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Dialog(
                                      backgroundColor: const Color(0xFF28233E),
                                      child: SizedBox(
                                        width: 300,
                                        height: 200,
                                        child: CupertinoTheme(
                                          data: const CupertinoThemeData(
                                            brightness: Brightness.dark,
                                          ),
                                          child: CupertinoDatePicker(
                                            mode: CupertinoDatePickerMode.date,
                                            initialDateTime: _selectedDate,
                                            onDateTimeChanged:
                                                (DateTime newDate) {
                                              setState(() {
                                                filterDate = newDate;
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ));
                      },
                      child: const Text(
                        'Choose period',
                        style: TextStyle(
                          color: Color(0xFF928EB0),
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                          decoration: TextDecoration.underline,
                          decorationColor: Color(0xFF928EB0),
                          decorationThickness: 2,
                          fontFamily: 'HK Grotesk',
                        ),
                      ))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 35, 18, 35),
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        current = EMounthlyResult.allExpenses;
                        setState(() {});
                      },
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: current == EMounthlyResult.allExpenses
                                ? const Color(0xFF28233E)
                                : null,
                            borderRadius: BorderRadius.circular(3)),
                        padding: const EdgeInsets.all(10),
                        child: const Text('All Expenses',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: 'HK Grotesk',
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                fontSize: 12)),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        current = EMounthlyResult.allIncomes;
                        setState(() {});
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: current == EMounthlyResult.allIncomes
                                ? const Color(0xFF28233E)
                                : null,
                            borderRadius: BorderRadius.circular(3)),
                        width: double.infinity,
                        padding: const EdgeInsets.all(10),
                        child: const Text('All Incomes',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: 'HK Grotesk',
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                fontSize: 12)),
                      ),
                    ),
                  )
                ],
              ),
            ),
            if (current == EMounthlyResult.allExpenses)
              Padding(
                padding: const EdgeInsets.only(bottom: 35),
                child: Column(
                  children: [
                    Text(
                      '${totalExpense()}\$',
                      style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'HK Grotesk',
                          fontSize: 28,
                          fontWeight: FontWeight.w800),
                    ),
                    const Text(
                      'Total spent',
                      style: TextStyle(
                          color: Color(0xFF928EB0),
                          fontFamily: 'HK Grotesk',
                          fontSize: 13,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
            if (current == EMounthlyResult.allIncomes)
              Padding(
                padding: const EdgeInsets.only(bottom: 35),
                child: Column(
                  children: [
                    Text(
                      '${totalIncomeNum()}\$',
                      style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'HK Grotesk',
                          fontSize: 28,
                          fontWeight: FontWeight.w800),
                    ),
                    const Text(
                      'Total spent',
                      style: TextStyle(
                          color: Color(0xFF928EB0),
                          fontFamily: 'HK Grotesk',
                          fontSize: 13,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
            if (current == EMounthlyResult.allIncomes)
              BarChartWidget(
                points: transactionsList
                    .where((element) =>
                        element.type == ECategoryType.income &&
                        element.date!.month == filterDate.month &&
                        element.date!.year == DateTime.now().year)
                    .toList(),
              ),
            if (current == EMounthlyResult.allExpenses)
              BarChartWidget(
                points: transactionsList
                    .where((element) =>
                        element.type != ECategoryType.income &&
                        element.date!.month == filterDate.month &&
                        element.date!.year == DateTime.now().year)
                    .toList(),
              ),
          ],
        );
      } else {
        return Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 35, 16, 35),
              child: InkWell(
                onTap: () {
                  current = EMounthlyResult.allExpenses;
                  filterDate = DateTime.now();
                  setState(() {});
                },
                child: Row(
                  children: [
                    const Text('Expenses Monthly Data',
                        style: TextStyle(
                            fontFamily: 'HK Grotesk',
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            fontSize: 15))
                  ],
                ),
              ),
            ),
            if (page == EPageOnSelect.mounthlyResult)
              SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: months(),
                  )),
            Stack(alignment: Alignment.center, children: [
              if (transactionsList.isNotEmpty &&
                  transactionsList
                      .where((element) =>
                          element.type != ECategoryType.income &&
                          element.date!.month == filterDate.month &&
                          element.date!.year == DateTime.now().year)
                      .toList()
                      .isNotEmpty)
                PieChartSample(
                    points: transactionsList
                        .where((element) =>
                            element.type != ECategoryType.income &&
                            element.date!.month == filterDate.month &&
                            element.date!.year == DateTime.now().year)
                        .toList()),
              if (filterDate == DateTime(0))
                PieChartSample(
                    points: transactionsList
                        .where(
                            (element) => element.type != ECategoryType.income)
                        .toList()),
              if (filterDate == DateTime(0))
                Column(
                  children: [
                    Text(
                      '${allTotalExpense()}\$',
                      style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'HK Grotesk',
                          fontSize: 20,
                          fontWeight: FontWeight.w800),
                    ),
                    const Text(
                      'Total spent',
                      style: TextStyle(
                          color: Color(0xFF928EB0),
                          fontFamily: 'HK Grotesk',
                          fontSize: 11,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              if (transactionsList.isNotEmpty &&
                  transactionsList
                      .where((element) =>
                          element.type != ECategoryType.income &&
                          element.date!.month == filterDate.month &&
                          element.date!.year == DateTime.now().year)
                      .toList()
                      .isNotEmpty)
                Column(
                  children: [
                    Text(
                      '${totalExpense()}\$',
                      style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'HK Grotesk',
                          fontSize: 20,
                          fontWeight: FontWeight.w800),
                    ),
                    const Text(
                      'Total spent',
                      style: TextStyle(
                          color: Color(0xFF928EB0),
                          fontFamily: 'HK Grotesk',
                          fontSize: 11,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              if (filterDate != DateTime(0) &&
                  transactionsList
                      .where((element) =>
                          element.type != ECategoryType.income &&
                          element.date!.month == filterDate.month &&
                          element.date!.year == DateTime.now().year)
                      .toList()
                      .isEmpty)
                const Padding(
                  padding: EdgeInsets.only(top: 30),
                  child: Text(
                    'You had no expenses',
                    style: TextStyle(
                        color: Color(0xFF928EB0),
                        fontFamily: 'HK Grotesk',
                        fontSize: 15,
                        fontWeight: FontWeight.w400),
                  ),
                )
            ]),
            if (transactionsList.isNotEmpty &&
                    transactionsList
                        .where((element) =>
                            element.type != ECategoryType.income &&
                            element.date!.month == filterDate.month &&
                            element.date!.year == DateTime.now().year)
                        .toList()
                        .isNotEmpty ||
                filterDate == DateTime(0))
              const Padding(
                padding: EdgeInsets.fromLTRB(15, 0, 15, 35),
                child: Divider(
                  thickness: 0.5,
                  height: 0,
                  color: Color(0xFF28233E),
                ),
              ),
            if (transactionsList.isNotEmpty &&
                    transactionsList
                        .where((element) =>
                            element.type != ECategoryType.income &&
                            element.date!.month == filterDate.month &&
                            element.date!.year == DateTime.now().year)
                        .toList()
                        .isNotEmpty ||
                filterDate == DateTime(0))
              getTypes()
          ],
        );
      }
    } else {
      return const SizedBox();
    }
  }

  Widget months() {
    List<Widget> list = [];

    list.add(InkWell(
      onTap: () {
        filterDate = DateTime(0);
        setState(() {});
      },
      child: Container(
        decoration: BoxDecoration(
            color: filterDate == DateTime(0) ? const Color(0xFF28233E) : null,
            borderRadius: BorderRadius.circular(3)),
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.only(right: 10),
        child: const Text('All Incomes',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: 'HK Grotesk',
                fontWeight: FontWeight.w800,
                color: Colors.white,
                fontSize: 12)),
      ),
    ));
    list.add(InkWell(
      onTap: () {
        filterDate = DateTime.now();
        setState(() {});
      },
      child: Container(
        decoration: BoxDecoration(
            color: filterDate.month == DateTime.now().month
                ? const Color(0xFF28233E)
                : null,
            borderRadius: BorderRadius.circular(3)),
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.only(right: 10),
        child: const Text('This month',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: 'HK Grotesk',
                fontWeight: FontWeight.w800,
                color: Colors.white,
                fontSize: 12)),
      ),
    ));
    List<int> listMonts = [];
    for (var i = 1; i <= 11; i++) {
      listMonts.add(i);
      listMonts.sort((a, b) => b.compareTo(a));
    }
    for (var month in listMonts) {
      list.add(InkWell(
        onTap: () {
          filterDate = DateTime(2023, month);
          setState(() {});
        },
        child: Container(
          decoration: BoxDecoration(
              color: filterDate == DateTime(2023, month)
                  ? const Color(0xFF28233E)
                  : null,
              borderRadius: BorderRadius.circular(3)),
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.only(right: 10),
          child: Text(
              DateFormat("MMMM yyyy")
                  .format(DateTime(DateTime.now().year, month)),
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontFamily: 'HK Grotesk',
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  fontSize: 12)),
        ),
      ));
    }
    return Row(
      children: list,
    );
  }

  double allTotalExpense() {
    var totalCost = 0.0;
    for (var transaction in transactionsList
        .where((element) => element.type != ECategoryType.income)
        .toList()) {
      totalCost = totalCost + transaction.cost!;
    }
    return totalCost;
  }

  double totalExpense() {
    var totalCost = 0.0;
    for (var transaction in transactionsList
        .where((element) =>
            element.type != ECategoryType.income &&
            element.date!.month == filterDate.month &&
            element.date!.year == DateTime.now().year)
        .toList()) {
      totalCost = totalCost + transaction.cost!;
    }
    return totalCost;
  }

  double totalIncomeNum() {
    var totalCost = 0.0;
    for (var transaction in transactionsList
        .where((element) => element.type == ECategoryType.income)
        .toList()) {
      totalCost = totalCost + transaction.cost!;
    }
    return totalCost;
  }

  Widget getTypes() {
    List<Widget> list1 = [];
    List<Widget> list2 = [];

    for (var type in categoryTypeList.where((element) =>
        element == ECategoryType.housing ||
        element == ECategoryType.food ||
        element == ECategoryType.transport)) {
      list1.add(Padding(
        padding: const EdgeInsets.only(right: 10),
        child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: const Color(0xFF28233E),
                borderRadius: BorderRadius.circular(3)),
            child: type == ECategoryType.food
                ? Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(right: 8),
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: const Color(0xFFFFF27A)),
                      ),
                      Text(
                        type.text,
                        style: const TextStyle(
                            fontFamily: 'HK Grotesk',
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            fontSize: 15),
                      )
                    ],
                  )
                : type == ECategoryType.entertaiment
                    ? Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(right: 8),
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: const Color(0xFFFF7AFA)),
                          ),
                          Text(
                            type.text,
                            style: const TextStyle(
                                fontFamily: 'HK Grotesk',
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                fontSize: 15),
                          )
                        ],
                      )
                    : type == ECategoryType.housing
                        ? Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(right: 8),
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: const Color(0xFF937AFF)),
                              ),
                              Text(
                                type.text,
                                style: const TextStyle(
                                    fontFamily: 'HK Grotesk',
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                    fontSize: 15),
                              )
                            ],
                          )
                        : type == ECategoryType.transport
                            ? Row(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(right: 8),
                                    width: 10,
                                    height: 10,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        color: const Color(0xFF7AFF88)),
                                  ),
                                  Text(
                                    type.text,
                                    style: const TextStyle(
                                        fontFamily: 'HK Grotesk',
                                        fontWeight: FontWeight.w800,
                                        color: Colors.white,
                                        fontSize: 15),
                                  )
                                ],
                              )
                            : Row(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(right: 8),
                                    width: 10,
                                    height: 10,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        color: const Color(0xFFFF7A7A)),
                                  ),
                                  Text(
                                    type.text,
                                    style: const TextStyle(
                                        fontFamily: 'HK Grotesk',
                                        fontWeight: FontWeight.w800,
                                        color: Colors.white,
                                        fontSize: 15),
                                  )
                                ],
                              )),
      ));
    }
    for (var type in categoryTypeList.where((element) =>
        element == ECategoryType.entertaiment ||
        element == ECategoryType.other)) {
      list2.add(Padding(
        padding: const EdgeInsets.only(right: 10),
        child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: const Color(0xFF28233E),
                borderRadius: BorderRadius.circular(3)),
            child: type == ECategoryType.food
                ? Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(right: 8),
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: const Color(0xFFFFF27A)),
                      ),
                      Text(
                        type.text,
                        style: const TextStyle(
                            fontFamily: 'HK Grotesk',
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            fontSize: 15),
                      )
                    ],
                  )
                : type == ECategoryType.entertaiment
                    ? Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(right: 8),
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: const Color(0xFFFF7AFA)),
                          ),
                          Text(
                            type.text,
                            style: const TextStyle(
                                fontFamily: 'HK Grotesk',
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                fontSize: 15),
                          )
                        ],
                      )
                    : type == ECategoryType.housing
                        ? Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(right: 8),
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: const Color(0xFF937AFF)),
                              ),
                              Text(
                                type.text,
                                style: const TextStyle(
                                    fontFamily: 'HK Grotesk',
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                    fontSize: 15),
                              )
                            ],
                          )
                        : type == ECategoryType.transport
                            ? Row(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(right: 8),
                                    width: 10,
                                    height: 10,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        color: const Color(0xFF7AFF88)),
                                  ),
                                  Text(
                                    type.text,
                                    style: const TextStyle(
                                        fontFamily: 'HK Grotesk',
                                        fontWeight: FontWeight.w800,
                                        color: Colors.white,
                                        fontSize: 15),
                                  )
                                ],
                              )
                            : Row(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(right: 8),
                                    width: 10,
                                    height: 10,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        color: const Color(0xFFFF7A7A)),
                                  ),
                                  Text(
                                    type.text,
                                    style: const TextStyle(
                                        fontFamily: 'HK Grotesk',
                                        fontWeight: FontWeight.w800,
                                        color: Colors.white,
                                        fontSize: 15),
                                  )
                                ],
                              )),
      ));
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: list1,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: list2,
        )
      ],
    );
  }

  Widget getTransactions() {
    List<Widget> list = [];
    for (var transaction in transactionsList) {
      list.add(Container(
        margin: const EdgeInsets.only(bottom: 17),
        padding: const EdgeInsets.only(top: 5, bottom: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 13),
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: const Color(0xFF28233E),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: transaction.type == ECategoryType.food
                        ? Image.asset('assets/icons/food.png')
                        : transaction.type == ECategoryType.entertaiment
                            ? Image.asset('assets/icons/entertainment.png')
                            : transaction.type == ECategoryType.housing
                                ? Image.asset('assets/icons/home.png')
                                : transaction.type == ECategoryType.transport
                                    ? Image.asset('assets/icons/car.png')
                                    : transaction.type == ECategoryType.income
                                        ? Image.asset('assets/icons/income.png')
                                        : Image.asset('assets/icons/other.png'),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Text(transaction.type!.text,
                          style: const TextStyle(
                              fontFamily: 'HK Grotesk',
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              fontSize: 15)),
                    ),
                    Text(
                        DateFormat("dd.MM.yyyy hh:mm")
                            .format(transaction.date!),
                        style: const TextStyle(
                            color: Color(0xFF928EB0), fontSize: 11)),
                  ],
                ),
              ],
            ),
            if (transaction.type == ECategoryType.income)
              Text('+${transaction.cost.toString()}\$',
                  style: const TextStyle(
                      fontFamily: 'HK Grotesk',
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF05FF00),
                      fontSize: 15))
            else
              Text('- ${transaction.cost.toString()}\$',
                  style: const TextStyle(
                      fontFamily: 'HK Grotesk',
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontSize: 16))
          ],
        ),
      ));
    }
    return Column(
      children: list,
    );
  }
}
