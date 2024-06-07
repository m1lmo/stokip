// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sales_view_model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$SalesViewModel on _SalesVievModelBase, Store {
  late final _$filtersAtom =
      Atom(name: '_SalesVievModelBase.filters', context: context);

  @override
  ObservableList<FilterModel<SalesFilterEnum>> get filters {
    _$filtersAtom.reportRead();
    return super.filters;
  }

  @override
  set filters(ObservableList<FilterModel<SalesFilterEnum>> value) {
    _$filtersAtom.reportWrite(value, super.filters, () {
      super.filters = value;
    });
  }

  late final _$_SalesVievModelBaseActionController =
      ActionController(name: '_SalesVievModelBase', context: context);

  @override
  void init(BuildContext context) {
    final _$actionInfo = _$_SalesVievModelBaseActionController.startAction(
        name: '_SalesVievModelBase.init');
    try {
      return super.init(context);
    } finally {
      _$_SalesVievModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void sortFilters() {
    final _$actionInfo = _$_SalesVievModelBaseActionController.startAction(
        name: '_SalesVievModelBase.sortFilters');
    try {
      return super.sortFilters();
    } finally {
      _$_SalesVievModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void selectFilter(FilterModel<SalesFilterEnum> filter) {
    final _$actionInfo = _$_SalesVievModelBaseActionController.startAction(
        name: '_SalesVievModelBase.selectFilter');
    try {
      return super.selectFilter(filter);
    } finally {
      _$_SalesVievModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
filters: ${filters}
    ''';
  }
}
