// ignore: file_names
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sewa_mobil/DetailMobil.dart';

import 'blocks/baseBloc.dart';
import 'component/NavDrawer.dart';
import 'component/commonPadding.dart';
import 'component/genColor.dart';
import 'component/genRadioMini.dart';
import 'component/genShadow.dart';
import 'component/genText.dart';
import 'component/request.dart';
import 'component/textAndTitle.dart';

class Beranda extends StatefulWidget {
  @override
  _BerandaState createState() => _BerandaState();
}

class _BerandaState extends State<Beranda> with WidgetsBindingObserver {


  final req = new GenRequest();

//  VARIABEL

  bool loading = false;

  // NotifBloc notifbloc;
  bool isLoaded = false;

//  double currentgurulainValue = 0;
  PageController gurulainController = PageController();
  var stateMetodBelajar = 1;
  var bloc;
  var clientId;
  var dataMobil;

  @override
  void initState() {
    // TODO: implement initState
    // analytics.
    getMobil();
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

//  FUNCTION

  String clienId;

//  getRoom() async {
//    clienId = await getPrefferenceIdClient();
//    return clienId;
//  }

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
              "Mobil Rental Yang Tersedia",
              style: TextStyle(fontSize: 25),
            )),
            SizedBox(
              height: 20,
            ),
            Expanded(
                child: dataMobil == null
                    ? Container()
                    : dataMobil.length == 0
                        ? Center(
                            child: GenText("Tidak ada mobil tersedia"),
                          )
                        : SingleChildScrollView(
                            child: Column(
                                children: dataMobil.map<Widget>((e) {

                            return (e["status"] == 0) ? CommonPadding(
                              child: InkWell(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, 'detailMobil', arguments: DetailMobil(
                                    id: e["id"],

                                  ));

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
                                        ip + e["image"],
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
                                              e["nama"],
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            GenText(e["no_pol"]),
                                            GenText(e["tahun"].toString()),
                                            GenText(e["keterangan"]),
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
                            ) : Container();
                          }).toList())))
          ],
        ),
      ),
    );
  }

  void getMobil() async {
    dataMobil = await req.getApi("mobil");

    print("DATA $dataMobil");
    print("length" + dataMobil.length.toString());

    setState(() {});
  }
}
