// ignore_for_file: public_member_api_docs, sort_constructors_first
part of '../products_detail_view.dart';

/// Bottom sheet child used for adding new product to the list
/// in [ProductsView], [BottomSheetChild] is used in [CustomBottomSheet]
class BottomSheetChild extends StatelessWidget {
  /// constructor for [BottomSheetChild]
  BottomSheetChild({
    required this.onPressed,
    required this.productDetailController,
    required this.quantityController,
    super.key,
  });
  final VoidCallback? onPressed;
  final TextEditingController productDetailController;
  final formKey = GlobalKey<FormState>();
  final TextEditingController quantityController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 4.h),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    validator: (value) {
                      if (value?.isEmpty ?? true) return 'Please fill';
                      return null;
                    },
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    controller: productDetailController,
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(RegExp(r'\s')),
                      // FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
                      FilteringTextInputFormatter.deny(RegExp('[0-9]')),
                    ],
                    decoration: InputDecoration(
                      labelText: 'Color Name', // TODOLOCALIZATION
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.sp),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 50.w,
                  child: TextFormField(
                    validator: (value) {
                      if (value?.isEmpty ?? true) return 'Please fill';
                      return null;
                    },
                    controller: quantityController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Miktar', // TODOLOCALIZATION
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.sp),
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
              onPressed: () {
                formKey.currentState?.validate();
                if (formKey.currentState?.validate() ?? false) {
                  onPressed?.call();
                  Navigator.of(context).pop();
                }
              },
              child: Text(
                'Save',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Colors.black,
                    ),
              ), // TODOLOCALIZATION
            ),
            SizedBox(
              height: 5.h,
            ),
          ],
        ),
      ),
    );
  }
}
