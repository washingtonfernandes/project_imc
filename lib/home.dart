import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController nomeController = TextEditingController();
  TextEditingController pesoController = TextEditingController();
  TextEditingController alturaController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _textInfo = "";

  void _resetCampos() {
    _formKey.currentState?.reset();
    nomeController.clear();
    pesoController.clear();
    alturaController.clear();
    setState(() {
      _textInfo = "";
    });
  }

  void _calcular() {
    try {
      double peso = double.parse(pesoController.text);
      double altura = double.parse(alturaController.text) / 100;
      double imc = peso / (altura * altura);

      _atualizarTextoInfo(imc);
    } catch (e) {
      print("Erro: $e");
      setState(() {
        _textInfo = "Erro nos dados inseridos. Verifique e tente novamente.";
      });
    }
  }

  void _atualizarTextoInfo(double imc) {
    if (imc < 18.6)
      _textInfo = "Abaixo do peso (${imc.toStringAsPrecision(4)})";
    else if (imc >= 18.6 && imc < 24.9)
      _textInfo = "Peso ideal (${imc.toStringAsPrecision(4)})";
    else if (imc >= 24.9 && imc < 29.9)
      _textInfo = "Levemente acima do peso (${imc.toStringAsPrecision(4)})";
    else if (imc >= 29.9 && imc < 34.9)
      _textInfo = "Obesidade Grau I (${imc.toStringAsPrecision(4)})";
    else if (imc >= 34.9 && imc < 39.9)
      _textInfo = "Obesidade Grau II (${imc.toStringAsPrecision(4)})";
    else if (imc >= 40)
      _textInfo = "Obesidade Grau III (${imc.toStringAsPrecision(4)})";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Calculadora de IMC"),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _resetCampos,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _construirIconePessoa(),
              _construirCampoTexto("Nome", nomeController),
              _construirCampoTexto(
                  "Peso (kg)", pesoController, TextInputType.number),
              _construirCampoTexto(
                  "Altura (cm)", alturaController, TextInputType.number),
              _construirBotaoCalcular(),
              _construirTextoResultado(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _construirIconePessoa() {
    return Icon(Icons.person,
        size: 120, color: Color.fromARGB(255, 12, 12, 12));
  }

  Widget _construirCampoTexto(
      String labelText, TextEditingController controller,
      [TextInputType keyboardType = TextInputType.text]) {
    return TextFormField(
      key: Key('${labelText.toLowerCase()}TextField'),
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
      ),
      textAlign: TextAlign.center,
      style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 25.0),
      controller: controller,
      validator: (value) {
        if (value?.isEmpty ?? true) {
          return "Insira $labelText!";
        } else {
          return null;
        }
      },
    );
  }

  Widget _construirBotaoCalcular() {
    return Padding(
      padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
      child: ButtonTheme(
        height: 50.0,
        highlightColor: Colors.amber,
        child: ElevatedButton(
          onPressed: () {
            if (_formKey.currentState?.validate() ?? false) _calcular();
          },
          child: Text("Calcular",
              style: TextStyle(color: Colors.white, fontSize: 25.0)),
        ),
      ),
    );
  }

  Widget _construirTextoResultado() {
    return Text(
      _textInfo,
      textAlign: TextAlign.center,
      style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 25.0),
    );
  }
}
