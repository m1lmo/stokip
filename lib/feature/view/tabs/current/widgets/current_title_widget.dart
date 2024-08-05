import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:stokip/feature/model/customer_model.dart';
import 'package:stokip/feature/model/importer_model.dart';
import 'package:stokip/feature/model/stock_model.dart';
import 'package:stokip/product/extensions/string_extension.dart';

/// T SHOULD BE customermode or importermodel
class CurrentTitleWidget<T extends MainModel> extends StatelessWidget {
  const CurrentTitleWidget({
    required this.customer,
    super.key,
  });

  final T customer;

  @override
  Widget build(BuildContext context) {
    if (T != CustomerModel && T != ImporterModel) {
      throw Exception('CurrentTitleWidget can only be used with CustomerModel or ImporterModel');
    }
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: 30.w,
        minWidth: 30.w,
      ),
      child: Tooltip(
        message: customer.title?.toTitleCase(),
        child: Text(
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          customer.title?.toTitleCase() ?? '',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
    );
  }
}
