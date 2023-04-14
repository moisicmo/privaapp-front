import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http_parser/http_parser.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:privaap/components/dialog_action.dart';
import 'package:privaap/components/image_input.dart';
import 'package:privaap/components/modal.dart';
import 'package:privaap/components/section_title.dart';
import 'package:privaap/main.dart';
import 'package:privaap/models/user_model.dart';
import 'package:privaap/providers/user_provider.dart';
import 'package:privaap/screens/pages/change_data.dart';
import 'package:privaap/screens/pages/change_pwd.dart';
import 'package:privaap/screens/verify_pwd.dart';
import 'package:privaap/services/service_method.dart';
import 'package:privaap/services/services.dart';
import 'package:privaap/utils/save_image_divice.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../components/paint.dart';

class MenuDrawer extends StatefulWidget {
  final GlobalKey keyGroup;
  const MenuDrawer({Key? key, required this.keyGroup}) : super(key: key);

  @override
  State<MenuDrawer> createState() => _MenuDrawerState();
}

class _MenuDrawerState extends State<MenuDrawer> {
  bool colorValue = false;
  bool biometricValue = false;
  bool autentificaction = false;
  String? fullPaths;
  String stateApp = '';

  bool status = true;
  bool sendNotifications = true;
  bool darkTheme = false;
  bool stateLoading = false;
  File? imageFile;
  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserData>(context, listen: true).userData;
    return Drawer(
      width: MediaQuery.of(context).size.width / 1.4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              color: const Color(0xff623D92),
              child: Center(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: ImageInputComponent(
                        image: userData!.avatar,
                        onPressed: (File value) {
                          setState(() {
                            imageFile = value;
                          });
                          updateImage();
                        },
                      ),
                    ),
                    Text(
                      'Hola ${userData.name!} ${userData.lastName!}!',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              )),
          Expanded(
            child: Stack(children: [
              const Formtop(),
              // const FormButtom(),
              SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text(
                        'Mis datos',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      ItemList(
                        icon: Icons.mail,
                        text: userData.email!,
                      ),
                      ItemList(
                        icon: Icons.phone,
                        text: 'Teléfono: ${userData.phone!}',
                      ),
                      ItemList(
                        icon: Icons.lock,
                        text: 'Cambiar contraseña',
                        stateLoading: stateLoading,
                        onPressed: () => changePassword(),
                      ),
                      const Divider(height: 0.03),
                      const Text(
                        'Configuración general',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      ItemList(
                        key: widget.keyGroup,
                        icon: Icons.campaign_rounded,
                        text: 'Círculos de confianza',
                        stateLoading: stateLoading,
                        onPressed: () => navigationGroups(),
                      ),
                      ItemList(
                        icon: Icons.privacy_tip,
                        text: 'Políticas de Privacidad',
                        stateLoading: stateLoading,
                        onPressed: () =>
                            launchUrl(Uri.parse(serviceGetPrivacyPolicy()), mode: LaunchMode.externalApplication),
                      ),
                      ItemList(
                        icon: Icons.info_outline,
                        text: 'Cerrar Sesión',
                        stateLoading: stateLoading,
                        onPressed: () => closeSession(context),
                      ),
                    ],
                  )),
              Positioned(
                // top: 100,
                bottom: 0,
                right: -120,
                child: Image.asset(
                  'assets/images/cruz.png',
                  fit: BoxFit.cover,
                  // height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width * 0.6,
                ),
              )
            ]),
          ),
          Center(
            child: Text('Versión ${dotenv.env['version']}'),
          )
        ],
      ),
    );
  }

  updateImage() async {
    final userData = Provider.of<UserData>(context, listen: false);
    String nameImageCover = await saveImage(imageFile!);
    FormData formData = FormData.fromMap({
      'archivo': await MultipartFile.fromFile(
        imageFile!.path,
        filename: nameImageCover,
        contentType: MediaType("image", "jpeg"),
      ),
    });
    if (!mounted) return;
    final response = await serviceMethod(context, 'postdio', null, changeImage(), true, formData);
    setState(() => stateLoading = false);
    if (response != null) {
      await userData.updateImage(response.data['image']!);
      prefs!.setString('user', userModelToJson(userData.userData));
    }
  }

  navigationGroups() {
    final sizeScreenModal = Provider.of<SizeScreenModal>(context, listen: false);
    sizeScreenModal.updateSizeScreen(2);
    return showBarModalBottomSheet(
      enableDrag: false,
      expand: false,
      context: context,
      builder: (context) => ModalComponent(
        title: 'Verificar contraseña',
        child: VerifyPassword(pwdCorrect: (value) {
          if (value) {
            Navigator.of(context).pop();
            Navigator.pushNamed(context, 'groups');
          }
        }),
      ),
    );
  }

  closeSession(BuildContext context) async {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return FadeIn(
              child: DialogTwoAction(
                  message: '¿Estás seguro que quieres cerrar sesión?',
                  actionCorrect: () => confirmDeleteSession(mounted, context, true),
                  messageCorrect: 'Salir'));
        });
  }

  void changePassword() async {
    return showBarModalBottomSheet(
      enableDrag: false,
      expand: false,
      context: context,
      builder: (context) => const ModalComponent(
        title: 'Nueva contraseña',
        child: ChangePassword(stateEmail: true),
      ),
    );
  }

  void changeDataUser() async {
    return showBarModalBottomSheet(
      enableDrag: false,
      expand: false,
      context: context,
      builder: (context) => const ModalComponent(
        title: 'Actualizar mis datos',
        child: ChangeData(),
      ),
    );
  }
}
