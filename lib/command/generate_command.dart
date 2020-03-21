import 'package:args/command_runner.dart';
import 'package:cli/service/generate_service.dart';

class GenerateCommand extends Command<String> {

  @override
  String get description => 'Generate QRCodes';

  @override
  String get name => 'generate';

  @override
  String get invocation => 'emfi-light generate <amount>';

  GenerateCommand() {
    argParser
      ..addOption('amount',
        abbr: 'a',
        defaultsTo: "10",
        help: 'The amount of QRCode pairs to be generated.'
      )
      ..addOption('output',
        abbr: 'o',
        defaultsTo: ".",
        help: 'The output path for the pdf.'
      );
  }

  @override
  String run() {
    final int amount = num.tryParse(argResults['amount']) ?? -1;
    final String path = argResults['output'];

    if (amount == -1)
      return 'Amount must be a number!';

    GenerateService.generate(path, amount).then((error) {
      if (error == null) {
        print('PDF was successfully create for $amount QRCodes at: $path');
        return;
      }
    
      print('Could not generate QRCodes: $error');
    });

    return 'Generating PDF...';
  }

}