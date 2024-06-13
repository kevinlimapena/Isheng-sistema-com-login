import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'main_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String usuario = '';
  String senha = '';
  late final TextEditingController _User = TextEditingController();
  late final TextEditingController _senha = TextEditingController();
  bool isLoading = false;

  Future<void> login() async {
    String apiUrl =
        'http://yamadalomfabricacao123875.protheus.cloudtotvs.com.br:4050/rest/api/oauth2/v1/token';

    setState(() {
      isLoading = true;
    });

    final Map<String, String> headers = {
      'Content-Type': 'application/x-www-form-urlencoded'
    };

    try {
      final Map<String, String> requestBody = {
        'grant_type': 'password',
        'username': _User.text,
        'password': _senha.text,
      };
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: requestBody,
      );
      print(requestBody);
      print(response.statusCode);

      if (response.statusCode == 201) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MainScreen(),
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Erro ao fazer login'),
              content: const Text('Usuário ou senha errados'),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    } catch (error) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Erro ao fazer login'),
            content: const Text('Usuário ou senha errados'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  Widget widget1() {
    return Container(
      width: 300,
      height: 270,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black, // Cor da moldura
          width: 3.0, // Largura da moldura
        ),
        image: const DecorationImage(
          image: AssetImage("assets/ok.png"),
          fit: BoxFit.fill, // Preenche a caixa completamente
        ),
        borderRadius: BorderRadius.circular(10), // Borda arredondada opcional
      ),
    );
  }

  Widget widget2(BuildContext context) {
    return Card(
      color: Colors.white.withOpacity(0.9),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              onChanged: (text) {
                usuario = text;
              },
              keyboardType: TextInputType.emailAddress,
              controller: _User,
              decoration: const InputDecoration(
                labelText: 'Usuário',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              onChanged: (text) {
                senha = text;
              },
              controller: _senha,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Senha',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
              onSubmitted: (_) async {
                await login();
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await login();
              },
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text('Entrar', style: TextStyle(fontSize: 16)),
            ),
            if (isLoading)
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Tela de Login'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade200, Colors.blue.shade800],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  widget1(),
                  const SizedBox(height: 20),
                  widget2(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
