import 'package:flutter/material.dart';import 'package:flutter_riverpod/flutter_riverpod.dart';import 'package:flutter_tetris/getx_version/view.dart';import 'package:get/get.dart';void main() {  runApp(const MyApp());}class MyApp extends StatelessWidget {  const MyApp({Key? key}) : super(key: key);  @override  Widget build(BuildContext context) {    return ProviderScope(        child: GetMaterialApp(      title: 'Flutter Demo',      theme: ThemeData(        primarySwatch: Colors.blue,      ),      home: const GetVersionPage(title: 'title'),    ));  }}