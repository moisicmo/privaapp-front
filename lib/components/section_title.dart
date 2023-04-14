import 'package:flutter/material.dart';

class ItemList extends StatefulWidget {
  final IconData icon;
  final String text;
  final Function()? onPressed;
  final bool stateLoading;
  const ItemList({super.key, required this.icon, required this.text, this.onPressed, this.stateLoading = false});

  @override
  State<ItemList> createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: widget.stateLoading
            ? Image.asset(
                'assets/gifs/load.gif',
                fit: BoxFit.cover,
                height: 15,
              )
            : GestureDetector(
                onTap: () => widget.onPressed!(),
                child: Table(
                    columnWidths: const {
                      0: FlexColumnWidth(.3),
                      2: FlexColumnWidth(6),
                    },
                    border: const TableBorder(
                      horizontalInside: BorderSide(
                        width: 0.5,
                        color: Colors.grey,
                        style: BorderStyle.solid,
                      ),
                    ),
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    children: [
                      TableRow(children: [Icon(widget.icon), Text(widget.text)])
                    ]),
              ));
  }
}
