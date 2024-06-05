part of '../sales_view.dart';

class _BottomSheetChild extends StatelessWidget {
  const _BottomSheetChild({required this.customers, super.key});
  final List<CustomerModel> customers;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // TODOradio button
        SizedBox(
          height: 2.h,
        ),
        DropDownTextField(
          dropDownList: customers.map<DropDownValueModel>((e) {
            return DropDownValueModel(
              name: e.title ?? 'Cari ismi',
              value: e,
            );
          }).toList(),
        ),
      ],
    );
  }
}
