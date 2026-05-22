/// move_storage_cubit.dart

import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:homelist/analytics/logger/analytics_logger.dart';
import 'package:homelist/core/localization/locale_keys.dart';
import 'package:homelist/data/models/product_storage/product_storage_cycle.dart';
import 'package:homelist/data/repositories/product_storage_repository.dart';

part 'move_storage_cubit.freezed.dart';
part 'move_storage_state.dart';

class MoveStorageCubit extends Cubit<MoveStorageState> {
  final ProductStorageRepository productStorageRepository;
  final String? storageId;

  MoveStorageCubit(this.productStorageRepository, this.storageId) : super(MoveStorageState.loading()) {
    _init();
  }

  Future<void> _init() async {
    final storage = await productStorageRepository.getStorageById(storageId);

    emit(MoveStorageState.selecting(storageName: storage?.name, selectedStorageId: null));
  }

  void selectStorage(String? storageId) {
    emit(MoveStorageState.selecting(storageName: state.storageName, selectedStorageId: storageId));
  }

  Future<void> moveStorage() async {
    emit(MoveStorageState.loading(storageName: state.storageName, selectedStorageId: state.selectedStorageId));

    final allStorages = await productStorageRepository.productStoragesModels.first;
    final storage = allStorages.firstWhereOrNull((s) => s.storageId == storageId);

    if (storage == null) {
      emit(
        MoveStorageState.error(
          errorMessage: LocaleKeys.error_general.tr(),
          storageName: state.storageName,
          selectedStorageId: state.selectedStorageId,
        ),
      );

      AnalyticsLogger.e(
        message: 'Storage was not found while moving it to another storage',
        stackTrace: StackTrace.current,
        data: {'storageId': storageId},
      );

      return;
    }

    final wouldCreateCycle = wouldMovingStorageUnderParentCreateCycle(
      movingStorageId: storageId!,
      newParentId: state.selectedStorageId,
      storages: allStorages,
    );
    if (wouldCreateCycle) {
      emit(
        MoveStorageState.error(
          errorMessage: LocaleKeys.error_general.tr(),
          storageName: state.storageName,
          selectedStorageId: state.selectedStorageId,
        ),
      );

      AnalyticsLogger.w(
        message: 'Attempted to move storage into its own descendant (cycle)',
        stackTrace: StackTrace.current,
        data: {'storageId': storageId, 'selectedStorageId': state.selectedStorageId},
      );

      emit(MoveStorageState.selecting(storageName: state.storageName, selectedStorageId: state.selectedStorageId));
      return;
    }

    final updatedStorage = storage.copyWith(parentId: state.selectedStorageId);

    try {
      productStorageRepository.saveStorage(updatedStorage);

      emit(MoveStorageState.success(storageName: state.storageName, selectedStorageId: state.selectedStorageId));
    } catch (e) {
      emit(
        MoveStorageState.error(
          errorMessage: LocaleKeys.error_general.tr(),
          storageName: state.storageName,
          selectedStorageId: state.selectedStorageId,
        ),
      );

      AnalyticsLogger.e(
        message: 'Error moving storage to another storage',
        stackTrace: StackTrace.current,
        error: e,
        data: {'storageId': storageId, 'selectedStorageId': state.selectedStorageId},
      );

      emit(MoveStorageState.selecting(storageName: state.storageName, selectedStorageId: state.selectedStorageId));
    }
  }
}


/// move_storage_state.dart

part of 'move_storage_cubit.dart';

@freezed
abstract class MoveStorageState with _$MoveStorageState {
  const factory MoveStorageState.loading({String? storageName, String? selectedStorageId}) = _Loading;

  const factory MoveStorageState.selecting({required String? storageName, required String? selectedStorageId}) =
      _Selecting;

  const factory MoveStorageState.success({required String? storageName, required String? selectedStorageId}) = _Success;

  const factory MoveStorageState.error({
    required String? storageName,
    required String? selectedStorageId,
    required String errorMessage,
  }) = _Error;
}


