import 'dart:io';

import 'package:cli/model/corona_test_case.dart';
import 'package:cli/service/api_service.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:qr/qr.dart';
import 'package:tuple/tuple.dart';
import 'package:image/image.dart' as Image2;

class GenerateService {

  static Future<String> generate(final String path, final int amount) async {
    final List<Tuple2<QrCode, QrCode>> qrCodes = await _generateQRCodes(amount);
    _generatePDF(path, qrCodes);

    return null;
  }

  static Future<void>_generatePDF(final String path, List<Tuple2<QrCode, QrCode>> qrCodes) async {
    final pdf = Document();
    
    qrCodes.forEach((pair) {
      _addPage(pdf, pair);
    });

    final file = File('$path/out.pdf');
    await file.writeAsBytes(pdf.save());
  }

  static Image2.Image _convertQRCodeToImage(final QrCode qrCode, [final int scale = 4]) {
    final List<int> rgbaBytes = [];

    for (int x = 0; x < qrCode.moduleCount * scale; x++) {
      for (int y = 0; y < qrCode.moduleCount * scale; y++) {
        final int scaledX = (x / scale).floor();
        final int scaledY = (y / scale).floor();

        rgbaBytes.addAll(
          qrCode.isDark(scaledY, scaledX) ? [0, 0, 0, 255] : [255, 255, 255, 255]
        );
      }
    }

    return Image2.Image.fromBytes(
      qrCode.moduleCount * scale,
      qrCode.moduleCount * scale,
      rgbaBytes
    );
  }

  static void _addPage(final Document pdf, final Tuple2<QrCode, QrCode> pair) {
    final qrCodeImageRead = _convertQRCodeToImage(pair.item1);
    final qrCodeImageWrite = _convertQRCodeToImage(pair.item2);

    final qrCodeReadPDFImage = PdfImage(
      pdf.document,
      image: qrCodeImageRead.data.buffer.asUint8List(),
      width: qrCodeImageRead.width,
      height: qrCodeImageRead.height
    );

    final qrCodeWritePDFImage = PdfImage(
      pdf.document,
      image: qrCodeImageWrite.data.buffer.asUint8List(),
      width: qrCodeImageWrite.width,
      height: qrCodeImageWrite.height
    );

    pdf.addPage(Page(
      pageFormat: PdfPageFormat.a4,
      build: (Context context) {
        return Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image(qrCodeReadPDFImage),
              Image(qrCodeWritePDFImage)
            ]
          )
        );
      }
    ));
  }

  static Future<List<Tuple2<QrCode, QrCode>>> _generateQRCodes(final int amount) async {
    final List<Tuple2<QrCode, QrCode>> qrCodes = [];
    final List<CoronaTestCase> testCases = await APIService.createTestCases(amount);

    testCases.forEach((testCase){
      final QrCode read = new QrCode(4, QrErrorCorrectLevel.M)
                            ..addData('/corona-test-case/${testCase.uuidRead}')
                            ..make();

      final QrCode write = new QrCode(4, QrErrorCorrectLevel.M)
                            ..addData('/corona-test-case/${testCase.uuidWrite}')
                            ..make();

      qrCodes.add(Tuple2(read, write));
    });

    return qrCodes;
  }

}