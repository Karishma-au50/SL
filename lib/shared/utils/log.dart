// import 'dart:convert';
// import 'dart:io';

// import 'package:logger/logger.dart';
// import 'package:path_provider/path_provider.dart';

// class Log {
//   late final Logger _logger;
//   Log._internal() {
//     _logger = Logger(
//       filter: ProductionFilter(),
//       printer: PrettyPrinter(
//           methodCount: 2, // number of method calls to be displayed
//           errorMethodCount:
//               8, // number of method calls if stacktrace is provided
//           lineLength: 120, // width of the output
//           colors: true, // Colorful log messages
//           printEmojis: true, // Print an emoji for each log message
//           printTime: false // Should each log print contain a timestamp
//           ),
//       output: FileOutput(),
//     );
//   }

//   static final Log _singleton = Log._internal();

//   static void verbose(dynamic message) => _singleton._logger.t(message);

//   static void debug(dynamic message) => _singleton._logger.d(message);

//   static void info(dynamic message) => _singleton._logger.i(message);

//   static void error(dynamic message) => _singleton._logger.e(message);

//   static void errorStackTrace(
//           dynamic message, dynamic error, StackTrace? stackTrace) =>
//       _singleton._logger.e(message,
//           time: DateTime.now(), error: error, stackTrace: stackTrace);

//   static void warning(dynamic message) => _singleton._logger.w(message);
// }

// /// Writes the log output to a file.
// class FileOutput extends LogOutput {
//   final bool overrideExisting;
//   final Encoding encoding;
//   IOSink? _sink;

//   FileOutput({
//     // required this.file,
//     this.overrideExisting = false,
//     this.encoding = utf8,
//   });

//   @override
//   Future<void> init() async {
//     final file =
//         File('${(await getApplicationDocumentsDirectory()).path}/logs.txt');
//     _sink = file.openWrite(
//       mode: overrideExisting ? FileMode.writeOnly : FileMode.writeOnlyAppend,
//       encoding: encoding,
//     );
//     return super.init();
//   }

//   @override
//   void output(OutputEvent event) {
//     _sink?.writeAll(event.lines, '\n');
//     _sink?.writeln();
//   }

//   @override
//   Future<void> destroy() async {
//     await _sink?.flush();
//     await _sink?.close();
//     return super.destroy();
//   }
// }
