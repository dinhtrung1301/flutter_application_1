class UserInfo {
  String name;
  DateTime? birthDate;
  AddressInfo? address;
  String? phoneNumber;
  String? email;

  UserInfo({
    this.name = '',
    this.birthDate,
    this.address,
    this.phoneNumber,
    this.email,
  });
  factory UserInfo.fromMap(Map<String, dynamic> map) {
    return UserInfo(
      name: map['name'],
      birthDate:
          map['birthDate'] != null ? DateTime.parse(map['birthDate']) : null,
      address:
          map['address'] != null ? AddressInfo.fromMap(map['address']) : null,
      phoneNumber: map['phoneNumber'],
      email: map['email'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'birthDate': birthDate?.toIso8601String(),
      'address': address?.toMap(),
      'phoneNumber': phoneNumber,
      'email': email,
    };
  }
}

class AddressInfo {
  Province? province;
  District? district;
  Ward? ward;
  String? street;

  AddressInfo({
    this.province,
    this.district,
    this.ward,
    this.street,
  });
  factory AddressInfo.fromMap(Map<String, dynamic> map) {
    return AddressInfo(
      province:
          map['province'] != null ? Province.fromMap(map['province']) : null,
      district:
          map['district'] != null ? District.fromMap(map['district']) : null,
      ward: map['ward'] != null ? Ward.fromMap(map['ward']) : null,
      street: map['street'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'province': province?.toMap(),
      'district': district?.toMap(),
      'ward': ward?.toMap(),
      'street': street,
    };
  }
}

class Province {
  int? id;
  String? name;

  Province({this.id, this.name});
  factory Province.fromMap(Map<String, dynamic> map) {
    return Province(
      id: map['id'],
      name: map['name'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class District {
  int? id;
  int? provinceId;
  String? name;

  District({this.id, this.provinceId, this.name});
  factory District.fromMap(Map<String, dynamic> map) {
    return District(
      id: map['id'],
      provinceId: map['provinceId'],
      name: map['name'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'provinceId': provinceId,
      'name': name,
    };
  }
}

class Ward {
  int? id;
  int? districtId;
  String? name;

  Ward({this.id, this.districtId, this.name});
  factory Ward.fromMap(Map<String, dynamic> map) {
    return Ward(
      id: map['id'],
      districtId: map['districtId'],
      name: map['name'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'districtId': districtId,
      'name': name,
    };
  }
}