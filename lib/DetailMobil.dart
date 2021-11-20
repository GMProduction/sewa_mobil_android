// ignore: file_names
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sewa_mobil/component/genButton.dart';
import 'package:sewa_mobil/pembayaran.dart';

import 'blocks/baseBloc.dart';
import 'component/JustHelper.dart';
import 'component/NavDrawer.dart';
import 'component/commonPadding.dart';
import 'component/genColor.dart';
import 'component/genRadioMini.dart';
import 'component/genShadow.dart';
import 'component/genText.dart';
import 'component/genToast.dart';
import 'component/request.dart';
import 'component/textAndTitle.dart';

class DetailMobil extends StatefulWidget {
  final int id;

  DetailMobil({this.id});

  @override
  _DetailMobilState createState() => _DetailMobilState();
}

class _DetailMobilState extends State<DetailMobil> with WidgetsBindingObserver {
  final req = new GenRequest();

  bool loading = false;
  bool readyToHit = true;

  // NotifBloc notifbloc;
  bool isLoaded = false;
  String dropdownValue = 'One';

//  double currentgurulainValue = 0;

  var dataMobil, id, perkembangan, items, stateDuration, stateHarga;
  bool isloaded = false;

  var startTime = TimeOfDay.fromDateTime(DateTime.now());
  var endTime = TimeOfDay.fromDateTime(DateTime.now());
  var selectedDate = DateTime.now();
  String _hour, _minute, _time;
  TextEditingController _timeController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    // analytics.

    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

//  FUNCTION

//  getClientId() async {
//    clientId = await getPrefferenceIdClient();
//    if (clientId != null) {
//      print("CLIENT ID" + clientId);
//    }
//  }

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime.now(),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: startTime,
    );
    if (picked != null)
      setState(() {
        startTime = picked;
        _hour = startTime.hour.toString();
        _minute = startTime.minute.toString();
        _time = _hour + ' : ' + _minute;
        _timeController.text = _time;
      });
  }

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
    final DetailMobil args = ModalRoute.of(context).settings.arguments;
    id = args.id;

    if (!isloaded) {
      getMobil(id);
      isloaded = true;
    }

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: GenColor.primaryColor, // status bar color
    ));

    ScreenUtil.init(
        BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height),
        designSize: Size(360, 690),
        orientation: Orientation.portrait);

    if (!isLoaded) {
      isLoaded = true;
    }

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
            Expanded(
              child: dataMobil == null
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.network(
                            ip + dataMobil["image"],
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          CommonPadding(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GenText(
                                  dataMobil["nama"],
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                GenText(dataMobil["no_pol"]),
                                GenText(dataMobil["tahun"].toString()),
                                GenText(dataMobil["keterangan"]),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          CommonPadding(
                              child: GenText(
                            "Harga",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          )),
                          SizedBox(
                            height: 10,
                          ),
                          dataMobil["harga"].length == 0
                              ? GenText("Harga Belum tersedia")
                              : CommonPadding(
                                  child: Column(
                                    children:
                                        dataMobil["harga"].map<Widget>((e) {
                                      return Row(
                                        children: [
                                          GenText(e["duration"].toString() +
                                              " Jam: "),
                                          GenText(
                                            formatRupiahUseprefik(
                                                e["harga"].toString()),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      );
                                    }).toList(),
                                  ),
                                ),
                          SizedBox(
                            height: 50,
                          ),
                          CommonPadding(
                              child: GenText(
                            "Pilih Tanggal",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          )),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              CommonPadding(
                                child: InkWell(
                                  onTap: () => _selectDate(context),
                                  child: Container(
                                    padding: EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        boxShadow: GenShadow().genShadow(),
                                        color: Colors.white),
                                    child: GenText(formatTanggal(selectedDate)
                                            .toString() ??
                                        "Pilih Tanggal"),
                                  ),
                                ),
                              ),
                              CommonPadding(
                                child: InkWell(
                                  onTap: () => _selectTime(context),
                                  child: Container(
                                    padding: EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        boxShadow: GenShadow().genShadow(),
                                        color: Colors.white),
                                    child: GenText(startTime.hour.toString() +
                                        " : " +
                                        startTime.minute.toString()),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          CommonPadding(
                              child: GenText(
                            "Durasi",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          )),
                          SizedBox(
                            height: 10,
                          ),
                          CommonPadding(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                GenRadioGroupMini(
                                  listData: items,
                                  ontap: (val) {
                                    setState(() {
                                      stateDuration = val["id"];
                                      stateHarga = val["jumlah"];
                                    });
                                  },
                                  id: "id",
                                  title: "duration",
                                  jumlah: "harga",
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
            ),
            CommonPadding(
                child: readyToHit
                    ? GenButton(
                        text: "Sewa Mobil",
                        ontap: () {
                          var datetime =
                              (selectedDate.toString().substring(0, 10) +
                                      " " +
                                      startTime.toString().substring(10, 15))
                                  .toString();
                          print(stateHarga.toString());
                          print(datetime);
                          print(stateDuration);

                          sewaMobil(stateDuration, stateHarga, datetime);
                        },
                      )
                    : Center(child: CircularProgressIndicator())),
            SizedBox(
              height: 16,
            )
          ],
        ),
      ),
    );
  }

  void getMobil(id) async {
    items = [];
    dataMobil = await req.getApi("mobil/" + id.toString());

    if (dataMobil["harga"].length != 0) {
      for (int i = 0; i < dataMobil["harga"].length; i++) {
        var mHarga = {
          "id": dataMobil["harga"][i]["id"],
          "duration": dataMobil["harga"][i]["duration"].toString() + " Jam",
          "harga": dataMobil["harga"][i]["harga"]
        };
        items.add(mHarga);
      }
    }

    print("DATA $dataMobil");
    print("length" + dataMobil.length.toString());

    setState(() {});
  }

  void sewaMobil(
    harga_id,
    total,
    tanggal_pinjam,
  ) async {
    setState(() {
      readyToHit = false;
    });
    dynamic data;
    data = await req.postForm("transaksi", {
      "harga": harga_id,
      "tanggal": tanggal_pinjam,
    });

    setState(() {
      readyToHit = true;
    });

    if (data["msg"] == "berhasil") {
      setState(() {
        toastShow("Berhasil sewa mobil", context, Colors.black);
      });

      Navigator.pushReplacementNamed(context, "pembayaran",
          arguments: Pembayaran(id: data["id"]));
    } else {
      setState(() {
        toastShow(data.toString(), context, GenColor.red);
      });
    }
  }
}
