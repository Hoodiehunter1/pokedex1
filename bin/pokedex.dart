import 'dart:io';
import 'package:mysql1/mysql1.dart';
import 'info.dart';
import 'menus.dart';
import 'base.dart';
import 'pokeapi_service.dart'; // Añade esta importación

main() async {
  BaseDatos.installBBDD();
  await Menu.menuInicio();
}
