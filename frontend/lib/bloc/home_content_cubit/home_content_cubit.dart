import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'home_content_state.dart';

enum HomeContentSection { recentlyPlayed, newUploads }

class HomeContentCubit extends Cubit<HomeContentState> {
  HomeContentCubit() : super(const HomeContentInitial());

  void selectSection(HomeContentSection destination) {
    emit(HomeContentState(destination));
  }
}
