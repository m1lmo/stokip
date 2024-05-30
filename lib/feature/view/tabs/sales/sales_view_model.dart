import 'package:mobx/mobx.dart';
import 'package:stokip/feature/model/filter_model.dart';
import 'package:stokip/product/constants/enums/sales_filter_enum.dart';
part 'sales_view_model.g.dart';

class SalesViewModel = _SalesVievModelBase with _$SalesViewModel;

abstract class _SalesVievModelBase with Store {
  @observable
  ObservableList<FilterModel<SalesFilterEnum>> filters = ObservableList.of(SalesFilterEnum.values.map((e) => FilterModel<SalesFilterEnum>(filterType: e, isSelected: false)));

  @action
  void sortFilters() {
    filters.replaceRange(0, filters.length, filters);
    filters.sort((a, b) {
      if (a.isSelected && !b.isSelected) {
        return -1;
      } else if (!a.isSelected && b.isSelected) {
        return 1;
      } else {
        return 0;
      }
    });
  }

  @action
  void selectFilter(FilterModel<SalesFilterEnum> filter) {
    final index = filters.indexWhere((element) => element == filter);
    filters[index].isSelected = !filters[index].isSelected;
    sortFilters();
  }
}
