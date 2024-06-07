part of '../sales_view.dart';

class _BottomSheetChild extends StatefulWidget {
  const _BottomSheetChild({
    required this.customers,
    required this.stocks,
    required this.customerDropDownController,
    required this.stockDropDownController,
    required this.stockDetailDropDownController,
  });
  final List<CustomerModel>? customers;
  final List<StockModel>? stocks;
  final SingleValueDropDownController? customerDropDownController;
  final SingleValueDropDownController? stockDropDownController;
  final SingleValueDropDownController? stockDetailDropDownController;

  @override
  State<_BottomSheetChild> createState() => _BottomSheetChildState();
}

class _BottomSheetChildState extends State<_BottomSheetChild> {
  @override
  void initState() {
    super.initState();
    widget.stockDropDownController?.addListener(() {
      widget.stockDetailDropDownController?.clearDropDown();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    // if (customers?.isEmpty ?? true) return const SizedBox.shrink();
    // print(stockDropDownController?.dropDownValue);
    return Column(
      children: [
        // TODOradio button isCash or openBalance
        SizedBox(
          height: 2.h,
        ),
        _DropDownTextField<CustomerModel>(
          items: widget.customers,
          labelTitle: ProjectStrings.salesCustomerLabelTitle,
          controller: widget.customerDropDownController,
        ),
        SizedBox(
          height: 2.h,
        ),
        _DropDownTextField(
          items: widget.stocks,
          labelTitle: ProjectStrings.salesStockLabelTitle,
          controller: widget.stockDropDownController,
        ),
        SizedBox(
          height: 2.h,
        ),
        _DropDownTextField(
          items: (widget.stockDropDownController?.dropDownValue?.value as StockModel?)?.stockDetailModel,
          labelTitle: ProjectStrings.salesStockDetailLabelTitle,
          controller: widget.stockDetailDropDownController,
        ),
      ],
    );
  }
}

class _DropDownTextField<T extends MainModel> extends StatelessWidget {
  const _DropDownTextField({
    required this.items,
    required this.labelTitle,
    this.controller,
    super.key,
  });

  final List<T>? items;
  final String labelTitle;
  final SingleValueDropDownController? controller;

  @override
  Widget build(BuildContext context) {
    return DropDownTextField(
      controller: controller,
      dropDownItemCount: items?.length ?? 0,
      searchDecoration: InputDecoration(
        hintText: ProjectStrings.search,
        contentPadding: EdgeInsets.symmetric(horizontal: 2.w),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(2.sp),
        ),
      ),
      textFieldDecoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 2.w),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        floatingLabelStyle: const TextStyle(
          color: ProjectColors2.primaryContainer,
        ),
        labelStyle: const TextStyle(
          color: ProjectColors2.grey,
        ),
        labelText: labelTitle,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          gapPadding: 10.w,
        ),
      ),
      enableSearch: true,
      listTextStyle: const TextStyle(
        fontSize: 14,
        color: Colors.black,
      ),
      listPadding: ListPadding(),
      padding: EdgeInsets.only(left: 10.w),
      dropDownList: items?.map<DropDownValueModel>((e) {
            return DropDownValueModel(
              name: e.title?.toTitleCase() ?? '',
              value: e,
            );
          }).toList() ??
          [],
    );
  }
}
