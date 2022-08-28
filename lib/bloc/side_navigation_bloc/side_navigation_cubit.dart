import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../enums/pages_enum.dart';

part 'side_navigation_state.dart';

class SideNavigationCubit extends Cubit<SideNavigationState> {
  SideNavigationCubit() : super(const SideNavigationInitial());

  void selectDestination(int index) {
    emit(SideNavigationState(PageNavigation.values[index]));
  }
}
