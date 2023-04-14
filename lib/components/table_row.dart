import 'package:flutter/material.dart';

TableRow tableInfo(String text, String value) {
  return TableRow(children: [
    Text(
      text,
      style: const TextStyle(fontWeight: FontWeight.bold),
    ),
    const Text(' : '),
    Padding(
      padding: const EdgeInsets.symmetric(vertical: 0),
      child: Text(value),
    ),
  ]);
}
