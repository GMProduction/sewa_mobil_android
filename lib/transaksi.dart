// ignore: file_names
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sewa_mobil/pembayaran.dart';

import 'blocks/baseBloc.dart';
import 'component/NavDrawer.dart';
import 'component/commonPadding.dart';
import 'component/genColor.dart';
import 'component/genRadioMini.dart';
import 'component/genShadow.dart';
import 'component/genText.dart';
import 'component/request.dart';
import 'component/textAndTitle.dart';

class Transaksi extends StatefulWidget {
  @override
  _TransaksiState createState() => _TransaksiState();
}

class _TransaksiState extends State<Transaksi> with WidgetsBindingObserver {
  Map dunmmyProfil = {
    "nama": "Colleen Alexander",
    "medal": 0,
    "koin": 0,
    "level": 0,
    "xp": 0,
    "up-level": 1000,
    "foto":
        "https://i1.hdslb.com/bfs/archive/1c619fbdf3fb4a2171598e17b7bee680d5fab2ff.png"
  };

  final req = new GenRequest();

  List listData = [
    {"id": 1, "hari": "senin"},
    {"id": 2, "hari": "selasa"},
    {"id": 3, "hari": "rabu"},
    {"id": 4, "hari": "kamis"},
    {"id": 5, "hari": "jumat"},
    {"id": 6, "hari": "sabtu"},
  ];

  List dummyPromo = [
//    {
//      "image":
//          "https://i2.wp.com/quipperhome.wpcomstaging.com/wp-content/uploads/2018/08/790e6-ini-dia-9-tipe-guru-di-sekolah-yang-akan-kamu-temui.png"
//    },
//    {
//      "image":
//          "https://i2.wp.com/quipperhome.wpcomstaging.com/wp-content/uploads/2018/08/790e6-ini-dia-9-tipe-guru-di-sekolah-yang-akan-kamu-temui.png"
//    },
//    {
//      "image":
//          "https://i2.wp.com/quipperhome.wpcomstaging.com/wp-content/uploads/2018/08/790e6-ini-dia-9-tipe-guru-di-sekolah-yang-akan-kamu-temui.png"
//    },
//    {
//      "image":
//          "https://i2.wp.com/quipperhome.wpcomstaging.com/wp-content/uploads/2018/08/790e6-ini-dia-9-tipe-guru-di-sekolah-yang-akan-kamu-temui.png"
//    },
  ];

//  VARIABEL

  bool loading = false;

  // NotifBloc notifbloc;
  bool isLoaded = false;

//  double currentgurulainValue = 0;
  PageController gurulainController = PageController();
  var stateMetodBelajar = 1;
  var bloc;
  var clientId;
  var stateHari;
  var kelas;
  dynamic dataJadwal;
  var dataTrans;

  @override
  void initState() {
    // TODO: implement initState
    // analytics.
    getTransaksi();

    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

//  FUNCTION

  String clienId;

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);

    // notifbloc.dispose();
    // bloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: GenColor.primaryColor, // status bar color
    ));

    ScreenUtil.init(
        BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height),
        designSize: Size(360, 690),
        orientation: Orientation.portrait);
    bloc = Provider.of<BaseBloc>(context);
    // notifbloc = Provider.of<NotifBloc>(context);

    // sendAnalyticsEvent(testLogAnalytic);
    // print("anal itik "+testLogAnalytic);

    if (!isLoaded) {
      isLoaded = true;
    }

    // notifbloc.getTotalNotif();

    // bloc.util.getActiveOnline();
    // bloc.util.getNotifReview();

    // bloc.util.getRekomendasiAll("district", "level", 1, "limit", "offset");

    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: GenColor.primaryColor,
        elevation: 0,
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  // Navigator.pushNamed(context, "notifikasi", arguments: );
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.notifications,
                      size: 26.0,
                    ),
                  ],
                ),
              )),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 50,
            ),
            CommonPadding(
                child: GenText(
              "Transaksi Anda",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            )),
            SizedBox(
              height: 20,
            ),
            Expanded(
                child: dataTrans == null
                    ? Container()
                    : dataTrans.length == 0
                        ? Center(
                            child: GenText("TIdak ada mobil tersedia"),
                          )
                        : SingleChildScrollView(
                            child: Column(
                            children: dataTrans.map<Widget>((e) {
                              return CommonPadding(
                                child: InkWell(
                                  onTap: (){
                                    if(e["status"] == 0){
                                      Navigator.pushReplacementNamed(context, "pembayaran",
                                          arguments: Pembayaran(id: e["id"]));
                                    }
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    margin: EdgeInsets.only(bottom: 20),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(5),
                                        boxShadow: GenShadow().genShadow(
                                            radius: 3.w, offset: Offset(0, 2.w))),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Image.network(
                                          ip + e["harga"]["mobil"]["image"].toString(),
                                          height: 150,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        CommonPadding(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              GenText(
                                                e["harga"]["mobil"]["nama"],
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                              GenText(e["harga"]["mobil"]["no_pol"]),
                                              GenText(e["harga"]["mobil"]["tahun"].toString()),
                                              GenText(e["harga"]["mobil"]["keterangan"]),
                                              SizedBox(height: 20),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  GenText(e["tanggal_pinjam"]),
                                                  GenText(e["status"] == 0 ? "Menunggu Pembayaran" : e["status"] == 1 ? "Menunggu Diambil" : e["status"] == 3 ? "Selesai" : e["status"] == 11 ? "Menunggu Konfirmasi" : "Dipinjam"),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          )))
          ],
        ),
      ),
    );
  }

  void getTransaksi() async {
    dataTrans = await req.getApi("transaksi");

    print("DATA $dataTrans");
    print("length" + dataTrans.length.toString());

    setState(() {});
  }
}
