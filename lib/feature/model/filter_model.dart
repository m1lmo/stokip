import 'package:equatable/equatable.dart';

import 'package:stokip/product/mixin/filter_mixin.dart';

final class FilterModel<T extends FilterMixin> with EquatableMixin {
  FilterModel({
    required this.filterType,
    required this.isSelected,
  });
  final T filterType;
  bool isSelected;

  @override
  List<Object?> get props => [filterType, isSelected];
}
