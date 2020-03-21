import 'package:args/command_runner.dart';
import 'package:cli/command/generate_command.dart';

const _tool_name = 'emfi-light';

void main(List<String> args) {

  var runner = CommandRunner<String>(_tool_name, 'QRCode Generator for ...')
      ..addCommand(GenerateCommand());

  if(args.isEmpty) runner.printUsage();

  runner.run(args).then(print);
}