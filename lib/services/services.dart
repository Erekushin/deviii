import 'package:devita/screens/login/login_page.dart';
import 'package:get/route_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class Services {
  var storage = GetStorage();

  /// [postRequest] post service request
  /// [data] request body data
  /// [token] check for token usage

  Future<http.Response> postRequest(
      Object bodyData, String url, bool token) async {
    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'authorization': token == true ? storage.read("token").toString() : ''
      },
      body: bodyData,
    );
    if (response.statusCode == 401) {
      storage.erase();
      Get.to(() => const LoginPage());
    }

    return response;
  }

  /// [getRequest] get service request
  /// [bodyData] request body data
  /// [token] check for token usage

  Future<http.Response> getRequest(String url, bool token) async {
    return http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'authorization': token == true ? storage.read("token").toString() : ''
      },
    );
  }

  /// [uploadImage]upload image formdata
  /// [imageType] upload image type: PROFILE(profile image), FRONT(IdCardFront), BACK, SELFIE(id card with selfie image), FACE(face image)
  /// [url] service url
  /// [formData] upload image formdata

  Future uploadImage(filepath, String url, bool token, String imageType) async {
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.files.add(await http.MultipartFile.fromPath('file', filepath));
    request.fields['image_type'] = imageType;
    request.headers['authorization'] =
        token == true ? storage.read("token").toString() : '';
    var res = await request.send();
    if (res.statusCode == 401) {
      storage.erase();
      Get.to(() => const LoginPage());
    } else {
      var bodyResponse = await res.stream.bytesToString();
      return bodyResponse;
    }
  }
}
