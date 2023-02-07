import 'package:flutter/material.dart';

import 'event_bus.dart';

class SelectiveList extends StatefulWidget {
  const SelectiveList({super.key, required this.contents});

  final List<String> contents;

  @override
  State<SelectiveList> createState() => SelectiveListState();
}

class SelectiveListState extends State<SelectiveList> {
  final TextEditingController _searchController = TextEditingController();
  List<String>? _displayedList;

  bool _searching = false;

  void _filterSearchResults(String query) {
    final contents = widget.contents;
    if (query.isNotEmpty) {
      List<String> dummyListData = [];

      for (var item in contents) {
        if (item.contains(query)) {
          dummyListData.add(item);
        }
      }
      setState(() {
        _displayedList = List.from(dummyListData);
      });
      return;
    } else {
      setState(() {
        _displayedList = List.from(contents);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final contents = widget.contents;

    if (!_searching) {
      _displayedList = List.from(contents);
      _searchController.text = "";
    }

    _searching = false;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            onChanged: (value) {
              _filterSearchResults(value);
              _searching = true;
            },
            controller: _searchController,
            decoration: const InputDecoration(
              labelText: "Search",
              hintText: "Search",
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(25.0),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: _displayedList!.length,
            itemBuilder: (BuildContext context, int index) {
              return Center(
                child: ElevatedButton(
                  onPressed: () {
                    eventBus.fire(SelectTitleEvent(_displayedList![index]));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pinkAccent[100],
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: Text(
                    _displayedList![index],
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) {
              return const Divider();
            },
          ),
        ),
      ],
    );
  }
}
