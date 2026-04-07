part of 'update_cubit.dart';

@immutable
sealed class UpdateState {}

final class UpdateInitial extends UpdateState {}

final class UpToDate extends UpdateState {}

final class NeedUpdate extends UpdateState {
  final LastVersion lastVersion;

  NeedUpdate({required this.lastVersion});
}
