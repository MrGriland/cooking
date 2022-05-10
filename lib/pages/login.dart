import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:cooking/network/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';

import 'home.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/auth';
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Duration get loginTime => const Duration(milliseconds: 1250);
  final NetworkService _networkService = NetworkService();

  Future<String?> _authUser(LoginData data) {
    debugPrint('Name: ${data.name}, Password: ${data.password}');
    setState(() {
      _buildBeginScreen(context);
    });
    return Future.value(_networkService.login(data.name, data.password)).then(
      (x) {
        if (!x) {
          return 'Проверьте введённые данные';
        }
        return null;
      },
    );
  }

  Future<String?> _signupUser(SignupData data) {
    debugPrint('Signup Name: ${data.name}, Password: ${data.password}');
    setState(() {
      _buildBeginScreen(context);
    });
    return Future.value(_networkService.register(data.name!, data.password!))
        .then(
      (x) {
        if (!x) {
          return 'Не удалось зарегистрироваться';
        }
        return null;
      },
    );
  }

  Future<String?> _recoverPassword(String name) {
    debugPrint('Name: $name');
    return Future.delayed(loginTime).then((_) {
      return null;
    });
  }

  Future<bool> _checkConnection() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        return true;
      }
    } on SocketException catch (_) {
      print('not connected');
    }
    return false;
  }

  FutureBuilder<bool> _buildBeginScreen(BuildContext context) {
    return FutureBuilder<bool>(
      future: _checkConnection(),
      builder: (context, snapshot) {
        if (snapshot.data != null) {
          bool _isConnected = snapshot.data!;
          return _isConnected ? _buildLogin(context) : _buildWithoutNet(context);
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
  
  Widget _buildWithoutNet(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Вы сейчас не в сети"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Переподключиться',
            onPressed: () {
              setState(() {
                _buildBeginScreen(context);
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLogin(BuildContext context){
    return FlutterLogin(
      title: 'Рецепты',
      onLogin: _authUser,
      onSignup: _signupUser,
      onRecoverPassword: _recoverPassword,
      hideForgotPasswordButton: true,
      userValidator: customEmailValidator,
      passwordValidator: customPasswordValidator,
      theme: LoginTheme(
          pageColorLight: const Color.fromRGBO(115, 12, 44, 50),
          pageColorDark: const Color.fromRGBO(50, 30, 100, 50),
          primaryColor: const Color.fromRGBO(70, 30, 100, 50),
          accentColor: const Color.fromRGBO(200, 200, 200, 50),
          buttonTheme: const LoginButtonTheme(
            splashColor: Color.fromRGBO(200, 200, 200, 50),
          )
      ),
      messages: LoginMessages(
        passwordHint: 'Пароль',
        confirmPasswordHint: 'Подтвердите пароль',
        loginButton: 'Войти',
        signupButton: 'Зарегистрироваться',
        flushbarTitleError: 'Не удачная попытка входа',
        confirmPasswordError: 'Пароли не совпадают',
      ),
      onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildBeginScreen(context);
  }

  static String? customEmailValidator(value) {
    if (value!.isEmpty ||
        !RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(value)) {
      return 'Некорректный адрес электронной почты!';
    }
    return null;
  }

  static String? customPasswordValidator(value) {
    if (value!.isEmpty || value.length <= 5) {
      return 'Слишком короткий пароль!';
    }
    return null;
  }
}
