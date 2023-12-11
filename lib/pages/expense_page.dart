import 'package:financial_piggy_bank/model/transactions_item.dart';
import 'package:financial_piggy_bank/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddExpensePage extends StatefulWidget {
  const AddExpensePage(
      {super.key, required this.categoryTypeList, required this.callback});
  final List<ECategoryType> categoryTypeList;
  final Function(TransactionItem) callback;

  @override
  State<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  ECategoryType currentType = ECategoryType.food;
  TextEditingController textController = TextEditingController();
  TransactionItem transaction = TransactionItem();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF171030),
      body: Column(
        children: [
          Expanded(
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 35, 16, 35),
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 7),
                        child: Image.asset('assets/icons/chevron_left.png'),
                      ),
                      const Text('Add Expense',
                          style: TextStyle(
                              fontFamily: 'HK Grotesk',
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              fontSize: 15))
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 35),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Text('Enter the expense amount',
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
                          controller: textController,
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
              const Padding(
                padding: EdgeInsets.fromLTRB(15, 0, 15, 35),
                child: Divider(
                  thickness: 0.5,
                  height: 0,
                  color: Color(0xFF28233E),
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 0, 16, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Choose a category',
                        style: TextStyle(
                            fontFamily: 'HK Grotesk',
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF928EB0),
                            fontSize: 10)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
                child: getTypes(),
              ),
            ]),
          ),
          if (textController.text.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 17),
              child: InkWell(
                onTap: () {
                  transaction.type = currentType;
                  transaction.cost =
                      num.tryParse(textController.text)!.toDouble();
                  transaction.date = DateTime.now();
                  widget.callback(transaction);
                  Navigator.pop(context);
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
                      'Add Expense',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'HK Grotesk',
                          fontSize: 13,
                          color: Colors.white,
                          fontWeight: FontWeight.w800),
                    )),
              ),
            ),
        ],
      ),
    );
  }

  Widget getTypes() {
    List<Widget> list = [];

    for (var type in widget.categoryTypeList) {
      bool selected = currentType == type;
      list.add(InkWell(
        onTap: () {
          if (!selected) {
            selected = true;
            currentType = type;
            setState(() {});
          }
        },
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
              color: const Color(0xFF28233E),
              borderRadius: BorderRadius.circular(50),
              border: selected
                  ? Border.all(
                      color: const Color(
                        0xFF8600F2,
                      ),
                      width: 2)
                  : null),
          child: type == ECategoryType.food
              ? Image.asset('assets/icons/food.png')
              : type == ECategoryType.entertaiment
                  ? Image.asset('assets/icons/entertainment.png')
                  : type == ECategoryType.housing
                      ? Image.asset('assets/icons/home.png')
                      : type == ECategoryType.transport
                          ? Image.asset('assets/icons/car.png')
                          : Image.asset('assets/icons/other.png'),
        ),
      ));
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: list,
    );
  }
}
