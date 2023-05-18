import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:privaap/bloc/blocs.dart';
import 'package:privaap/components/button.dart';
import 'package:privaap/components/dialog_action.dart';
import 'package:privaap/components/generator_qr.dart';
import 'package:privaap/components/headers.dart';
import 'package:privaap/components/modal.dart';
import 'package:privaap/models/circle_trust_model.dart';
import 'package:privaap/providers/user_provider.dart';
import 'package:privaap/screens/pages/groups/card_person.dart';
import 'package:privaap/screens/pages/groups/look_after.dart';
import 'package:privaap/services/service_method.dart';
import 'package:privaap/services/services.dart';
import 'package:provider/provider.dart';

class CircleTrustScreen extends StatefulWidget {
  final GlobalKey? keyInvite;
  final GlobalKey? keyReadInvite;
  const CircleTrustScreen({super.key, this.keyInvite, this.keyReadInvite});

  @override
  State<CircleTrustScreen> createState() => _CircleTrustScreenState();
}

class _CircleTrustScreenState extends State<CircleTrustScreen> {
  bool stateLoading = false;
  @override
  void initState() {
    super.initState();
    getCirclesTrust();
    final groupBloc = BlocProvider.of<GroupBloc>(context, listen: false);
  }

  getCirclesTrust() async {
    final groupBloc = BlocProvider.of<GroupBloc>(context, listen: false);
    if (!mounted) return;
    var response = await serviceMethod(context, 'get', null, serviceGetAllCirclesTrust(), true);
    if (response != null) {
      groupBloc.add(UpdateCiclesTrust(circleTrustModelFromJson(json.encode(response.data))));
    }
  }

  @override
  Widget build(BuildContext context) {
    final groupBloc = BlocProvider.of<GroupBloc>(context, listen: true).state;
    final group = groupBloc.listCircleTrust.firstWhere((e) => e!.reason == 'creator')!;
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HedersComponent(title: 'Me cuidan'),
          if (!stateLoading)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ButtonComponent(
                  key: widget.keyInvite,
                  text: 'Invitar a otra persona',
                  onPressed: () => sendInvitation(group.groupId!)),
            ),
          Expanded(
              child: SingleChildScrollView(
            padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
            child: Column(
              children: [
                for (final item in group.users!)
                  CardPerson(
                    item: item,
                    stateInvnite: false,
                    removePerson: () {},
                  )
              ],
            ),
          )),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ButtonComponent(
                key: widget.keyReadInvite,
                color: const Color(0xff27AE60),
                text: 'Yo cuido',
                onPressed: () => lookAfter()),
          )
        ],
      ),
    );
  }

  lookAfter() async {
    final sizeScreenModal = Provider.of<SizeScreenModal>(context, listen: false);
    sizeScreenModal.updateSizeScreen(1);
    return showBarModalBottomSheet(
      enableDrag: false,
      expand: false,
      context: context,
      builder: (context) => const ModalComponent(
        title: 'Yo cuido',
        child: ScreenLookAfter(),
      ),
    );
  }

  sendInvitation(int groupId) async {
    final userData = Provider.of<UserData>(context, listen: false).userData;
    setState(() => stateLoading = true);
    final Map<String, String> body = {
      "group_id": '$groupId',
    };
    if (!mounted) return;
    final response = await serviceMethod(context, 'post', body, serviceCreateGuest(), true);
    setState(() => stateLoading = false);
    if (response != null) {
      return generateQr(response.data['guest']['code']);
    }
  }

  generateQr(String code) async {
    await showDialog(
        context: context,
        builder: (_) {
          return FadeIn(
              child: DialogWidget(
            component: ScreenQr(message: code),
          ));
        });
  }
}
