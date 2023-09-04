import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrCodePage extends StatefulWidget {
  final dynamic userInfos;

  const QrCodePage({
    Key? key,
    required this.userInfos,
  }) : super(key: key);

  @override
  State<QrCodePage> createState() => _QrCodePageState();
}

class _QrCodePageState extends State<QrCodePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gerar QR Code'),
      ),
      body: Center(
        child: QrImageView(
          data: "vamo gremio",
          version: QrVersions.auto,
          size: 200.0,
        ),
      ),
    );
  }
}
