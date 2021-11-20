import 'package:provider/provider.dart';
import 'package:sewa_mobil/DetailMobil.dart';
import 'package:sewa_mobil/base.dart';
import 'package:sewa_mobil/daftar.dart';
import 'package:sewa_mobil/pembangunan.dart';
import 'package:sewa_mobil/pembayaran.dart';
import 'package:sewa_mobil/profil.dart';
import 'package:sewa_mobil/propertymu.dart';






import 'blocks/baseBloc.dart';
import 'keterangan.dart';
import 'login.dart';
import 'splashScreen.dart';

class GenProvider {
  static var providers = [
    ChangeNotifierProvider<BaseBloc>.value(value: BaseBloc()),

  ];

  static routes(context) {
    return {
//           '/': (context) {
//        return Base();
//      },

      '/': (context) {
        return SplashScreen();
      },

      'splashScreen': (context) {
        return SplashScreen();
      },

      'login': (context) {
        // return Login();
        return Login();
      },

      'daftar': (context) {
        // return Login();
        return Daftar();
      },


      'base': (context) {
        // return Login();
        return Base();
      },


      'pembangunan': (context) {
        return Pembangunan();
      },

      'keterangan': (context) {
        return Keterangan();
      },

      'profil': (context) {
        return Profil();
      },

      'detailMobil': (context) {
        return DetailMobil();
      },

      'pembayaran': (context) {
        return Pembayaran();
      },
    };
  }
}
