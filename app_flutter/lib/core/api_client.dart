import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';

/// Singleton HTTP client. Android emulator reaches the host machine at
/// 10.0.2.2; on a real device replace with your laptop's LAN IP.
class ApiClient {
  ApiClient._();
  static final ApiClient instance = ApiClient._();

  static const _storage = FlutterSecureStorage();
  final Dio dio = Dio(BaseOptions(
    baseUrl: 'http://10.0.2.2:8000',
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 5),
  ));

  Future<void> init() async {
    var deviceId = await _storage.read(key: 'device_id');
    if (deviceId == null) {
      deviceId = const Uuid().v4();
      await _storage.write(key: 'device_id', value: deviceId);
    }
    dio.options.headers['X-Device-Id'] = deviceId; // demo device fingerprint
  }

  Future<String> deviceId() async =>
      (await _storage.read(key: 'device_id')) ?? 'unknown';

  Future<Map<String, dynamic>> score(Map<String, dynamic> event) async =>
      Map<String, dynamic>.from((await dio.post('/v1/score', data: event)).data);

  Future<Map<String, dynamic>> totpEnroll(String userId) async {
    final deviceIdValue = await deviceId();
    final res = await dio.post('/v1/totp/enroll',
        data: {'user_id': userId, 'device_id': deviceIdValue});
    final data = Map<String, dynamic>.from(res.data);
    await _storage.write(key: 'totp_secret', value: data['secret'] as String);
    return data;
  }

  Future<bool> totpVerify(String userId, String code) async {
    final res = await dio
        .post('/v1/totp/verify', data: {'user_id': userId, 'code': code});
    return res.data['verified'] == true;
  }

  Future<Map<String, dynamic>> killSwitch(String userId) async =>
      Map<String, dynamic>.from(
          (await dio.post('/core/freeze', data: {'user_id': userId})).data);
}
