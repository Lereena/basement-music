part of 'side_navigation_cubit.dart';

class SideNavigationState extends Equatable {
  final PageNavigation selectedPage;

  const SideNavigationState(this.selectedPage);

  @override
  List<Object> get props => [selectedPage];
}

class SideNavigationInitial extends SideNavigationState {
  const SideNavigationInitial() : super(PageNavigation.allTracks);
}
