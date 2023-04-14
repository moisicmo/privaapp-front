import 'package:flutter/material.dart';
import 'package:privaap/components/containers.dart';
import 'package:privaap/components/icon_rounded.dart';
import 'package:privaap/models/circle_trust_model.dart';

class CardPerson extends StatelessWidget {
  final bool stateInvnite;
  final UserElement? item;
  final Function() removePerson;
  const CardPerson({Key? key, required this.item, required this.stateInvnite, required this.removePerson})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ContainerComponent(
        child: Row(children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(100.0),
                child: item!.user!.avatar == null
                    ? Image.asset('assets/images/person.png',
                        width: 80, height: 80, fit: BoxFit.cover, gaplessPlayback: true)
                    : Image.network(item!.user!.avatar!,
                        width: 80, height: 80, fit: BoxFit.cover, gaplessPlayback: true)),
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.all(5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Text('id: ${item!.user!.id}'),
                Text('Nombre: ${item!.user!.name}'),
                Text('Apellido: ${item!.user!.lastName}'),
                Text('Contacto: ${item!.user!.phone}'),
                Text('Correo: ${item!.user!.email}')
              ],
            ),
          )),
          if (stateInvnite)
            Column(children: <Widget>[
              Padding(
                  padding: const EdgeInsets.all(5),
                  child: IconRoundedComponent(
                    onTap: () => removePerson(),
                    icon: Icons.delete_outline_outlined,
                    colorIcon: const Color(0xFfE21C34),
                  )),
            ]),
        ]),
      ),
    );
  }
}
