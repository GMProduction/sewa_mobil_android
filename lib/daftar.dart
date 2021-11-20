import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'component/TextFieldLogin.dart';
import 'component/genButton.dart';
import 'component/genColor.dart';
import 'component/genPreferrence.dart';
import 'component/genText.dart';
import 'component/genToast.dart';
import 'component/request.dart';

class Daftar extends StatefulWidget {
  @override
  _DaftarState createState() => _DaftarState();
}

class _DaftarState extends State<Daftar> {
  bool readyToHit = true;
  final req = new GenRequest();

  var username, password, alamat, no_hp, nama, konfpassword;
  var _picker;
  XFile _image;

  Future<XFile> pickImage() async {
    final _picker = ImagePicker();

    final XFile pickedFile = await _picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      print('PickedFile: ${pickedFile.toString()}');
      setState(() {
        _image = XFile(pickedFile.path); // Exception occurred here
      });


    } else {
      print('PickedFile: is null');
    }

    if (_image != null) {
      return _image;
    }
    return null;
  }

  void takepic() async {
    final XFile photo = await _picker.pickImage(source: ImageSource.camera);
  }



  Future<void> getLostData() async {
    final LostDataResponse response =
    await _picker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.files != null) {
      for(final XFile file in response.files) {
        // _handleFile(file);
      }
    } else {
      // _handleError(response.exception);
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(30),
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 30,
              ),
              Text(
                "DAFTAR",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 30,
              ),
              TextLoginField(
                initVal: "",
                width: double.infinity,
                label: "Nama",
                keyboardType: TextInputType.name,
//                                    controller: tecNumber,
                onChanged: (val) {
                  nama = val;
                },
                validator: (val) {
                  if (val.length < 1) {
                    return "Isi Nama Dengan Benar";
                  } else {
                    return null;
                  }
                },
              ),
              SizedBox(
                height: 20,
              ),
              TextLoginField(
                initVal: "",
                width: double.infinity,
                label: "Alamat",
                keyboardType: TextInputType.streetAddress,
//                                    controller: tecNumber,
                onChanged: (val) {
                  alamat = val;
                },
                validator: (val) {
                  if (val.length < 1) {
                    return "Isi Alamat Dengan Benar";
                  } else {
                    return null;
                  }
                },
              ),
              SizedBox(
                height: 20,
              ),
              TextLoginField(
                initVal: "",
                width: double.infinity,
                label: "No. HP",
                keyboardType: TextInputType.number,
//                                    controller: tecNumber,
                onChanged: (val) {
                  no_hp = val;
                },
                validator: (val) {
                  if (val.length < 1) {
                    return "Isi No Hp Dengan Benar";
                  } else {
                    return null;
                  }
                },
              ),
              SizedBox(
                height: 20,
              ),
              // Container(
              //   child: Row(
              //     children: [
              //       Container(
              //         width: 85,
              //         child: GenButton(text: "Foto KTP", ontap: (){
              //           pickImage();
              //         },),
              //       ),
              //       SizedBox(width: 20,),
              //       _image == null ? Container(width: 100, height: 100,) :
              //       Image.file(File(_image.path), width: 100,),
              //     ],
              //   ),
              // ),
              SizedBox(
                height: 20,
              ),
              Divider(),
              SizedBox(
                height: 20,
              ),
              TextLoginField(
                initVal: "",
                width: double.infinity,
                label: "Username",
                keyboardType: TextInputType.emailAddress,
//                                    controller: tecNumber,
                onChanged: (val) {
                  username = val;
                },
                validator: (val) {
                  if (val.length < 1) {
                    return "Isi Email Dengan Benar";
                  } else {
                    return null;
                  }
                },
              ),
              SizedBox(
                height: 20,
              ),
              TextLoginField(
                initVal: "",
                width: double.infinity,
                label: "Password",
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
//                                    controller: tecNumber,
                onChanged: (val) {
                  password = val;
                },
                validator: (val) {
                  if (val.length < 1) {
                    return "Isi password dengan benar";
                  } else {
                    return null;
                  }
                },
              ),
              SizedBox(
                height: 20,
              ),
              TextLoginField(
                initVal: "",
                width: double.infinity,
                label: "Konfirmasi password",
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
//                                    controller: tecNumber,
                onChanged: (val) {
                  konfpassword = val;
                },
                validator: (val) {
                  if (konfpassword != password) {
                    return "Konfirmasi password tidak sama";
                  } else {
                    return null;
                  }
                },
              ),
              SizedBox(
                height: 30,
              ),
              readyToHit
                  ? GenButton(
                      text: "DAFTAR",
                      ontap: () {
                        daftar(nama, alamat, no_hp, username, password, konfpassword);
                        // Navigator.pushNamed(context, "base");
                      },
                    )
                  : CircularProgressIndicator(),
              SizedBox(
                height: 10,
              ),
              InkWell(
                  onTap: () {
                    Navigator.pushReplacementNamed(context, "daftar");
                  },
                  child: GenText(
                    "Sudah punya akun ? Masuk disini",
                    style: TextStyle(fontSize: 16),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  void daftar(nama, alamat, no_hp, username, pass, konfpassword) async {
    setState(() {
      readyToHit = false;
    });
    dynamic data;
    data = await req.postApi("register", {"username": username, "password": pass, "nama": nama, "alamat": alamat, "no_hp": no_hp, "password_confirmation": konfpassword});

    print("DATA $data");
    setState(() {
      readyToHit = true;
    });
    if (data["status"] == 200) {
      setState(() {
        setPrefferenceToken(data["data"]["token"]);
        Navigator.pushReplacementNamed(context, "base");
      });
    } else if (data["code"] == 202) {
      setState(() {
        toastShow(data["payload"]["msg"], context, GenColor.red);
      });
    } else {
      setState(() {
        toastShow("Terjadi kesalahan coba cek koneksi internet kamu", context,
            GenColor.red);
      });
    }
  }
}
