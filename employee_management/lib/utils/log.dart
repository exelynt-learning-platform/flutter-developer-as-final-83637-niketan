import 'package:logger/logger.dart';

class Log {
  static Logger logger = Logger();

  static void verbose(String message, {dynamic error, StackTrace? stackTrace}) {
    logger.t(message, error: error, stackTrace: stackTrace);
  }

  static void debug(String message, {dynamic error, StackTrace? stackTrace}) {
    logger.d(message, error: error, stackTrace: stackTrace);
  }

  static void info(String message, {dynamic error, StackTrace? stackTrace}) {
    logger.i(message, error: error, stackTrace: stackTrace);
  }

  static void warning(String message, {dynamic error, StackTrace? stackTrace}) {
    logger.w(message, error: error, stackTrace: stackTrace);
  }

  static void error(String message, {dynamic error, StackTrace? stackTrace}) {
    logger.e(message, error: error, stackTrace: stackTrace);
  }

  static void failure(String message, {dynamic error, StackTrace? stackTrace}) {
    logger.f(message, error: error, stackTrace: stackTrace);
  }
}
