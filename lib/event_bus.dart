import 'package:event_bus/event_bus.dart';

EventBus eventBus = EventBus();

class SelectTitleEvent {
  String title;

  SelectTitleEvent(this.title);
}

class SelectAmiiboEvent {
  int index;

  SelectAmiiboEvent(this.index);
}