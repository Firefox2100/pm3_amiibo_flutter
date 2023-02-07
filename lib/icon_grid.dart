import 'package:flutter/material.dart';

import 'event_bus.dart';

class GridItem extends StatelessWidget {
  const GridItem({super.key, required this.data});

  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    final imageName = 'assets/icon_' + data['head'] + '-' + data['tail'] + '.png';

    return SizedBox(
      width: 200,
      height: 320,
      child: GestureDetector(
        onTap: () {
          eventBus.fire(SelectAmiiboEvent(data["id"]));
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: AssetImage(imageName),
              height: 140,
              fit: BoxFit.fitWidth,
            ),
            Text(data['name']),
          ],
        ),
      ),
    );
  }
}

class IconGrid extends StatefulWidget {
  const IconGrid({super.key, required this.contents});

  final List<Map<String, dynamic>> contents;

  @override
  State<IconGrid> createState() => IconGridState();
}

class IconGridState extends State<IconGrid> {
  @override
  Widget build(BuildContext context) {
    final contents = widget.contents;

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 0.618
      ),
      itemCount: contents.length,
      itemBuilder: (context, index){
        return GridItem(data: contents[index]);
      },
    );
  }
}