import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:privaap/bloc/blocs.dart';
import 'package:privaap/components/containers.dart';
import 'package:privaap/components/dialog_action.dart';
import 'package:privaap/components/icon_rounded.dart';
import 'package:privaap/models/circle_trust_model.dart';
import 'package:privaap/screens/pages/groups/create_group.dart';
import 'package:privaap/services/service_method.dart';
import 'package:privaap/services/services.dart';

class CardGroup extends StatelessWidget {
  final CircleTrustModel? item;
  const CardGroup({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = item!.users!.firstWhere((e) => e!.reason == 'creator')!.user!;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ContainerComponent(
        child: Row(children: <Widget>[
          if (item!.reason != 'creator')
            ClipRRect(
                borderRadius: BorderRadius.circular(100.0),
                child: user.avatar != null
                    ? Image.network(user.avatar!, width: 80, height: 80, fit: BoxFit.cover, gaplessPlayback: true)
                    : Image.asset('assets/images/person.png',
                        width: 80, height: 80, fit: BoxFit.cover, gaplessPlayback: true)),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.all(5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Nombre: ${user.name}'),
                Text('Apellido: ${user.lastName}'),
                Text('Contacto: ${user.phone}'),
              ],
            ),
          )),
          if (item!.reason == 'creator')
            Column(children: <Widget>[
              Padding(
                  padding: const EdgeInsets.all(5),
                  child: IconRoundedComponent(
                    onTap: () => editCircleTrust(context),
                    icon: Icons.edit_outlined,
                    colorIcon: Colors.blue[700],
                  )),
              Padding(
                  padding: const EdgeInsets.all(5),
                  child: IconRoundedComponent(
                    onTap: () => deleteGroup(context),
                    icon: Icons.delete_outline_outlined,
                    colorIcon: const Color(0xFfE21C34),
                  )),
            ]),
        ]),
      ),
    );
  }

  editCircleTrust(BuildContext context) async {
    await Future.delayed(const Duration(milliseconds: 50));
    return showBarModalBottomSheet(
      context: context,
      builder: (context) => CreateCircleTrust(itemEdit: item),
    );
  }

  deleteGroup(BuildContext context) async {
    await showDialog(
        context: context,
        builder: (_) {
          return FadeIn(
              child: DialogTwoAction(
                  message: '¿Desea eliminar el circulo de confianza: ${item!.group!.name}?',
                  messageCorrect: 'Eliminar',
                  actionCorrect: () => confirmDelete(true, context)));
        });
  }

  confirmDelete(mounted, BuildContext context) async {
    final groupBloc = BlocProvider.of<GroupBloc>(context, listen: false);
    var response = await serviceMethod(context, 'delete', null, serviceRemoveCircleTrust(item!.groupId!), true, null);
    if (!mounted) return;
    Navigator.of(context).pop();
    if (response != null) {
      groupBloc.add(UpdateCiclesTrust(circleTrustModelFromJson(json.encode(response.data['circlesTrust']))));
    }
  }
}
