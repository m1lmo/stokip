part of '../tabs/customer_tab_view.dart';

class _CustomerListTile extends StatelessWidget {
  const _CustomerListTile({required this.customer, required this.onTap, super.key});
  final CustomerModel customer;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
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
                          customer.title?.toTitleCase() ?? '',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        Text(
                          'Toplam satış: ${customer.boughtProducts?.length ?? 0} ',
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
                          'Bakiye',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        Text(
                          '${customer.balance}${customer.currency.getSymbol}',
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
      ),
    );
  }
}
