part of 'home_content_cubit.dart';

class HomeContentState extends Equatable {
  final HomeContentSection section;

  const HomeContentState(this.section);

  @override
  List<Object> get props => [section];
}

class HomeContentInitial extends HomeContentState {
  const HomeContentInitial() : super(HomeContentSection.recentlyPlayed);
}
