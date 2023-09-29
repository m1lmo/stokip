import 'package:flutter/material.dart';
import 'feature/view/home_view.dart';
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

/// todo purchase view da carilerin profil fotoğraflarını koyarken image_cropper ekle []
/// todo named navigator yap [√] yaptım ama daha fazla nasıl geliştirebilirim ona çalış []
/// todo suppliers viewda ödeme yapılınca ödemelerin tarihi ve ne kadar ödeme yapıldığı gözüksün aklımda purchasesListesinde görünebilir diye düsünüyorum []

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light().copyWith(
        primaryColor: Colors.blueGrey.shade900,
      ),
      home: const HomeView(),
    );
  }
}
