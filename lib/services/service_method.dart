import 'dart:async';
import 'dart:convert';
// import 'dart:convert';
import 'dart:io';
// import 'package:dio/adapter.dart';
import 'package:animate_do/animate_do.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:privaap/components/dialog_action.dart';
import 'package:privaap/main.dart';
import 'package:privaap/services/auth_service.dart';
import 'package:privaap/services/services.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

serviceMethod(BuildContext context, String method, Map<String, dynamic>? data, String urlAPI, bool accessToken,
    FormData? formData) async {
  final Map<String, String> headers = {
    "Content-Type": "application/json",
  };
  if (accessToken) {
    headers["Authorization"] = "Bearer ${await AuthService.readAccessToken()}";
  }
  final options = Options(validateStatus: (status) => status! <= 500, headers: headers);
  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      debugPrint('==========================================');
      debugPrint('== method $method');
      debugPrint('== url $urlAPI');
      debugPrint('== body $data');
      debugPrint('== headers $headers');
      debugPrint('==========================================');
      final dio = Dio();
      // ..options.baseUrl = 'https://pub.dev'
      // ..interceptors.add(LogInterceptor())
      // ..httpClientAdapter = Http2Adapter(
      //   ConnectionManager(
      //     onClientCreate: (_, config) => config.onBadCertificate = (_) => true,
      //   ),
      // );
      // (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (HttpClient dioClient) {
      //     dioClient.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
      //     return dioClient;
      //   };
      switch (method) {
        case 'get':
          try {
            return await dio.get(urlAPI, options: options).timeout(const Duration(seconds: 10)).then((value) {
              print('response.data ${value.data}');
              print('value.statusCode ${value.statusCode}');
              switch (value.statusCode) {
                case 200:
                  return value;
                default:
                  callDialogAction(context, value.data['errors'][0]['msg']);
                  return null;
              }
            }).catchError((err) {
              print('err $err');
              // Navigator.of(context).pop();
              return callDialogAction(context, 'Lamentamos los inconvenientes, intentalo más tarde');
            });
          } on DioError catch (error) {
            Navigator.of(context).pop();
            callDialogAction(context, error.response!.data);
            return null;
          }
        case 'post':
          try {
            return await dio
                .post(urlAPI, data: data, options: options)
                .timeout(const Duration(seconds: 20))
                .then((value) {
              print('response.data ${value.data}');
              print('value.statusCode ${value.statusCode}');
              switch (value.statusCode) {
                case 200:
                  return value;
                default:
                  callDialogAction(context, value.data['errors'][0]['msg']);
                  return null;
              }
            }).catchError((err) {
              print('err $err');
              // Navigator.of(context).pop();
              return callDialogAction(context, 'Lamentamos los inconvenientes, intentalo más tarde');
            });
          } on DioError catch (error) {
            Navigator.of(context).pop();
            return callDialogAction(context, error.response!.data);
          }
        case 'put':
          try {
            return await dio
                .put(urlAPI, data: data, options: options)
                .timeout(const Duration(seconds: 10))
                .then((value) {
              print('response.data ${value.data}');
              print('value.statusCode ${value.statusCode}');
              switch (value.statusCode) {
                case 200:
                  return value;
                default:
                  callDialogAction(context, value.data['errors'][0]['msg']);
                  return null;
              }
            }).catchError((err) {
              return callDialogAction(context, 'Lamentamos los inconvenientes, intentalo más tarde');
            });
          } on DioError catch (error) {
            callDialogAction(context, error.response!.data);
            return null;
          }
        case 'delete':
          try {
            return await dio.delete(urlAPI, options: options).timeout(const Duration(seconds: 10)).then((value) {
              print('response.data ${value.data}');
              print('value.statusCode ${value.statusCode}');
              switch (value.statusCode) {
                case 200:
                  return value;
                default:
                  callDialogAction(context, value.data['errors'][0]['msg']);
                  return null;
              }
            }).catchError((err) {
              return callDialogAction(context, 'Lamentamos los inconvenientes, intentalo más tarde');
            });
          } on DioError catch (error) {
            callDialogAction(context, error.response!.data);
            return null;
          }
        case 'postdio':
          try {
            return await dio
                .postUri(Uri.parse(urlAPI), data: formData, options: options)
                .timeout(const Duration(seconds: 10))
                .then((value) {
              print('response.data ${value.data}');
              print('value.statusCode ${value.statusCode}');
              switch (value.statusCode) {
                case 200:
                  return value;
                default:
                  callDialogAction(context, value.data['errors'][0]['msg']);
                  return null;
              }
            }).catchError((err) {
              return callDialogAction(context, 'Lamentamos los inconvenientes, intentalo más tarde');
            });
          } on DioError catch (error) {
            callDialogAction(context, error.response!.data);
            return null;
          }
      }
    }
  } on SocketException catch (e) {
    // Navigator.of(context).pop();
    return callDialogAction(context, 'Verifique su conexión a Internet');
  } on TimeoutException catch (e) {
    return callDialogAction(context, 'Lamentamos los inconvenientes, intentalo más tarde');
  } catch (e) {
    return callDialogAction(context, 'Lamentamos los inconvenientes, tenemos problemas con los servidores');
  }
}

void callDialogAction(BuildContext context, String message) {
  showDialog(
      barrierDismissible: false, context: context, builder: (BuildContext context) => DialogAction(message: message));
}

confirmDeleteSession(bool mounted, BuildContext context, bool voluntary) async {
  final authService = Provider.of<AuthService>(context, listen: false);
  authService.logout();
  prefs!.clear();
  Navigator.pushReplacementNamed(context, 'checking');
}

Future<bool> checkVersion(BuildContext context) async {
  try {
    final result = await InternetAddress.lookup('pvt.muserpol.gob.bo');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      final Map<String, dynamic> data = {'version': dotenv.env['version']};
      if (Platform.isIOS) {
        data['store'] = dotenv.env['storeIOS'];
      }
      if (Platform.isAndroid) {
        data['store'] = dotenv.env['storeAndroid'];
      }
      // ignore: use_build_context_synchronously
      var response = await serviceMethod(context, 'post', data, servicePostVersion(), false, null);
      if (response != null) {
        debugPrint('${response.data['msg']}');
        if (response.data['error']) {
          return await showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) => FadeIn(
                  child: DialogOneFunction(
                      title: response.data['msg'],
                      message: 'Para mejorar la experiencia, Porfavor actualiza la nueva versión',
                      textButton: 'Actualizar',
                      onPressed: () async {
                        launchUrl(Uri.parse(response.data['store']), mode: LaunchMode.externalApplication);
                      })));
        }
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  } on SocketException catch (e) {
    debugPrint('errC $e');
    callDialogAction(context, 'Verifique su conexión a Internet');
    return false;
  } catch (e) {
    debugPrint('errG $e');
    callDialogAction(context, '$e');
    return false;
  }
}
