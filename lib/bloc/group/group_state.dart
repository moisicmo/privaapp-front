part of 'group_bloc.dart';

class GroupState extends Equatable {
  final List<CircleTrustModel?> listCircleTrust;
  final bool existCirclesTrust;

  const GroupState({this.listCircleTrust = const [], this.existCirclesTrust = false});

  GroupState copyWith({bool? existCirclesTrust, List<CircleTrustModel?>? listCircleTrust}) => GroupState(
      existCirclesTrust: existCirclesTrust ?? this.existCirclesTrust,
      listCircleTrust: listCircleTrust ?? this.listCircleTrust);

  @override
  List<Object> get props => [listCircleTrust, existCirclesTrust];
}
