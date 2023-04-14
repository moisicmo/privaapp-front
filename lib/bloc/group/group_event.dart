part of 'group_bloc.dart';

abstract class GroupEvent extends Equatable {
  const GroupEvent();

  @override
  List<Object> get props => [];
}

class UpdateCiclesTrust extends GroupEvent {
  final List<CircleTrustModel?>? circlesTrust;

  const UpdateCiclesTrust(this.circlesTrust);
}

class ClearCirclesTrust extends GroupEvent {
  const ClearCirclesTrust();
}
