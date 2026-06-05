import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Consumidor API Django',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  final String baseUrl = 'http://192.168.1.11:8000';
  final String clientId = 'YTc89Cj7Bl4Z8qi1KxWRV8xmOPWoAWJgbtV68UVs';
  final String clientSecret =
      'E3oM9XhVWpvHDHaSD06T7jZ9ZrCRCcXEP4b7Tt5FIQo3xRWBGrSNFuqdt4grB5S1EaBRNbnyD55p1XyyFH9wFDh4CAQwOjMYUTqfzGqn2nUYwt0tqM7X2AanHqIyHRht';

  Future<void> _login() async {
    setState(() => _isLoading = true);

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/o/token/'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'grant_type': 'password',
          'username': _usernameController.text,
          'password': _passwordController.text,
          'client_id': clientId,
          'client_secret': clientSecret,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final String accessToken = data['access_token'];

        // Login efetuado com sucesso! Redireciona para a lista de cursos protegida
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  CursosPage(token: accessToken, baseUrl: baseUrl),
            ),
          );
        }
      } else {
        print('ERRO DO SERVIDOR: ${response.statusCode} - ${response.body}');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Falha na autenticação. Verifique os dados.'),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao conectar com o servidor: $e')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login - API OAuth2')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Usuário'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Senha'),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _login,
                    child: const Text('Entrar e Obter Token'),
                  ),
          ],
        ),
      ),
    );
  }
}

class CursosPage extends StatefulWidget {
  final String token;
  final String baseUrl;

  const CursosPage({super.key, required this.token, required this.baseUrl});

  @override
  State<CursosPage> createState() => _CursosPageState();
}

class _CursosPageState extends State<CursosPage> {
  List _cursos = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCursos();
  }

  Future<void> _fetchCursos() async {
    try {
      // Consumindo a rota protegida enviando o token no cabeçalho de Autorização
      final response = await http.get(
        Uri.parse(
          '${widget.baseUrl}/api/cursos/',
        ), // Ajuste de acordo com suas rotas de api_views
        headers: {
          'Authorization': 'Bearer ${widget.token}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          // Trata se o DRF retornar paginado (com chave 'results') ou lista direta
          _cursos = data is Map ? data['results'] ?? [] : data;
          _isLoading = false;
        });
      } else {
        throw Exception('Falha ao carregar cursos protegidos');
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erro: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cursos Disponíveis (Rota Protegida)')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _cursos.isEmpty
          ? const Center(child: Text('Nenhum curso encontrado.'))
          : ListView.builder(
              itemCount: _cursos.length,
              itemBuilder: (context, index) {
                final curso = _cursos[index];
                return ListTile(
                  title: Text(curso['titulo'] ?? 'Sem título'),
                  subtitle: Text(curso['descricao'] ?? 'Sem descrição'),
                );
              },
            ),
    );
  }
}
