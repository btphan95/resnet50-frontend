import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'dart:typed_data';
import 'dart:async';
import 'dart:convert';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
// import 'package:web_upload/apps/main_app.dart';

class FileUploadButton extends StatefulWidget {
  @override
  createState() => _FileUploadButtonState();
}

class _FileUploadButtonState extends State<FileUploadButton> {
  Uint8List image;
  var results;
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  startWebFilePicker() async {
    results = null; 
    image = null;
        
    html.InputElement uploadInput = html.FileUploadInputElement();
    uploadInput.multiple = true;
    uploadInput.draggable = true;
    uploadInput.click();

    uploadInput.onChange.listen((e) {
      final files = uploadInput.files;
      final file = files[0];
      final reader = new html.FileReader();
      reader.onLoadEnd.listen((e) {
                    setState(() {
                      image = reader.result;
                      print('image is' + image.runtimeType.toString());
                    });
        });

        reader.onError.listen((fileEvent) {
          setState(() {
            print('error reading file');
          });
        });

        reader.readAsArrayBuffer(file);  
        });
    _makeRequest();  
    }    
    
  Future<List<dynamic>> makeRequest() async {
    var url = Uri.parse(
        "http://localhost:4444/predict");
    var request = new http.MultipartRequest("POST", url);

//     request.files.add(await http.MultipartFile.fromBytes('image', image,
//         contentType: new MediaType('image', 'jpeg'),
//         filename: "image"));
      print('waiting');
      var multipart;
      var done = 0;
      while (done == 0) {
          try {
              multipart = await http.MultipartFile.fromBytes('image', image,
                contentType: new MediaType('image', 'jpeg'),
                filename: "image");
              done = 1;
          }
          catch (uh_oh) {
              print("uh oh");
              await new Future.delayed(new Duration(milliseconds: 100)); // Add this line
          }
      }
      
      print('done. now testing if it works:');
      setState(() {
          request.files.add(multipart);
          });      
    var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode == 200) print("Uploaded!");
      results = json.decode(response.body);

      return results["predictions"];
//     showDialog(
//         barrierDismissible: false,
//         context: context,
//         child: new AlertDialog(
//           title: new Text("Details"),
//           //content: new Text("Hello World"),
//           content: new SingleChildScrollView(
//             child: new ListBody(
//               children: <Widget>[
//                 new Text("Upload successfull"),
//               ],
//             ),
//           ),
//           actions: <Widget>[
//             new FlatButton(
//               child: new Text('Aceptar'),
//               onPressed: () {
//                 Navigator.pushAndRemoveUntil(
//                   context,
//                   MaterialPageRoute(builder: (context) => UploadApp()),
//                   (Route<dynamic> route) => false,
//                 );
//               },
//             ),
//           ],
//         ));
  }
  
  void _makeRequest() async {
      results = await makeRequest();
      print("YES!!!!");
      print(results);
//       display = results;
//       print(display);
      setState(() => results = results);
//       print('display updated!');
//       return results;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Container(

            child: new Form(
            autovalidate: true,
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.only(top: 16.0, left: 28),
              child: new Container(
                  width: 350,
                  child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          FloatingActionButton.extended(
                              onPressed: () {
                                startWebFilePicker();
//                                 _makeRequest();  
                              },
                              label: Text('Upload an image'),
                              icon: Icon(Icons.wallpaper),
                              backgroundColor: Colors.pink,
                          ),  
                         results == null
                          ? Container(
                              child: Text(''),
                            )
                          : Container(
                              decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(20),
                                  ),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                      Column(
//                                           crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                              for ( var i in results ) Text(i["label"].toString())
                                          ],
                                      ),
                                      Column(
//                                           crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                              for ( var i in results ) Text(i["probability"].toStringAsFixed(2))
                                          ],
                                      ),
                                  ],
                              ),   
                            )
                        ]),
                  ),
            ),
          ),
        );
  }
}
