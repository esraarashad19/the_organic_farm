class User {
  const User({
    this.id,
    this.name,
    this.fullName,
    this.email,
    this.idType,
    this.idNumber,
    this.phoneNumber,
    this.token,
  });

  final int? id;
  final String? name;
  final String? fullName;
  final String? email;
  final String? idType;
  final String? idNumber;
  final String? phoneNumber;
  final String? token;

  String get displayName => fullName?.trim().isNotEmpty == true
      ? fullName!
      : (name ?? '').trim();

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int?,
      name: json['name'] as String?,
      fullName: json['full_name'] as String?,
      email: json['email'] as String?,
      idType: json['id_type'] as String?,
      idNumber: json['id_number'] as String?,
      phoneNumber: json['phone_number'] as String?,
      token: json['token'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'full_name': fullName,
        'email': email,
        'id_type': idType,
        'id_number': idNumber,
        'phone_number': phoneNumber,
        'token': token,
      };
}

class LandRef {
  const LandRef({required this.id, required this.landNumber});

  final int id;
  final String landNumber;

  factory LandRef.fromJson(Map<String, dynamic> json) {
    return LandRef(
      id: json['id'] as int? ?? 0,
      landNumber: json['land_number']?.toString() ?? '',
    );
  }
}

class LandData {
  const LandData({
    this.id,
    this.landNumber,
    this.size,
    this.numberOfPits,
    this.numberOfPalms,
    this.cultivationCount,
    this.missingCount,
  });

  final int? id;
  final String? landNumber;
  final String? size;
  final int? numberOfPits;
  final int? numberOfPalms;
  final String? cultivationCount;
  final String? missingCount;

  factory LandData.fromJson(Map<String, dynamic> json) {
    return LandData(
      id: json['id'] as int?,
      landNumber: json['land_number']?.toString(),
      size: json['size']?.toString(),
      numberOfPits: json['number_of_pits'] as int?,
      numberOfPalms: json['number_of_palms'] as int?,
      cultivationCount: json['cultivation_count']?.toString(),
      missingCount: json['missing_count']?.toString(),
    );
  }
}

class OperationItem {
  const OperationItem({this.id, this.description, this.order});

  final int? id;
  final String? description;
  final int? order;

  factory OperationItem.fromJson(Map<String, dynamic> json) {
    return OperationItem(
      id: json['id'] as int?,
      description: json['description'] as String?,
      order: json['order'] as int?,
    );
  }
}

class OperationData {
  const OperationData({
    required this.id,
    this.description,
    this.pastOperations = const [],
    this.currentOperations = const [],
    this.futureOperations = const [],
    this.user,
    this.land,
  });

  final int id;
  final String? description;
  final List<OperationItem> pastOperations;
  final List<OperationItem> currentOperations;
  final List<OperationItem> futureOperations;
  final User? user;
  final LandRef? land;

  String _join(List<OperationItem> items) {
    return items
        .map((e) => '${e.order ?? 0}- ${e.description ?? ''}')
        .join('\n');
  }

  String get pastText => _join(pastOperations);
  String get currentText => _join(currentOperations);
  String get futureText => _join(futureOperations);

  factory OperationData.fromJson(Map<String, dynamic> json) {
    List<OperationItem> parseOps(String key) {
      final list = json[key] as List? ?? [];
      return list
          .whereType<Map<String, dynamic>>()
          .map(OperationItem.fromJson)
          .toList();
    }

    return OperationData(
      id: json['id'] as int? ?? 0,
      description: json['description'] as String?,
      pastOperations: parseOps('past_operations'),
      currentOperations: parseOps('current_operations'),
      futureOperations: parseOps('future_operations'),
      user: json['user'] is Map<String, dynamic>
          ? User.fromJson(json['user'] as Map<String, dynamic>)
          : null,
      land: json['land'] is Map<String, dynamic>
          ? LandRef.fromJson(json['land'] as Map<String, dynamic>)
          : null,
    );
  }
}

class ContractDocuments {
  const ContractDocuments({
    this.sponsorshipContractUrl,
    this.participationContractUrl,
    this.personalIdUrl,
  });

  final String? sponsorshipContractUrl;
  final String? participationContractUrl;
  final String? personalIdUrl;

  factory ContractDocuments.fromJson(Map<String, dynamic> json) {
    return ContractDocuments(
      sponsorshipContractUrl: json['sponsorship_contract_url'] as String?,
      participationContractUrl: json['participation_contract_url'] as String?,
      personalIdUrl: json['personal_id_url'] as String?,
    );
  }
}

class ContractData {
  const ContractData({
    required this.id,
    this.user,
    this.land,
    this.documents,
  });

  final int id;
  final User? user;
  final LandRef? land;
  final ContractDocuments? documents;

  factory ContractData.fromJson(Map<String, dynamic> json) {
    return ContractData(
      id: json['id'] as int? ?? 0,
      user: json['user'] is Map<String, dynamic>
          ? User.fromJson(json['user'] as Map<String, dynamic>)
          : null,
      land: json['land'] is Map<String, dynamic>
          ? LandRef.fromJson(json['land'] as Map<String, dynamic>)
          : null,
      documents: json['documents'] is Map<String, dynamic>
          ? ContractDocuments.fromJson(json['documents'] as Map<String, dynamic>)
          : null,
    );
  }
}

class ProductionItem {
  const ProductionItem({this.id, this.text, this.order});

  final int? id;
  final String? text;
  final int? order;

  factory ProductionItem.fromJson(Map<String, dynamic> json) {
    return ProductionItem(
      id: json['id'] as int?,
      text: json['text'] as String?,
      order: json['order'] as int?,
    );
  }
}

class ProductionData {
  const ProductionData({
    required this.id,
    this.description,
    this.pastProductions = const [],
    this.currentProductions = const [],
    this.user,
    this.land,
  });

  final int id;
  final String? description;
  final List<ProductionItem> pastProductions;
  final List<ProductionItem> currentProductions;
  final User? user;
  final LandRef? land;

  String _join(List<ProductionItem> items) {
    return items.map((e) => '${e.order ?? 0}- ${e.text ?? ''}').join('\n');
  }

  String get pastText => _join(pastProductions);
  String get currentText => _join(currentProductions);

  factory ProductionData.fromJson(Map<String, dynamic> json) {
    List<ProductionItem> parse(String key) {
      final list = json[key] as List? ?? [];
      return list
          .whereType<Map<String, dynamic>>()
          .map(ProductionItem.fromJson)
          .toList();
    }

    return ProductionData(
      id: json['id'] as int? ?? 0,
      description: json['description'] as String?,
      pastProductions: parse('past_productions'),
      currentProductions: parse('current_productions'),
      user: json['user'] is Map<String, dynamic>
          ? User.fromJson(json['user'] as Map<String, dynamic>)
          : null,
      land: json['land'] is Map<String, dynamic>
          ? LandRef.fromJson(json['land'] as Map<String, dynamic>)
          : null,
    );
  }
}

class FinanceRecord {
  const FinanceRecord({
    required this.id,
    required this.month,
    required this.date,
    required this.amount,
  });

  final int id;
  final String month;
  final String date;
  final String amount;

  factory FinanceRecord.fromJson(Map<String, dynamic> json) {
    return FinanceRecord(
      id: json['id'] as int? ?? 0,
      month: json['month']?.toString() ?? '',
      date: json['date']?.toString() ?? '',
      amount: json['amount']?.toString() ?? '',
    );
  }
}

class FinancialData {
  const FinancialData({
    required this.id,
    this.fileUrl,
    this.records = const [],
    this.user,
    this.land,
  });

  final int id;
  final String? fileUrl;
  final List<FinanceRecord> records;
  final User? user;
  final LandRef? land;

  factory FinancialData.fromJson(Map<String, dynamic> json) {
    final records = (json['records'] as List? ?? [])
        .whereType<Map<String, dynamic>>()
        .map(FinanceRecord.fromJson)
        .toList();
    return FinancialData(
      id: json['id'] as int? ?? 0,
      fileUrl: json['file_url'] as String?,
      records: records,
      user: json['user'] is Map<String, dynamic>
          ? User.fromJson(json['user'] as Map<String, dynamic>)
          : null,
      land: json['land'] is Map<String, dynamic>
          ? LandRef.fromJson(json['land'] as Map<String, dynamic>)
          : null,
    );
  }
}

class MediaFile {
  const MediaFile({this.id, this.filePath, this.date});

  final int? id;
  final String? filePath;
  final String? date;

  factory MediaFile.fromJson(Map<String, dynamic> json) {
    return MediaFile(
      id: json['id'] as int?,
      filePath: json['file_path'] as String?,
      date: json['date'] as String?,
    );
  }
}

class MediaData {
  const MediaData({
    required this.id,
    this.user,
    this.land,
    this.images = const [],
    this.videos = const [],
  });

  final int id;
  final User? user;
  final LandRef? land;
  final List<MediaFile> images;
  final List<MediaFile> videos;

  factory MediaData.fromJson(Map<String, dynamic> json) {
    List<MediaFile> parse(String key) {
      final list = json[key] as List? ?? [];
      return list
          .whereType<Map<String, dynamic>>()
          .map(MediaFile.fromJson)
          .toList();
    }

    return MediaData(
      id: json['id'] as int? ?? 0,
      user: json['user'] is Map<String, dynamic>
          ? User.fromJson(json['user'] as Map<String, dynamic>)
          : null,
      land: json['land'] is Map<String, dynamic>
          ? LandRef.fromJson(json['land'] as Map<String, dynamic>)
          : null,
      images: parse('images'),
      videos: parse('videos'),
    );
  }
}

List<T> parseItems<T>(
  dynamic data,
  T Function(Map<String, dynamic> json) fromJson,
) {
  if (data is Map<String, dynamic>) {
    final items = data['items'];
    if (items is List) {
      return items.whereType<Map<String, dynamic>>().map(fromJson).toList();
    }
  }
  return <T>[];
}
