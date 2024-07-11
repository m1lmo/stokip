part of '../sales_view.dart';

class _BottomSheetChild extends StatefulWidget {
  const _BottomSheetChild({
    required this.customers,
    required this.stocks,
    required this.customerDropDownController,
    required this.stockDropDownController,
    required this.stockDetailDropDownController,
    required this.currencyDropDownController,
    required this.quantityController,
    required this.priceController,
    required this.onSave,
  });
  final List<CustomerModel>? customers;
  final List<StockModel>? stocks;
  final SingleValueDropDownController? customerDropDownController;
  final SingleValueDropDownController? stockDropDownController;
  final SingleValueDropDownController? stockDetailDropDownController;
  final SingleValueDropDownController? currencyDropDownController;
  final TextEditingController? quantityController;
  final TextEditingController? priceController;
  final VoidCallback? onSave;

  @override
  State<_BottomSheetChild> createState() => _BottomSheetChildState();
}

class _BottomSheetChildState extends State<_BottomSheetChild> {
  final totalController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    print(CurrencyEnum.values);
    widget.stockDropDownController?.addListener(() {
      if (!mounted) return;
      widget.stockDetailDropDownController?.clearDropDown();
      setState(() {});
    });

    widget.stockDetailDropDownController?.addListener(
      () {
        if (!mounted) return;
        widget.quantityController?.clear();
        setState(() {});
      },
    );

    widget.quantityController?.addListener(() {
      if (!mounted) return;
      setState(() {});
      if (totalResult == null) return;
      totalController.text = totalResult!;
    });
    widget.priceController?.addListener(() {
      if (!mounted) return;
      setState(() {});
      if (totalResult == null) return;
      totalController.text = totalResult!;
    });
  }

  @override
  void dispose() {
    super.dispose();
    totalController.dispose();
  }

  String? get totalResult {
    if (widget.quantityController?.text.isEmpty ?? true) return null;
    if (widget.priceController?.text.isEmpty ?? true) return null;
    final replacedQuantity = widget.quantityController?.text.replaceAll(',', '.');
    final replacedPrice = widget.priceController?.text.replaceAll(',', '.');
    final result = (double.tryParse(replacedQuantity ?? '0') ?? 0) * (double.tryParse(replacedPrice ?? '0') ?? 0);
    return result.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    // if (customers?.isEmpty ?? true) return const SizedBox.shrink();
    // print(stockDropDownController?.dropDownValue);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Form(
        key: formKey,
        child: SafeArea(
          child: Column(
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
                items: (widget.stockDropDownController?.dropDownValue?.value as StockModel?)?.stockDetailModel, // dont modify here
                labelTitle: ProjectStrings.salesStockDetailLabelTitle,
                controller: widget.stockDetailDropDownController,
              ),
              SizedBox(
                height: 2.h,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp('[0-9.,]')),
                      ],
                      validator: (value) {
                        if (value?.isEmpty ?? true) return 'Quantity is required';
                        final newValue = value!.replaceAll(',', '.');
                        final val = double.tryParse(newValue) ?? 0;
                        if (val <= 0) return '0 is not allowed';
                        if (widget.stockDetailDropDownController?.dropDownValue?.value == null) return 'Please select stock detail';
                        if (val > ((widget.stockDetailDropDownController?.dropDownValue?.value as StockDetailModel).meter ?? 0.0)) {
                          return 'Stock is not enough';
                        }
                        return null;
                      },
                      controller: widget.quantityController,
                      decoration: InputDecoration(
                        labelText: 'Quantity',
                        suffix: Text(
                          '${widget.quantityController?.text}/${(widget.stockDetailDropDownController?.dropDownValue?.value as StockDetailModel?)?.meter?.toString() ?? '0'}',
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5.w,
                  ),
                  Expanded(
                    child: TextFormField(
                      validator: (value) {
                        if (value?.isEmpty ?? true) return 'Price is required';
                        return null;
                      },
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      controller: widget.priceController,
                      decoration: const InputDecoration(
                        labelText: 'Price',
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 2.h,
              ),
              Row(
                children: [
                  Expanded(
                    child: DropDownTextField(
                      validator: (value) {
                        if (value?.isEmpty ?? true) return 'Please select currency';
                        return null;
                      },
                      controller: widget.currencyDropDownController,
                      dropDownItemCount: CurrencyEnum.values.length,
                      searchDecoration: InputDecoration(
                        hintText: ProjectStrings.search,
                        contentPadding: EdgeInsets.symmetric(horizontal: 2.w),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(7.sp),
                        ),
                      ),
                      textFieldDecoration: const InputDecoration(
                        labelText: 'Currency',
                      ),
                      listTextStyle: const TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                      listPadding: ListPadding(),
                      padding: EdgeInsets.only(left: 10.w),
                      dropDownList: CurrencyEnum.values.map<DropDownValueModel>((e) {
                        return DropDownValueModel(
                          name: e.getSymbol.toTitleCase(),
                          value: e,
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(
                    width: 5.w,
                  ),
                  Expanded(
                    child: TextField(
                      controller: totalController,
                      canRequestFocus: false,
                      readOnly: true,
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                        labelText: 'Total',
                        floatingLabelStyle: TextStyle(
                          color: ProjectColors2.secondary,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: ProjectColors2.secondary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 3.h,
              ),
              ElevatedButton(
                onPressed: () {
                  formKey.currentState?.validate();
                  if (formKey.currentState?.validate() ?? false) {
                    widget.onSave?.call();
                    Navigator.of(context).pop();
                  }
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(ProjectColors2.primaryContainer),
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.sp),
                    ),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: Text(
                    'Save',
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: Colors.black),
                  ),
                ),
              ),
              SizedBox(
                height: 5.h,
              ),
            ],
          ),
        ),
      ),
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
      validator: (value) {
        if (T == CustomerModel) return null;
        if (value?.isEmpty ?? true) return 'Please select $labelTitle';
        return null;
      },
      controller: controller,
      searchDecoration: InputDecoration(
        hintText: ProjectStrings.search,
        contentPadding: EdgeInsets.symmetric(horizontal: 2.w),
        fillColor: Colors.red,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7.sp),
        ),
      ),
      textFieldDecoration: InputDecoration(
        labelText: labelTitle,
        constraints: BoxConstraints(
          minHeight: 5.h,
          maxHeight: 10.h,
        ),
      ),
      searchTextStyle: const TextStyle(
        fontSize: 14,
        color: Colors.black,
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
