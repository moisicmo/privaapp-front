import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:privaap/models/circle_trust_model.dart';

part 'group_event.dart';
part 'group_state.dart';

class GroupBloc extends Bloc<GroupEvent, GroupState> {
  GroupBloc() : super(const GroupState()) {
    on<UpdateCiclesTrust>(
        (event, emit) => emit(state.copyWith(existCirclesTrust: true, listCircleTrust: event.circlesTrust)));
    on<ClearCirclesTrust>((event, emit) => emit(state.copyWith(existCirclesTrust: false)));
  }
}
