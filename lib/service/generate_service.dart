import 'dart:io';

import 'package:cli/model/corona_test_case.dart';
import 'package:cli/service/api_service.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:qr/qr.dart';
import 'package:tuple/tuple.dart';
import 'package:image/image.dart' as Image2;

/// This class Generates the QRCode PDFs
/// author: Tandashi
class GenerateService {

  /// Generate the PDF ath the given [path] with given [amount]
  /// Will return null if sucessful else will return a error message
  static Future<String> generate(final String path, final int amount) async {
    final List<Tuple2<QrCode, QrCode>> qrCodes = await _generateQRCodes(amount);
    _generatePDF(path, qrCodes);

    return null;
  }

  /// Generates a PDF at given [path] with given [qrCodes]
  /// It will strucutre the QRCode pairs as definined in [_addPage]
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

  /// Adds a QRCode Pair to a PDF page
  /// This will add the read QRCode on the left and the write QRCode on the right
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

  /// This Method generates a given [amount] of QRCodes and returns them as a List of QRCode Pairs
  /// The first entry in the Pair is the read QRCode and the seconds entry is the write QRCode
  static Future<List<Tuple2<QrCode, QrCode>>> _generateQRCodes(int amount) async {
    final List<Tuple2<QrCode, QrCode>> qrCodes = [];
    final List<Future<List<CoronaTestCase>>> futures = [];

    while (amount > 0) {
      final int chunk = amount > 50 ? 50 : amount;
      futures.add(APIService.createTestCases(chunk));
      amount -= chunk;
    }
    
    final List<List<CoronaTestCase>> chunkedTestCases = await Future.wait(futures);

    final List<CoronaTestCase> testCases = chunkedTestCases.fold(<CoronaTestCase>[], (List<CoronaTestCase> acc, List<CoronaTestCase> chunk) {
      acc.addAll(chunk);
      return acc;
    });

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