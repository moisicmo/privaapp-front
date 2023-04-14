import 'package:flutter/cupertino.dart';
import 'package:privaap/components/headers.dart';
import 'package:privaap/providers/user_provider.dart';
import 'package:provider/provider.dart';

class ModalComponent extends StatefulWidget {
  final String title;
  final Widget child;
  const ModalComponent({super.key, required this.title, required this.child});

  @override
  State<ModalComponent> createState() => _ModalComponentState();
}

class _ModalComponentState extends State<ModalComponent> {
  @override
  Widget build(BuildContext context) {
    final sizeScreenModal = Provider.of<SizeScreenModal>(context, listen: true).sizeScreen;
    return CupertinoPageScaffold(
        child: SizedBox(
            height: MediaQuery.of(context).size.height < MediaQuery.of(context).size.width
                ? MediaQuery.of(context).size.height
                : MediaQuery.of(context).size.height / sizeScreenModal,
            child: Column(
              children: [
                HedersComponent(title: widget.title),
                Expanded(
                  child: widget.child,
                )
              ],
            )));
  }
}
