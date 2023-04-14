import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:privaap/bloc/blocs.dart';
import 'package:privaap/components/read_qr.dart';
import 'package:privaap/screens/pages/groups/card_group.dart';
import 'package:privaap/services/auth_service.dart';
import 'package:privaap/services/socket_service.dart';
import 'package:provider/provider.dart';

class ScreenLookAfter extends StatefulWidget {
  final GlobalKey? keyRead;
  const ScreenLookAfter({super.key, this.keyRead});

  @override
  State<ScreenLookAfter> createState() => _ScreenLookAfterState();
}

class _ScreenLookAfterState extends State<ScreenLookAfter> {
  @override
  Widget build(BuildContext context) {
    final groupBloc = BlocProvider.of<GroupBloc>(context, listen: true).state;
    return Expanded(
      child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
        // if (groupBloc.listCircleTrust!.where((e) => e!.reason == 'guest').isNotEmpty)
        ReadQr(
          key: widget.keyRead,
          result: (resultQr) => readInvitation(resultQr),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
            child: Column(
              children: [
                if (groupBloc.existCirclesTrust)
                  for (final item in groupBloc.listCircleTrust.where((e) => e!.reason == 'guest'))
                    CardGroup(item: item),
              ],
            ),
          ),
        ),
      ]),
    );
  }

  Future readInvitation(resultQr) async {
    // final groupBloc = BlocProvider.of<GroupBloc>(context, listen: false);
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.emit('leer-invitacion', {"code": resultQr, "guest": await AuthService.readAccessToken()});

    // final Map<String, String> body = {
    //   "code": resultQr,
    // };
    // if (!mounted) return;
    // var response = await serviceMethod(context, 'post', body, serviceConfirmGuest(), true, null);
    // if (response != null) {
    //   debugPrint('creadoooo');
    //   groupBloc.add(UpdateCiclesTrust(circleTrustModelFromJson(json.encode(response.data['circlesTrust']))));
    // }
  }
}
