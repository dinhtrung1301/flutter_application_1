import 'package:flutter/material.dart';
import 'dart:math';

class MyObject {
  int value;

  MyObject({
    required this.value,
  });
//tăng giá trị lên 1
  void increase() {
    value++;
  }

//giảm giá trị đi 1
  void decrease() {
    value--;
  }

//trong dart khi khai báo một thuộc tính có get hoặc set không nên sử dụng cùng tên cho thuộc tính và biến điều này dẫn đến 1 vòng lắp vô hạn
  //trả về giá trị
  int get _value => value;
  //đặt giá trị
  set _value(int newValue) {
    value = newValue;
  }

  // nhân giá trị
  void multiply(int factor) {
    value *= factor;
  }

//chia giá trị
  void divide(int divisor) {
    if (divisor != 0) {
      value ~/= divisor;
    }
  }

//tính lũy thừa
  int power(int exponent) {
    return value = value ^ exponent;
  }

  void printInfo() {
    print('Giá trị của đối tượng là: $value');
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //tạo đối tượng _myObject từ lớp MyObject vì lớp MyObject yêu cầu 1 tham số value nên phải truyền giá trị cho _myObject
  MyObject _myObject = MyObject(value: 0);

  void _increaseValue() {
    setState(() {
      _myObject.increase();
      _myObject.printInfo();
    });
  }

  void _decreaseValue() {
    setState(() {
      _myObject.decrease();
      _myObject.printInfo();
    });
  }

  void _setValue() {
    setState(() {
      _myObject.value = 10;
      _myObject.printInfo();
    });
  }

  void _multiplyValue() {
    setState(() {
      _myObject.multiply(2);
      _myObject.printInfo();
    });
  }

  void _divideValue() {
    setState(() {
      _myObject.divide(2);
      _myObject.printInfo();
    });
  }

  void _poverValue() {
    setState(() {
      _myObject.power(2);
      _myObject.printInfo();
    });
  }
// việc tạo đối tượng từ class MyObject thay vì biến int _value có tính kế thừa thuận tiện và linh hoạt hơn chỉ cần thay đổi trong lớp MyObject không cần sửa đổi nhiều đoạn code khác

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MyObject App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Giá trị của đối tượng: ${_myObject.value}'),
            SizedBox(height: 13),
            ElevatedButton(
              onPressed: _increaseValue,
              child: Text('Tăng'),
            ),
            SizedBox(height: 12),
            ElevatedButton(
              onPressed: _decreaseValue,
              child: Text('Giảm'),
            ),
            SizedBox(height: 11),
            ElevatedButton(
              onPressed: _setValue,
              child: Text('đặt giá trị'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _multiplyValue,
              child: Text('nhân giá trị với 2'),
            ),
            SizedBox(height: 9),
            ElevatedButton(
              onPressed: _divideValue,
              child: Text('chia giá trị cho 2'),
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: _divideValue,
              child: Text('tính lũy thừa'),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MyApp());
}