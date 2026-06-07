import '../Model/ReelModel.dart';

abstract class ReelState {}

class ReelInitial extends ReelState {}

class ReelLoading extends ReelState {}

class ReelLoaded extends ReelState {
  final List<ReelModel> reels;
  ReelLoaded(this.reels);
}

class ReelFailure extends ReelState {
  final String message;
  ReelFailure(this.message);
}

class ReelActionInProgress extends ReelState {
  final List<ReelModel> reels;
  ReelActionInProgress(this.reels);
}
