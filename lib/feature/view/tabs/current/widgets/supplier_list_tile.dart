part of '../tabs/supplier_tab_view.dart';

class _ImporterListTile extends StatelessWidget {
  const _ImporterListTile({required this.importer, super.key});
  final ImporterModel importer;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 1.h,
        ),
        Row(
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text(
                        importer.title?.toTitleCase() ?? '',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      //todo add this when u make purchase view for user
                      // Text(
                      //   'Toplam satış: 4',
                      //   style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      //         color: Colors.white,
                      //         fontWeight: FontWeight.w300,
                      //       ),
                      // ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        'Bakiye',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      Text(
                        '${importer.balance}${importer.currency?.getSymbol}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w300,
                            ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        'Son Satış',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      Text(
                        '14.08.2024',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w300,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
            ),
          ],
        ),
        SizedBox(
          height: 1.h,
        ),
        CustomDivider.horizontal(width: double.maxFinite, thickness: .1.w),
      ],
    );
  }
}
