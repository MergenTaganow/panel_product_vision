part of 'snack_bar_cubit.dart';

@immutable
sealed class SnackBarState {}

final class SnackBarInitial extends SnackBarState {}

final class ShowSnackBar extends SnackBarState {
  final String title;
  final bool isError;
  ShowSnackBar(this.title, this.isError);
}
