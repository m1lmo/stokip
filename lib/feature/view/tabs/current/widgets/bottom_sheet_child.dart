part of '../current_view.dart';

class _BottomSheetChild extends StatelessWidget {
  const _BottomSheetChild({required this.titleController, required this.balanceController, required this.currencyController, required this.formKey, super.key, this.onSave});
  final TextEditingController titleController;
  final TextEditingController balanceController;
  final SingleValueDropDownController currencyController;
  final GlobalKey<FormState> formKey;
  final VoidCallback? onSave;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Column(
          children: [
            SizedBox(
              height: 2.h,
            ),
            TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Lütfen cari adını giriniz';
                }
                return null;
              },
              textInputAction: TextInputAction.next,
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Cari adı',
              ),
            ),
            SizedBox(
              height: 2.h,
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: balanceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Bakiye',
                    ),
                  ),
                ),
                SizedBox(
                  width: 5.w,
                ),
                Expanded(
                  child: DropDownTextField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Lütfen para birimini seçiniz';
                      }
                      return null;
                    },
                    controller: currencyController,
                    dropDownList: CurrencyEnum.values.map((e) => DropDownValueModel(name: e.getSymbol, value: e)).toList(),
                    textFieldDecoration: InputDecoration(
                      labelText: 'Para Birimi',
                      contentPadding: EdgeInsets.symmetric(horizontal: 2.w),
                    ),
                    listTextStyle: const TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 3.h),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState?.validate() ?? false) {
                  onSave?.call();
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
    );
  }
}
