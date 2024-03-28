export 'package:chats/helpers/custom_print.dart';

void printYellow(dynamic text){
      print('\x1B[33m${text?.toString()}\x1B[0m');
}

void printRed(dynamic text){
      print('\x1B[31m${text?.toString()}\x1B[0m');
}
