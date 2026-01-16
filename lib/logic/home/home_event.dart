abstract class HomeEvent {}

class TabChanged extends HomeEvent {
  final int index;
  TabChanged(this.index);
}
