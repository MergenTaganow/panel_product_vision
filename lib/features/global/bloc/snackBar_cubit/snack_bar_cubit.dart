import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'snack_bar_state.dart';

class SnackBarCubit extends Cubit<SnackBarState> {
  SnackBarCubit() : super(SnackBarInitial());

  showSnackBar(String title, bool isError) {
    emit(ShowSnackBar(title, isError));
  }
}
