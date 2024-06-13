import 'package:beatapp/utility/base64_utility.dart';
import 'package:flutter/material.dart';

class ImageViewer extends StatefulWidget {
  final Map<String, String?> data;

  const ImageViewer({Key? key, required this.data}) : super(key: key);

  @override
  State<ImageViewer> createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> {
  String encodeImage = "";

  @override
  void initState() {
    encodeImage = widget.data["image"] ?? "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Image Viewer"),
        ),
        body: Container(
          color: Colors.black,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Image.memory(
            Base64Helper.decodeBase64Image(encodeImage),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
          ),
        ));
  }
}
