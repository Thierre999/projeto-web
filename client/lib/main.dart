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
                    child: const Text('Entrar'),
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
      final response = await http.get(
        Uri.parse('${widget.baseUrl}/api/cursos/'),
        headers: {
          'Authorization': 'Bearer ${widget.token}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes);
        final data = json.decode(decodedBody);

        setState(() {
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
      appBar: AppBar(title: const Text('Cursos Disponíveis')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _cursos.isEmpty
          ? const Center(child: Text('Nenhum curso encontrado.'))
          : ListView.builder(
              itemCount: _cursos.length,
              itemBuilder: (context, index) {
                final curso = _cursos[index];

                final instrutor = curso['instrutor_detalhes'] != null
                    ? curso['instrutor_detalhes']['username']
                    : 'Desconhecido';

                final qtdeAulas = curso['aulas'] != null
                    ? (curso['aulas'] as List).length
                    : 0;

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  elevation: 2,
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Text(
                      curso['titulo'] ?? 'Sem título',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        '${curso['descricao']}\n\nInstrutor: $instrutor | Aulas: $qtdeAulas',
                        style: const TextStyle(height: 1.3),
                      ),
                    ),
                    isThreeLine: true,
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.blue,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CursoDetalhesPage(curso: curso),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}

// NOVA TELA: Mostra os detalhes do curso e a lista de aulas
class CursoDetalhesPage extends StatelessWidget {
  final Map curso;

  const CursoDetalhesPage({super.key, required this.curso});

  @override
  Widget build(BuildContext context) {
    final aulas = curso['aulas'] as List? ?? [];

    return Scaffold(
      appBar: AppBar(title: Text(curso['titulo'] ?? 'Detalhes do Curso')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sobre este curso:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              curso['descricao'] ?? 'Sem descrição',
              style: const TextStyle(fontSize: 16),
            ),
            const Divider(height: 32, thickness: 1),
            Text(
              'Conteúdo (${aulas.length} aulas):',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: aulas.isEmpty
                  ? const Center(child: Text('Nenhuma aula cadastrada ainda.'))
                  : ListView.builder(
                      itemCount: aulas.length,
                      itemBuilder: (context, index) {
                        final aula = aulas[index];
                        return Card(
                          color: Colors.blue.shade50,
                          child: ListTile(
                            leading: const Icon(
                              Icons.play_circle_fill,
                              size: 36,
                              color: Colors.blue,
                            ),
                            title: Text(
                              aula['titulo'] ?? 'Sem título',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(aula['conteudo'] ?? ''),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
