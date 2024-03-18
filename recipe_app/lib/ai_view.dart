import 'package:flutter/material.dart';
import 'package:recipe_app/ai_result_view.dart';
import 'package:recipe_app/api_service.dart';

class AIPage extends StatefulWidget {
  const AIPage({super.key});

  @override
  State<AIPage> createState() => _AIPageState();
}

List<String> _listOfIngredients = [];

class _AIPageState extends State<AIPage> {
  final TextEditingController _controller = TextEditingController();

  String _hintText = 'Enter your ingredient...';

  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(27.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const Align(
              alignment: Alignment.topLeft,
              child: Text(
                'What\'s in your kitchen?',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ),
            const Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.only(top: 8.0, bottom: 50.0),
                child: Text(
                  'Enter up to 4 ingredients',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    margin: const EdgeInsets.only(bottom: 30.0),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 3,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        ),
                      ],
                      color: Colors.white,
                    ),
                    child: TextField(
                      controller: _controller,
                      onSubmitted: (value) {
                        _hintText = 'Enter your ingredient...';
                        if (value != '' && _listOfIngredients.length < 4) {
                          _listOfIngredients.add(value);
                          refresh();
                        }
                        _controller.value = TextEditingValue.empty;
                        debugPrint(_listOfIngredients.toString());
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: _hintText,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: _listOfIngredients.length,
              itemBuilder: (context, index) {
                return IngredientCard(
                    ingredientStr: _listOfIngredients[index],
                    callback: refresh);
              },
            ),
            ElevatedButton(
              onPressed: () async {
                if (_listOfIngredients.length > 0) {
                  try {
                    String result =
                        await APIService.getData(_listOfIngredients);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              AIResultView(apiResult: result)),
                    );
                  } catch (e) {
                    _hintText = e.toString();
                  }
                } else {
                  _hintText = 'Please enter an ingredient first';
                  refresh();
                }
              },
              child: const Text('Generate Ideas'),
            ),
            Text(
              'Powered by Cohere',
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class IngredientCard extends StatefulWidget {
  const IngredientCard(
      {super.key, required this.ingredientStr, required this.callback});

  final String ingredientStr;
  final Function callback;

  @override
  State<IngredientCard> createState() => _IngredientCardState();
}

class _IngredientCardState extends State<IngredientCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      padding: const EdgeInsets.only(left: 20, right: 20),
      height: 70,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color.fromARGB(255, 237, 237, 237),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.ingredientStr,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            width: 40,
            height: 20,
            child: ElevatedButton(
              onPressed: () {
                _listOfIngredients
                    .removeWhere((item) => item == widget.ingredientStr);
                widget.callback();
              },
              child: const Icon(
                Icons.delete,
                size: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
