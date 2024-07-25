import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';
import 'package:stokip/feature/cubit/customers/cubit/customer_cubit.dart';
import 'package:stokip/feature/cubit/importers/importer_cubit.dart';
import 'package:stokip/feature/cubit/stock/stock_cubit.dart';
import 'package:stokip/feature/model/customer_model.dart';
import 'package:stokip/feature/model/importer_model.dart';
import 'package:stokip/feature/view/tabs/current/tabs/customer_tab_view.dart';
import 'package:stokip/feature/view/tabs/current/tabs/supplier_tab_view.dart';
import 'package:stokip/product/constants/enums/currency_enum.dart';
import 'package:stokip/product/constants/enums/current_tabs_enum.dart';
import 'package:stokip/product/constants/enums/images_enum.dart';
import 'package:stokip/product/constants/project_colors.dart';
import 'package:stokip/product/constants/project_strings.dart';
import 'package:stokip/product/extensions/currency_enum_extension.dart';
import 'package:stokip/product/extensions/current_tabs_extension.dart';
import 'package:stokip/product/image_picker_manager.dart';
import 'package:stokip/product/navigator_manager.dart';
import 'package:stokip/product/widgets/custom_bottom_sheet.dart';

part './widgets/bottom_sheet_child.dart';

class CurrentView extends StatefulWidget {
  const CurrentView({super.key});

  @override
  State<CurrentView> createState() => _CurrentViewState();
}

class _CurrentViewState extends State<CurrentView> with TickerProviderStateMixin, NavigatorManager {
  late final TabController _tabController;
  late final TextEditingController searchController;
  final currentTitleController = TextEditingController();
  final currentBalanceController = TextEditingController();
  final currentCurrencyController = SingleValueDropDownController();
  final formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: CurrentTabsEnum.values.length);
    searchController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
    searchController.dispose();
    currentTitleController.dispose();
    currentBalanceController.dispose();
    currentCurrencyController.dispose();
    formKey.currentState?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final stockCubit = BlocProvider.of<StockCubit>(context);
    final importerCubit = BlocProvider.of<ImporterCubit>(context);
    final customerCubit = BlocProvider.of<CustomerCubit>(context);
    return MultiBlocProvider(
      providers: [
        BlocProvider<StockCubit>.value(value: stockCubit),
        BlocProvider<ImporterCubit>.value(value: importerCubit),
        BlocProvider<CustomerCubit>.value(value: customerCubit),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            ProjectStrings.currentAppBarTitle,
          ),
          actions: const [],
        ),
        body: Column(
          children: [
            TabBar(
              controller: _tabController,
              labelColor: ProjectColors2.primaryContainer,
              indicatorColor: ProjectColors2.primaryContainer,
              unselectedLabelColor: Colors.white,
              tabs: CurrentTabsEnum.values.map((e) {
                return Tab(
                  text: e.tabTitle,
                  icon: e.getIcon,
                );
              }).toList(),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  CustomerTabView(
                    controller: searchController,
                    customerCubit: customerCubit,
                    currentListTileOnTap: () {},
                    showBottomSheetPressed: () => CustomBottomSheet.show(
                      context,
                      title: 'Alıcı Ekle',
                      child: _BottomSheetChild(
                        titleController: currentTitleController,
                        balanceController: currentBalanceController,
                        currencyController: currentCurrencyController,
                        formKey: formKey,
                        onSave: () {
                          formKey.currentState?.validate();
                          customerCubit.addCustomer(
                            CustomerModel(
                              id: customerCubit.state.id ?? 0,
                              title: currentTitleController.text.toLowerCase(),
                              balance: double.parse(currentBalanceController.text.toLowerCase()),
                              currency: currentCurrencyController.dropDownValue?.value as CurrencyEnum,
                            ),
                            context,
                          );
                        },
                      ),
                    ),
                  ),
                  SupplierTabView(
                    importerCubit: importerCubit,
                    searchController: searchController,
                    showBottomSheetPressed: () {
                      CustomBottomSheet.show(
                        context,
                        child: _BottomSheetChild(
                          titleController: currentTitleController,
                          balanceController: currentBalanceController,
                          currencyController: currentCurrencyController,
                          formKey: formKey,
                          onSave: () {
                            formKey.currentState?.validate();
                            importerCubit.addImporter(
                              context,
                              this,
                              model: ImporterModel(
                                id: importerCubit.state.importerId,
                                title: currentTitleController.text.toLowerCase(),
                                balance: double.parse(currentBalanceController.text.toLowerCase()),
                                currency: currentCurrencyController.dropDownValue?.value as CurrencyEnum,
                              ),
                            );
                          },
                        ),
                        title: 'Tedarikçi Ekle',
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ImporterAvatar extends StatelessWidget {
  const _ImporterAvatar(
    this.state,
    this.index,
  );
  final ImporterState state;
  final int index;

  CircleAvatar get _userAvatar {
    if (state.importers?[index].customerPhoto == null) {
      return CircleAvatar(
        backgroundImage: ImagesEnum.defaul.getImages(null),
      );
    } else {
      return CircleAvatar(
        backgroundImage: ImagesEnum.selected.getImages(state.importers?[index].customerPhoto),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () async {
        try {
          final response = await ImageUploadManager().fetchFromLibrary();
          if (response != null) {
            final croppedImage = await ImageCropper().cropImage(
              sourcePath: response.path,
            );
            if (croppedImage != null) {
              final croppedXFile = XFile(croppedImage.path);
              context.read<ImporterCubit>().saveFileToLocale(croppedXFile, index);
            } else {}
          }
        } catch (e) {
          print('Hata: $e');
        }
      },
      child: _userAvatar,
    );
  }
}
