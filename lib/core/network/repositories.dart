import '../constants/api_constants.dart';
import '../models/models.dart';
import '../network/api_client.dart';
import '../session/session.dart';

class AuthRepository {
  AuthRepository(this._api, this._session);

  final ApiClient _api;
  final SessionController _session;

  Future<void> login({required String email, required String password}) async {
    final user = await _api.post(
      ApiConstants.login,
      body: {'email': email, 'password': password},
      parser: _parseUser,
    );
    await _session.cacheUser(user);
  }

  Future<void> register({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String idType,
    required String idNumber,
    required String password,
  }) async {
    final user = await _api.post(
      ApiConstants.register,
      body: {
        'full_name': fullName,
        'email': email,
        'phone_number': phoneNumber,
        'id_type': idType,
        'id_number': idNumber,
        'password': password,
      },
      parser: _parseUser,
    );
    await _session.cacheUser(user);
  }

  Future<String> forgotPassword(String email) async {
    return _api.post(
      ApiConstants.resetPassword,
      body: {'email': email},
      parser: (json) {
        if (json is Map<String, dynamic>) {
          return (json['message'] as String?) ?? 'Email reset sent successfully';
        }
        return 'Email reset sent successfully';
      },
    );
  }

  Future<User> getProfile() {
    return _api.get(ApiConstants.profile, parser: (json) {
      if (json is Map<String, dynamic> && json['data'] is Map<String, dynamic>) {
        return User.fromJson(json['data'] as Map<String, dynamic>);
      }
      throw Exception('Failed to load profile');
    });
  }

  Future<String> updateProfile({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String idNumber,
    String? password,
  }) {
    final body = <String, dynamic>{
      'full_name': fullName,
      'email': email,
      'phone_number': phoneNumber,
      'id_type': 'national_id',
      'id_number': idNumber,
    };
    if (password != null && password.isNotEmpty) {
      body['password'] = password;
    }
    return _api.post(
      ApiConstants.profile,
      body: body,
      parser: (json) {
        if (json is Map<String, dynamic>) {
          return (json['message'] as String?) ?? 'Profile updated successfully';
        }
        return 'Profile updated successfully';
      },
    );
  }

  User _parseUser(dynamic json) {
    if (json is Map<String, dynamic> && json['data'] is Map<String, dynamic>) {
      return User.fromJson(json['data'] as Map<String, dynamic>);
    }
    throw Exception('Invalid auth response');
  }
}

class FarmRepository {
  FarmRepository(this._api);

  final ApiClient _api;

  Future<List<LandData>> lands() {
    return _api.get(
      ApiConstants.lands,
      parser: (json) => _items(json, LandData.fromJson),
    );
  }

  Future<LandData?> landDetails(int id) {
    return _api.get(
      '${ApiConstants.lands}/$id',
      parser: (json) {
        if (json is Map<String, dynamic> && json['data'] is Map<String, dynamic>) {
          return LandData.fromJson(json['data'] as Map<String, dynamic>);
        }
        return null;
      },
    );
  }

  Future<List<OperationData>> operations() {
    return _api.get(
      ApiConstants.operations,
      parser: (json) => _items(json, OperationData.fromJson),
    );
  }

  Future<List<ContractData>> contracts() {
    return _api.get(
      ApiConstants.contracts,
      parser: (json) => _items(json, ContractData.fromJson),
    );
  }

  Future<ContractData?> contractDetails(int id) {
    return _api.get(
      '${ApiConstants.contracts}/$id',
      parser: (json) {
        if (json is Map<String, dynamic> && json['data'] is Map<String, dynamic>) {
          return ContractData.fromJson(json['data'] as Map<String, dynamic>);
        }
        return null;
      },
    );
  }

  Future<List<ProductionData>> productions() {
    return _api.get(
      ApiConstants.productions,
      parser: (json) => _items(json, ProductionData.fromJson),
    );
  }

  Future<List<FinancialData>> financials() {
    return _api.get(
      ApiConstants.financials,
      parser: (json) => _items(json, FinancialData.fromJson),
    );
  }

  Future<List<MediaData>> media() {
    return _api.get(
      ApiConstants.media,
      parser: (json) => _items(json, MediaData.fromJson),
    );
  }

  List<T> _items<T>(dynamic json, T Function(Map<String, dynamic>) fromJson) {
    if (json is Map<String, dynamic>) {
      return parseItems(json['data'], fromJson);
    }
    return <T>[];
  }
}
