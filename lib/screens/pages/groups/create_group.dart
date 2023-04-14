import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:privaap/bloc/blocs.dart';
import 'package:privaap/components/button.dart';
import 'package:privaap/components/gif_loading.dart';
import 'package:privaap/components/inputs/input.dart';
import 'package:privaap/models/circle_trust_model.dart';
import 'package:privaap/services/service_method.dart';
import 'package:privaap/services/services.dart';

class CreateCircleTrust extends StatefulWidget {
  final CircleTrustModel? itemEdit;
  const CreateCircleTrust({super.key, this.itemEdit});

  @override
  State<CreateCircleTrust> createState() => _CreateCircleTrustState();
}

class _CreateCircleTrustState extends State<CreateCircleTrust> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController descriptionCtrl = TextEditingController();
  String? levelTrustCtrl;
  bool stateLoading = false;
  final listLevelTrust = ['Bajo', 'Medio', 'Alto'];
  @override
  void initState() {
    if (widget.itemEdit != null) {
      setState(() {
        nameCtrl.text = widget.itemEdit!.group!.name!;
        descriptionCtrl.text = widget.itemEdit!.group!.description!;
        levelTrustCtrl = widget.itemEdit!.group!.level!;
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    return SingleChildScrollView(
        padding: const EdgeInsets.only(left: 30, right: 30, bottom: 15),
        child: Form(
            key: formKey,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
              InputComponent(
                textInputAction: TextInputAction.next,
                controllerText: nameCtrl,
                onEditingComplete: () => node.nextFocus(),
                keyboardType: TextInputType.text,
                icon: Icons.group,
                labelText: "Nombre",
                statecorrect: nameCtrl.text.length >= 8,
              ),
              InputComponent(
                textInputAction: TextInputAction.next,
                controllerText: descriptionCtrl,
                onEditingComplete: () => node.nextFocus(),
                keyboardType: TextInputType.text,
                icon: Icons.description,
                labelText: "Descripcion",
                statecorrect: nameCtrl.text.length >= 8,
              ),
              // Select(
              //   labelText: 'Nivel de confianza',
              //   options: listLevelTrust,
              //   text: levelTrustCtrl,
              //   onChanged: (value) => setState(() => levelTrustCtrl = value),
              //   statecorrect: levelTrustCtrl != '',
              // ),
              !stateLoading
                  ? ButtonComponent(
                      text: 'GUARDAR',
                      onPressed: () => widget.itemEdit == null ? saveCircleTrust() : editCircleTrust(),
                    )
                  : Center(
                      child: Image.asset(
                      'assets/gifs/load.gif',
                      fit: BoxFit.cover,
                      height: 20,
                    ))
            ])));
  }

  saveCircleTrust() async {
    final groupBloc = BlocProvider.of<GroupBloc>(context, listen: false);
    setState(() => stateLoading = true);
    final Map<String, String> body = {
      "name": nameCtrl.text.trim(),
      "description": descriptionCtrl.text.trim(),
      // "level": levelTrustCtrl!
      "level": "Bajo"
    };
    if (!mounted) return;
    var response = await serviceMethod(context, 'post', body, serviceCreateCircleTrust(), true, null);
    setState(() => stateLoading = false);
    if (response != null) {
      if (!mounted) return;
      return showSuccessful(context, response.data['msg'], () {
        groupBloc.add(UpdateCiclesTrust(circleTrustModelFromJson(json.encode(response.data['circlesTrust']))));
        if (!mounted) return;
        Navigator.of(context).pop();
      });
    }
  }

  editCircleTrust() async {
    final groupBloc = BlocProvider.of<GroupBloc>(context, listen: false);
    final Map<String, String> body = {
      "name": nameCtrl.text.trim(),
      "description": descriptionCtrl.text.trim(),
      "level": levelTrustCtrl!
    };
    if (!mounted) return;
    var response =
        await serviceMethod(context, 'put', body, serviceEditCircleTrust(widget.itemEdit!.groupId!), true, null);
    if (response != null) {
      if (!mounted) return;
      return showSuccessful(context, response.data['msg'], () {
        groupBloc.add(UpdateCiclesTrust(circleTrustModelFromJson(json.encode(response.data['circlesTrust']))));
        if (!mounted) return;
        Navigator.of(context).pop();
      });
    }
  }
}
