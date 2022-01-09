import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  String _enderecoResposta = "";

  TextEditingController _controllercep = TextEditingController();

  void consultar_cep() async {
    setState(() {
      _enderecoResposta = "Obtendo endereço...";
    });
      String url = "https://viacep.com.br/ws/${_controllercep.text}/json/";
      HttpClient httpClient = new HttpClient();
      HttpClientRequest request = await httpClient.getUrl(Uri.parse(url));
      HttpClientResponse response = await request.close();
      // todo - you should check the response.statusCode
      String reply = await response.transform(utf8.decoder).join();
      httpClient.close();

      Map<String, dynamic> respostaMap = json.decode(reply);
      String logradouro = respostaMap["logradouro"];
      String complemento = respostaMap["complemento"];
      String bairro = respostaMap["bairro"];
      String localidade = respostaMap["localidade"];
      String uf = respostaMap["uf"];

      String endereco = logradouro + ", "+ bairro + " - "+localidade+"/"+uf;

      setState(() {
        _enderecoResposta = endereco;
      });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("CONSULTA ENDEREÇO POR CEP"),
      ),
      body: Padding(padding: EdgeInsets.all(32),
      child: Column(
        children: [
           TextField(
            decoration: InputDecoration(
                labelText: "Digite o cep. ex: 69317554"
            ),
            controller: _controllercep,
          ),
          ElevatedButton(
              onPressed: (){
                consultar_cep();},
              child: Text("CONSULTAR")),
          Text(
            _enderecoResposta,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,),
        ],
      ),)
    );
  }
}
