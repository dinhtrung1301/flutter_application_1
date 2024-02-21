class Province {
  int id;
  String name;
  int level;

  Province({required this.id, required this.name, required this.level});

  factory Province.fromMap(Map<String, dynamic> map) {
    return Province(
      id: map['id'],
      name: map['name'],
      level: map['level'],
    );
  }
}

class District {
  int id;
  String name;
  int level;
  int provinceId;

  District(
      {required this.id,
      required this.name,
      required this.level,
      required this.provinceId});

  factory District.fromMap(Map<String, dynamic> map) {
    return District(
      id: map['id'],
      name: map['name'],
      level: map['level'],
      provinceId: map['provinceId'],
    );
  }
}

class Ward {
  int id;
  String name;
  int level;
  int districtId;

  Ward(
      {required this.id,
      required this.name,
      required this.level,
      required this.districtId});

  factory Ward.fromMap(Map<String, dynamic> map) {
    return Ward(
      id: map['id'],
      name: map['name'],
      level: map['level'],
      districtId: map['districtId'],
    );
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
      province: Province.fromMap(map['province']),
      district: District.fromMap(map['district']),
      ward: Ward.fromMap(map['ward']),
      street: map['street'],
    );
  }
}

class UserInfo {
  String? name;
  String? email;
  String? phoneNumber;
  DateTime? birthDate;
  AddressInfo? address;

  UserInfo({
    this.name,
    this.email,
    this.phoneNumber,
    this.birthDate,
    this.address,
  });

  factory UserInfo.fromMap(Map<String, dynamic> map) {
    return UserInfo(
      name: map['name'],
      email: map['email'],
      phoneNumber: map['phoneNumber'],
      birthDate: DateTime.parse(map['birthDate']),
      address: AddressInfo.fromMap(map['address']),
    );
  }
}