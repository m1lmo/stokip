part of '../products_detail_view.dart';

class MergedCustomContainer extends StatelessWidget {
  const MergedCustomContainer({
    required this.stockModel,
    super.key,
  });
  final StockModel stockModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: 7.h,
      decoration: BoxDecoration(
        color: ProjectColors2.secondaryContainer,
        borderRadius: BorderRadius.circular(15.sp),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              CustomIcons.pen_edit,
              color: ProjectColors2.primaryContainer,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                stockModel.sPrice != null ? '${stockModel.sPrice}${stockModel.currency.getSymbol}' : '--',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontSize: 12.sp),
              ),
              Text(
                'Satış Fiyatı',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 10.sp),
              ),
            ],
          ),
          // NewWidget(),
          CustomDivider.vertical(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                stockModel.pPrice != null ? '${stockModel.pPrice}${stockModel.currency.getSymbol}' : '--',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontSize: 12.sp),
              ),
              Text(
                'Alış Fiyatı',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 10.sp),
              ),
            ],
          ),
          IconButton(
            onPressed: () {},
            icon: const RotatedBox(
              quarterTurns: 3,
              child: Icon(
                CustomIcons.pen_edit,
                color: ProjectColors2.primaryContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomDividerHorizontal extends StatelessWidget {
  const CustomDividerHorizontal({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 1.w,
      height: 4.h,
      child: Center(
        child: Container(
          margin: const EdgeInsetsDirectional.only(start: 1, end: 1),
          decoration: BoxDecoration(
            color: ProjectColors2.primaryContainer,
            borderRadius: BorderRadius.circular(10.sp),
          ),
        ),
      ),
    );
  }
}
