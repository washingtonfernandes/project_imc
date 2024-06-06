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
  List<IMC> _imcList = [];

  void _resetCampos() {
    _formKey.currentState?.reset();
    nomeController.clear();
    pesoController.clear();
    alturaController.clear();
  }

  void _calcular() {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        String nome = nomeController.text;
        double peso = double.parse(pesoController.text);
        double altura = double.parse(alturaController.text);
        IMC imc = IMC(nome: nome, peso: peso, altura: altura);

        setState(() {
          _imcList.add(imc);
        });

        _resetCampos();
      } catch (e) {
        print("Erro: $e");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                "Erro nos dados inseridos. Verifique e tente novamente.")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text(
          "Calculadora de IMC",
          style: TextStyle(
            color: Colors.black87,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _resetCampos,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.amber,
            borderRadius: BorderRadiusDirectional.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
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
                    _construirListaResultados(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _construirIconePessoa() {
    return const Icon(Icons.person,
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
        labelStyle: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
      ),
      textAlign: TextAlign.center,
      style:
          const TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 25.0),
      controller: controller,
      validator: (value) {
        if (value?.isEmpty ?? true) {
          return "Insira $labelText!";
        } else if (keyboardType == TextInputType.number &&
            double.tryParse(value!) == null) {
          return "Insira um número válido!";
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
          onPressed: _calcular,
          child: Text("CALCULAR",
              style: TextStyle(color: Colors.black54, fontSize: 18.0)),
        ),
      ),
    );
  }

  Widget _construirListaResultados() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _imcList.length,
      itemBuilder: (context, index) {
        IMC imc = _imcList[index];
        return Card(
          child: ListTile(
            title: Text("${imc.nome}"),
            subtitle: Text(imc.obterClassificacao()),
          ),
        );
      },
    );
  }
}

class IMC {
  final String nome;
  final double peso;
  final double altura;
  late final double valor;

  IMC({required this.nome, required this.peso, required this.altura}) {
    valor = peso / ((altura / 100) * (altura / 100));
  }

  String obterClassificacao() {
    if (valor < 18.6)
      return "Abaixo do peso (${valor.toStringAsPrecision(4)})";
    else if (valor >= 18.6 && valor < 24.9)
      return "Peso ideal (${valor.toStringAsPrecision(4)})";
    else if (valor >= 24.9 && valor < 29.9)
      return "Levemente acima do peso (${valor.toStringAsPrecision(4)})";
    else if (valor >= 29.9 && valor < 34.9)
      return "Obesidade Grau I (${valor.toStringAsPrecision(4)})";
    else if (valor >= 34.9 && valor < 39.9)
      return "Obesidade Grau II (${valor.toStringAsPrecision(4)})";
    else
      return "Obesidade Grau III (${valor.toStringAsPrecision(4)})";
  }
}
