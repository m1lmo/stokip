part of '../products_view.dart';

/// Bottom sheet child used for adding new product to the list
/// in [ProductsView], [_BottomSheetChild] is used in [CustomBottomSheet]
class _BottomSheetChild extends StatelessWidget {
  /// constructor for [_BottomSheetChild]
  const _BottomSheetChild({
    required this.onPressed,
    required this.textEditingController,
    required this.pPriceEditingController,
    required this.sPriceEditingController,
    super.key,
  });
  final VoidCallback? onPressed;
  final TextEditingController textEditingController;
  final TextEditingController pPriceEditingController;
  final TextEditingController sPriceEditingController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 4.h),
          Row(
            children: [
              Expanded(
                child: TextField(
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  controller: textEditingController,
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(RegExp(r'\s')),
                    // FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
                    FilteringTextInputFormatter.deny(RegExp('[0-9]')),
                  ],
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 2.w,
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    floatingLabelStyle: const TextStyle(color: ProjectColors2.primaryContainer),
                    labelStyle: const TextStyle(
                      color: ProjectColors2.grey,
                    ),
                    labelText: 'Product Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: pPriceEditingController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 2.w,
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    floatingLabelStyle: const TextStyle(color: ProjectColors2.primaryContainer),
                    labelStyle: const TextStyle(
                      color: ProjectColors2.grey,
                    ),
                    labelText: 'Alış Fiyatı', // TODOLOCALIZATION
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 2.h),
              Expanded(
                child: TextField(
                  controller: sPriceEditingController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 2.w,
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    floatingLabelStyle: const TextStyle(color: ProjectColors2.primaryContainer),
                    labelStyle: const TextStyle(
                      color: ProjectColors2.grey,
                    ),
                    labelText: 'Satış Fiyatı', // TODOLOCALIZATION
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(ProjectColors2.primaryContainer),
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.sp),
                ),
              ),
            ),
            onPressed: onPressed,
            child: Text(
              'Save',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Colors.black,
                  ),
            ), // TODOLOCALIZATION
          ),
        ],
      ),
    );
  }
}
