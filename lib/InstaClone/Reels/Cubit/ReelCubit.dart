import 'package:flutter_bloc/flutter_bloc.dart';
import '../Model/ReelModel.dart';
import '../Repository/ReelRepository.dart';
import 'ReelState.dart';

class ReelCubit extends Cubit<ReelState> {
  final ReelRepository _repository;

  ReelCubit(this._repository) : super(ReelInitial());

  List<ReelModel> get _currentReels =>
      state is ReelLoaded ? (state as ReelLoaded).reels : [];

  Future<void> loadReels() async {
    emit(ReelLoading());
    try {
      final reels = await _repository.loadReels();
      emit(ReelLoaded(reels));
    } catch (e) {
      emit(ReelFailure('Failed to load reels: ${e.toString()}'));
    }
  }

  Future<void> toggleLike(String reelId, String userId) async {
    final reels = List<ReelModel>.from(_currentReels);
    emit(ReelActionInProgress(reels));
    try {
      final updated = await _repository.toggleLike(reelId, userId);
      final index = reels.indexWhere((r) => r.id == reelId);
      if (index != -1) reels[index] = updated;
      emit(ReelLoaded(reels));
    } catch (e) {
      emit(ReelLoaded(reels));
    }
  }

  Future<void> addComment({
    required String reelId,
    required String userId,
    required String username,
    required String text,
  }) async {
    final reels = List<ReelModel>.from(_currentReels);
    emit(ReelActionInProgress(reels));
    try {
      final updated = await _repository.addComment(
        reelId: reelId,
        userId: userId,
        username: username,
        text: text,
      );
      final index = reels.indexWhere((r) => r.id == reelId);
      if (index != -1) reels[index] = updated;
      emit(ReelLoaded(reels));
    } catch (e) {
      emit(ReelLoaded(reels));
    }
  }
}
