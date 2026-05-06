import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ImcPage(),
    );
  }
}

class ImcPage extends StatefulWidget {
  const ImcPage({super.key});

  @override
  State<ImcPage> createState() => _ImcPageState();
}

class _ImcPageState extends State<ImcPage> {
  final pesoController = TextEditingController();
  final alturaController = TextEditingController();

  String genero = 'masculino';
  String resultado = '';
  String classificacao = '';

  void calcularIMC() {
    final peso = double.tryParse(pesoController.text);
    final alturaCm = double.tryParse(alturaController.text);

    if (peso == null || alturaCm == null || alturaCm <= 0) {
      setState(() {
        resultado = 'Valores inválidos';
        classificacao = '';
      });
      return;
    }

    final altura = alturaCm / 100; 
    final imc = peso / (altura * altura);

    String classif;

    if (imc < 18.5) {
      classif = 'abaixo do peso';
    } else if (imc < 25) {
      classif = 'Normal';
    } else if (imc < 30) {
      classif = 'sobrepeso';
    } else {
      classif = 'obesidade';
    }

    setState(() {
      resultado = imc.toStringAsFixed(1);
      classificacao = classif;
    });
  }

  Widget generoCard(String label, String value, IconData icon) {
    final selecionado = genero == value;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            genero = value;
          });
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: selecionado ? (value == 'masculino' ? Colors.blue : Colors.pink) : Colors.grey[200],
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Icon(icon, size: 50, color: selecionado ? Colors.white : Colors.black),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  color: selecionado ? Colors.white : Colors.black,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculadora de IMC'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// GÊNERO
            Row(
              children: [
                generoCard('Masculino', 'masculino', Icons.male),
                const SizedBox(width: 10),
                generoCard('Feminino', 'feminino', Icons.female),
              ],
            ),
            const SizedBox(height: 20),

            TextField(
              controller: pesoController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Seu peso (kg)',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: alturaController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Sua altura (cm)',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: calcularIMC,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  backgroundColor: genero == 'masculino' ? Colors.blue : Colors.pink,
                ),
                child: const Text('Calcular seu IMC'),
              ),
            ),

            const SizedBox(height: 20),

            if (resultado.isNotEmpty)
              Column(
                children: [
                  const Text('Seu IMC', style: TextStyle(fontSize: 16)),
                  Text(
                    resultado,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    classificacao,
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}