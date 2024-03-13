import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localstore/localstore.dart';
import 'package:intl/intl.dart';

import 'UserInfo.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});
  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final step1FormKey = GlobalKey<FormState>();
  final step2FormKey = GlobalKey<FormState>();

  int currentStep = 0;
  UserInfo userInfo = UserInfo();
  bool isLoated = false;
  Future<UserInfo> init() async {
    if (isLoated) return userInfo;
    var value = await loadUserInfo();
    if (value != null) {
      try {
        isLoated = true;
        return UserInfo.fromMap(value);
      } catch (e) {
        debugPrint(e.toString());
        return UserInfo();
      }
    }

    return UserInfo();
  }

  @override
  Widget build(BuildContext context) {
    void updateStep(int value) {
      if (currentStep == 0) {
        if (step1FormKey.currentState!.validate()) {
          step2FormKey.currentState!.save();
          setState(() {
            currentStep = value;
          });
        }
      } else if (currentStep == 1) {
        if (value > currentStep) {
          if (step2FormKey.currentState!.validate()) {
            step2FormKey.currentState!.save();
            setState(() {
              currentStep = value;
            });
          }
        } else {
          setState(() {
            currentStep = value;
          });
        }
      } else if (currentStep == 2) {
        setState(() {
          if (value < currentStep) {
            currentStep = value;
          } else {
            saveUserInfo(userInfo).then((value) {
              showDialog<void>(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('thong bao'),
                    content: const SingleChildScrollView(
                      child: ListBody(
                        children: [
                          Text('ho so nguoi dung da duoc luu thanh cong'),
                          Text('ban co the quay lai cac buoc de cap nhap'),
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(
                        child: const Text('đóng'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            });
          }
        });
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('cập nhập hồ sơ'),
        actions: [
          IconButton(
            onPressed: () {
              showDialog<bool>(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('xác nhận'),
                    content: const Text('bạn có muốn xóa thoonh tin đã lưu'),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('hủy'),
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                      ),
                      TextButton(
                        child: const Text('hủy'),
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                      ),
                    ],
                  );
                },
              ).then((value) {
                if (value != null && value == true) {
                  setState(() {
                    userInfo = UserInfo();
                  });
                  saveUserInfo(userInfo);
                }
              });
            },
            icon: const Icon(Icons.delete_outlined),
          )
        ],
      ),
      body: FutureBuilder<UserInfo>(
        future: init(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            userInfo = snapshot.data!;
            return Stepper(
              type: StepperType.horizontal,
              currentStep: currentStep,
              controlsBuilder: (context, details) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Wrap(
                      children: [
                        if (currentStep == 2)
                          FilledButton(
                            onPressed: details.onStepContinue,
                            child: const Text('lưu'),
                          )
                        else
                          FilledButton.tonal(
                            onPressed: details.onStepContinue,
                            child: const Text('TIẾP'),
                          ),
                        if (currentStep > 0)
                          TextButton(
                            onPressed: details.onStepContinue,
                            child: const Text('quay lại'),
                          ),
                      ],
                    ),
                    if (currentStep == 2)
                      OutlinedButton(
                        onPressed: () {},
                        child: const Text('đóng'),
                      )
                  ],
                );
              },
              onStepTapped: (value) {
                updateStep(value);
              },
              onStepContinue: () {
                updateStep(currentStep + 1);
              },
              onStepCancel: () {
                if (currentStep > 0) {
                  setState(() {
                    currentStep--;
                  });
                }
              },
              steps: [
                Step(
                  title: const Text('cơ bản'),
                  content: Step1Form(formKey: step1FormKey, userInfo: userInfo),
                  isActive: currentStep == 0,
                ),
                Step(
                    title: const Text('địa chỉ'),
                    content:
                        Step2Form(formKey: step2FormKey, userInfo: userInfo),
                    isActive: currentStep == 1),
                Step(
                    title: const Text('xác nhận'),
                    content: ConfirmInfo(userInfo: userInfo),
                    isActive: currentStep == 2),
              ],
            );
          } else if (snapshot.hasError) {
            return Center(child: Text("Lỗi: ${snapshot.error}"));
          } else {
            return const Center(child: LinearProgressIndicator());
          }
        },
      ),
    );
  }
}

class Step1Form extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final UserInfo userInfo;
  const Step1Form({
    super.key,
    required this.formKey,
    required this.userInfo,
  });
  @override
  State<Step1Form> createState() => _Step1FormState();
}

class _Step1FormState extends State<Step1Form> {
  final nameCtl = TextEditingController();

  final dateCtl = TextEditingController();

  final emailCtl = TextEditingController();

  final phoneCtl = TextEditingController();

  bool isEmailValid(String email) {
    String pattern =
        r"^[a-zA-Z0-9.a-zA-z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-z0-9]+\.[a-zA-Z]+";
    final emailRegex = RegExp(pattern);
    return emailRegex.hasMatch(email);
  }

  bool isMobileValid(String value) {
    String pattern = r"(^(?:[+0]9)?[0-9]{10,12}$)";
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(value);
  }

  @override
  Widget build(BuildContext context) {
    nameCtl.text = widget.userInfo.name ?? '';
    dateCtl.text = widget.userInfo.birthDate != null
        ? DateFormat('dd/MM/yyyy').format(widget.userInfo.birthDate!)
        : '';
    emailCtl.text = widget.userInfo.email ?? '';
    phoneCtl.text = widget.userInfo.phoneNumber ?? '';
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Form(
        key: widget.formKey,
        child: Column(
          children: [
            TextFormField(
              controller: nameCtl,
              decoration: const InputDecoration(labelText: 'họ và tên'),
              keyboardType: TextInputType.name,
              textCapitalization: TextCapitalization.words,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'vui lòng nhập họ và tên';
                }
                return null;
              },
              onChanged: (value) => widget.userInfo.name = value,
            ),
            TextFormField(
              controller: dateCtl,
              decoration: const InputDecoration(
                labelText: "ngày sinh",
                hintText: " nhập ngày sinh",
              ),
              onTap: () async {
                DateTime? date = DateTime(1900);
                FocusScope.of(context).requestFocus(FocusNode());
                date = await showDatePicker(
                    context: context,
                    initialEntryMode: DatePickerEntryMode.calendarOnly,
                    initialDate: widget.userInfo.birthDate ?? DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime(2100));
                if (date != null) {
                  widget.userInfo.birthDate = date;
                  dateCtl.text = DateFormat('dd/MM/yyyy').format(date);
                }
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'vui lòng nhập ngày sinh';
                }
                try {
                  DateFormat('dd/MM/yyyy').parse(value);
                  return null;
                } catch (e) {
                  return 'ngày sinh không hợp lệ';
                }
              },
            ),
            TextFormField(
              controller: emailCtl,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'vui lòng nhập email';
                } else if (!isEmailValid(value)) {
                  return 'định dạng email không hợp lệ';
                }
                return null;
              },
              onChanged: (value) => widget.userInfo.email = value,
            ),
            TextFormField(
              controller: phoneCtl,
              decoration: const InputDecoration(labelText: 'số điện thoại'),
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'vui lòng nhập số điện thoại';
                } else if (!isMobileValid(value)) {
                  return 'định dạng số điện thoại không hợp lệ';
                }
                return null;
              },
              onChanged: (value) => widget.userInfo.phoneNumber = value,
            ),
          ],
        ),
      ),
    );
  }
}

class Step2Form extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final UserInfo userInfo;
  const Step2Form({
    super.key,
    required this.formKey,
    required this.userInfo,
  });

  @override
  State<Step2Form> createState() => _Step2FormState();
}

class _Step2FormState extends State<Step2Form> {
  final streeCtl = TextEditingController();

  List<Province> provinceList = [];
  List<District> districtList = [];
  List<Ward> wardList = [];
  String removeDiacritics(String input) {
    return input.replaceAll(RegExp(r'[^\x00-\x7F]+'), '');
  }

  @override
  void initState() {
    loadLocationData().then((value) => setState(() {}));
    super.initState();
  }

  Future<void> loadLocationData() async {
    try {
      String data =
          await rootBundle.loadString('don_vi_hanh_chinh.json');
      Map<String, dynamic> jsonData = json.decode(data);
      List provinceData = jsonData['province'];
      provinceList =
          provinceData.map((json) => Province.fromMap(json)).toList();
      List districtData = jsonData['district'];
      districtList =
          districtData.map((json) => District.fromMap(json)).toList();
      List wardData = jsonData['ward'];
      wardList = wardData.map((json) => Ward.fromMap(json)).toList();
    } catch (e) {
      debugPrint('loading location data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    streeCtl.text = widget.userInfo.address?.street ?? '';
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Form(
        key: widget.formKey,
        child: Column(
          children: [
            Autocomplete<Province>(
              fieldViewBuilder: (
                context,
                textEditingController,
                focusNode,
                onFieldSubmitted,
              ) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  textEditingController.text =
                      widget.userInfo.address?.province?.name ?? '';
                });
                return TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'tỉnh / thành phố',
                  ),
                  controller: textEditingController,
                  focusNode: focusNode,
                  validator: (value) {
                    if (widget.userInfo.address?.province == null ||
                        value!.isEmpty) {
                      return 'vui lòng chọn một tỉnh / thành phố';
                    }
                    return null;
                  },
                );
              },
              displayStringForOption: (option) => option.name!,
              optionsBuilder: (textEditingValue) {
                if (textEditingValue.text.isEmpty) {
                  return provinceList;
                }
                return provinceList.where((element) {
                  final title = removeDiacritics(element.name ?? '');
                  final keyword = removeDiacritics(textEditingValue.text);
                  final pattern = r'\b(' + keyword + r')\b';
                  final regExp = RegExp(pattern, caseSensitive: false);
                  return title.isNotEmpty && regExp.hasMatch(title);
                });
              },
              onSelected: (option) {
                if (widget.userInfo.address?.province != option) {
                  setState(() {
                    widget.userInfo.address = AddressInfo(province: option);
                  });
                }
              },
            ),
            Autocomplete<District>(
              fieldViewBuilder: (
                context,
                textEditingController,
                focusNode,
                onFieldSubmitted,
              ) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  textEditingController.text =
                      widget.userInfo.address?.district?.name ?? '';
                });
                return TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'huyện / quận',
                  ),
                  controller: textEditingController,
                  focusNode: focusNode,
                  validator: (value) {
                    if (widget.userInfo.address?.district == null ||
                        value!.isEmpty) {
                      return 'vui lòng nhập lại một huyện quận';
                    }
                    return null;
                  },
                );
              },
              displayStringForOption: (option) => option.name!,
              optionsBuilder: (textEditingValue) {
                if (textEditingValue.text.isEmpty) {
                  return districtList.where((element) =>
                      widget.userInfo.address?.province?.id != null &&
                      element.provinceId ==
                          widget.userInfo.address?.province?.id);
                }
                return districtList.where((element) {
                  var cond1 = element.provinceId ==
                      widget.userInfo.address?.province?.id;
                  final title = removeDiacritics(element.name ?? '');
                  final keyword = removeDiacritics(textEditingValue.text);
                  final pattern = r'\b(' + keyword + r')\b';
                  final regExp = RegExp(pattern, caseSensitive: false);
                  return cond1 && title.isNotEmpty && regExp.hasMatch(title);
                });
              },
              onSelected: (option) {
                if (widget.userInfo.address?.district != option) {
                  setState(() {
                    widget.userInfo.address?.district = option;
                    widget.userInfo.address?.ward = null;
                  });
                }
              },
            ),
            Autocomplete<Ward>(
              fieldViewBuilder: (
                context,
                textEditingController,
                focusNobe,
                onFieldSubmitted,
              ) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  textEditingController.text =
                      widget.userInfo.address?.ward?.name ?? '';
                });
                return TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'xã / phường / thị trấn',
                  ),
                  controller: textEditingController,
                  focusNode: focusNobe,
                  validator: (value) {
                    if (widget.userInfo.address?.ward == null ||
                        value!.isEmpty) {
                      return 'vui lòng chọn một xã / phường/ thị trấn';
                    }
                    return null;
                  },
                );
              },
              displayStringForOption: (option) => option.name!,
              optionsBuilder: (textEditingValue) {
                if (textEditingValue.text.isEmpty) {
                  return wardList.where((element) =>
                      element.districtId ==
                      widget.userInfo.address?.district?.id);
                }
                return wardList.where((element) {
                  var cond1 = element.districtId ==
                      widget.userInfo.address?.district?.id;
                  final title = removeDiacritics(element.name ?? '');
                  final keyword = removeDiacritics(textEditingValue.text);
                  final pattern = r'\b(' + keyword + r')\b';
                  final regExp = RegExp(pattern, caseSensitive: false);
                  return cond1 && title.isNotEmpty && regExp.hasMatch(title);
                });
              },
              onSelected: (option) {
                widget.userInfo.address?.ward = option;
              },
            ),
            TextFormField(
              controller: streeCtl,
              decoration: const InputDecoration(labelText: 'địa chỉ'),
              keyboardType: TextInputType.streetAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'vui lòng nhập địa chỉ';
                }
                return null;
              },
              onSaved: (value) {
                widget.userInfo.address?.street = value!;
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ConfirmInfo extends StatelessWidget {
  final UserInfo userInfo;

  const ConfirmInfo({
    super.key,
    required this.userInfo,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoItem('họ và tên:', userInfo.name),
          _buildInfoItem(
            'ngày sinh: ',
            userInfo.birthDate != null
                ? DateFormat('dd/MM.yyyy').format(userInfo.birthDate!)
                : '',
          ),
          _buildInfoItem('email:', userInfo.email),
          _buildInfoItem('sdt:', userInfo.phoneNumber),
          _buildInfoItem('tỉnh / thành phố', userInfo.address?.province?.name),
          _buildInfoItem('quận / huyện:', userInfo.address?.district?.name),
          _buildInfoItem(
              'xã / phường / thị trấn:', userInfo.address?.ward?.name),
          _buildInfoItem('địa chỉ:', userInfo.address?.street),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        readOnly: true,
        controller: TextEditingController(text: value),
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.all(8.0),
        ),
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}

Future<void> saveUserInfo(UserInfo info) async {
  return await Localstore.instance
      .collection('users')
      .doc('info')
      .set(info.toMap());
}

Future<Map<String, dynamic>?> loadUserInfo() async {
  return await Localstore.instance.collection('users').doc('info').get();
}