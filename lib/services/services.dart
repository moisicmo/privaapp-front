import 'package:flutter_dotenv/flutter_dotenv.dart';

String? url = dotenv.env['HOST_URL'];

String? apiOpenWeather = dotenv.env['API_OPEN_WEATHER'];

String serviceRegister() => '$url/users/register';

String serviceVerifyUser(int id) => '$url/users/validate/$id';
//LOGIN OR LOGOUTH
String serviceAuthSession() => '$url/users/auth';

String serviceWeather(double lat, double lon) =>
    'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiOpenWeather&units=metric&lang=es';

String serviceGetPrivacyPolicy() => 'https://www.google.com';

String serviceGetAllCirclesTrust() => '$url/groups';

String serviceCreateCircleTrust() => '$url/groups/register';

String serviceEditCircleTrust(int id) => '$url/groups/$id';

String serviceRemoveCircleTrust(int id) => '$url/groups/$id';

String serviceCreateGuest() => '$url/guests';

String serviceConfirmGuest() => '$url/guests/confirm';

String serviceSendAlert() => '$url/alerts/register';

String removeUserFromGroupId(int groupId, int userId) => '$url/groups/$groupId/user/$userId';

String requestChangePwd() => '$url/users/send_change_password';

String validateChangePWd() => '$url/users/validate_change_password';

String verifyPwd() => '$url/users/verify_password';

String changeImage() => '$url/users/update/image';
