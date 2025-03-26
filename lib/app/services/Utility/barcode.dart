class BarcodeService {
  String scanBarcode = 'Unknown';

  Future<void> startBarcodeScanStream() async {
    // FlutterBarcodeScanner.getBarcodeStreamReceiver(
    //         '#ff6666', 'Cancel', true, ScanMode.BARCODE)!
    //     .listen((barcode) => log(barcode));
  }

  Future<String> scanQR() async {
    // String barcodeScanRes;
    // try {
    //   barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
    //       '#ff6666', 'Cancel', true, ScanMode.QR);
    //   log(barcodeScanRes);
    // } on PlatformException {
    //   barcodeScanRes = 'Failed to get platform version.';
    // }

    // return scanBarcode = barcodeScanRes;
    return scanBarcode;
  }

// Platform messages are asynchronous, so we initialize in an async method.
  Future<String> scanBarcodeNormal() async {
    // String barcodeScanRes;
    // // Platform messages may fail, so we use a try/catch PlatformException.
    // try {
    //   barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
    //       '#ff6666', 'Cancel', true, ScanMode.BARCODE);
    //   log(barcodeScanRes);
    // } on PlatformException {
    //   barcodeScanRes = 'Failed to get platform version.';
    //   return scanBarcode = barcodeScanRes;
    // }

    // // If the widget was removed from the tree while the asynchronous platform
    // // message was in flight, we want to discard the reply rather than calling
    // // setState to update our non-existent appearance.

    // return scanBarcode = barcodeScanRes;

    return scanBarcode;
  }
}
