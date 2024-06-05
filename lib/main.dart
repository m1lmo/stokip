import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:stokip/product/constants/locales_consts.dart';
import 'package:stokip/feature/view/home_view.dart';
import 'package:stokip/product/constants/project_colors.dart';
// homeview da 4 tabli bi sayfa sayfalar dashboard, sales, purchase, products olucak
// productsda StockModel içeren ürünler olucak bu ürünlerin fiyatını alış ve satış olarak görmek mümkün hangi renkten kaç metre var
// bi de dashboardta satış ve alışlara göre artan ve azalan grafik yapıcam yapabilirsem
// https://dribbble.com/shots/20295444-Dashboard-Responsive-Inventory-Management-System örneği var burda çok gözükmüyor ama tasarım açısından bi ön ayak olur
// https://dribbble.com/shots/14782920-Stockey-Stock-Management-App-Design
//  productsviewda info kısmı yapmak istiyorum tüm malzemelerin toplam stoğu gözükmesi |√|
//  iosda navigatorpop butonun kulanmadan sayfayı geri gidince (kaydırınca) state güncellenmiyor çünkü navigatorpop işlevini yapan butona basmamış oluyoru<z |√|
//  herhangi bi tabda textfieldı açıp keyboardı açınca 1.tabe geçiş yapıyor buna bak https://github.com/flutter/flutter/issues/55571 burda çözüm deniyor ama tam anlıyamadım yarın bak [√]
//  salesview daa satış yapılan buttonda addSales methodunu sold methodunun içine entegre et  [√]
//  satış yapılan ürünü ne kadar sattığını yazmayı getir[√]
//  cubitte sold methodunda ürünün olup olmadığını kontrol eden logici methoda çıkar [√]
// satışları aylara böl [√]
///  costumer view ı Importercubitte database olarak hive i entegre et yine key olarak model içinde id tut[√]
///  purchase i costumer yaptım içinde ImporterModel alan bi lwb alıcak list tile yapısıyla bu modeli displayle showModalBottomsheeti güzel yap stok ekleme ve customerda kullan [√]
//  getProductı productsDetailViewin ekleme butonundan sildim şuanlık bi sorun yok ama eğer kulalnıcı ürünü ekleyip çıkış yaptığında sorun yaşanabilir bunu gözden geçir [√]
///  suppliers viewda carilerin bilançosunu göster currency enum olarak currency yi displayle bilançonun yanına [√]
///  modele tıklandığınya yeni bi view yapıp o viewda ödemeler gibi bi ui tasarla [√]
/// products viewda ürün eklerken bastımmız bottom sheet açıldığında geri kapanmıyor kapatmak için tab i değiştirmek gerekiyor buna bi bak [√] (showBottomSheete generic type a geri döndürülemeyen widget verdiğim için oluyormuş)
/// supplier kısmındaki tedarikçiden item satın alınca sayfadaki tedarikciye olan borç değişmiyor[√]
///  dashboardda toplam satışlar ve alışları tutan bi ui yap [√]
///  products viewda toplam ürünlerin ve toplam stoğun gözüktüğü yeri animated container ile yönet [√]

// TODOpurchase view da carilerin profil fotoğraflarını koyarken image_cropper ekle []
// TODOnamed navigator yap [√] yaptım ama daha fazla nasıl geliştirebilirim ona çalış []
// TODOsuppliers viewda ödeme yapılınca ödemelerin tarihi ve ne kadar ödeme yapıldığı gözüksün aklımda purchasesListesinde görünebilir diye düsünüyorum []

void main() async {
  await init();
  runApp(
    EasyLocalization(
      supportedLocales: LocaleConstant.supportedLocales,
      path: LocaleConstant.langPath,
      child: const MyApp(),
    ),
  );
}

Future<void> init() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          theme: ThemeData.dark().copyWith(
            primaryColor: Colors.blueGrey.shade900,
            scaffoldBackgroundColor: const Color(0xFF001F26),
            tabBarTheme: const TabBarTheme(
              labelColor: Colors.white,
              unselectedLabelColor: Colors.black,
              indicatorColor: ProjectColors2.primaryContainer,
              dividerColor: Colors.transparent,
            ),
            appBarTheme: AppBarTheme(
              titleTextStyle: TextStyle(
                color: ProjectColors2.primaryContainer,
                fontSize: 24.sp,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold,
              ),
              backgroundColor: Colors.black.withOpacity(.4),
              elevation: 0,
              actionsIconTheme: const IconThemeData(
                color: ProjectColors2.primaryContainer,
              ),
              centerTitle: true,
            ),
            bottomAppBarTheme: BottomAppBarTheme.of(context).copyWith(
              color: ProjectColors2.primary,
            ),
            textTheme: TextTheme(
              ///mont serrat bold 30sp
              headlineLarge: TextStyle(
                color: Colors.white,
                fontSize: 24.sp,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold,
              ),
              headlineMedium: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w700,
              ),

              ///mont serrat bold 30sp
              bodyMedium: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontFamily: 'Montserrat',
              ),

              ///mont serrat medium 18sp
              bodyLarge: TextStyle(fontSize: 18.sp, fontFamily: 'Montserrat', fontWeight: FontWeight.w500),

              ///mont serrat light 12sp
              bodySmall: TextStyle(
                color: ProjectColors2.primaryContainer,
                fontSize: 12.sp,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w200,
              ),
            ),

            ///input decoration theme
            inputDecorationTheme: InputDecorationTheme(
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(7.sp),
                borderSide: const BorderSide(
                  color: ProjectColors2.secondary,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(7.sp),
                borderSide: const BorderSide(
                  color: ProjectColors2.primaryContainer,
                ),
              ),
              contentPadding: EdgeInsets.zero,
              hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: ProjectColors2.secondary,
                    fontSize: 12.sp,
                  ),
            ),
          ),
          home: const HomeView(),
        );
      },
    );
  }
}
