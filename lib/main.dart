import 'package:flutter/material.dart';
import 'dart:async';

import 'helpers/db.dart';
import 'models/note.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista de Tarefas',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ListaDeContatos(titulo: 'Lista de Tarefas'),
    );
  }
}

class ListaDeContatos extends StatefulWidget {
  ListaDeContatos({Key key, this.titulo}) : super(key: key);
  final String titulo;
  @override
  _ListaDeContatosState createState() => _ListaDeContatosState();
}

class _ListaDeContatosState extends State<ListaDeContatos> {
  final _title = TextEditingController();
  final _description = TextEditingController();
  final _date = TextEditingController();
  final _formKey = new GlobalKey<FormState>();

  static DatabaseHelper db;
  int tamanhoDaLista = 0;
  List<Note> listNote;

  _carregarLista() {
    db = new DatabaseHelper();

    db.initDb();

    Future<List<Note>> noteListFuture = db.getListNotes();
    noteListFuture.then((novalistNote) {
      setState(() {
        this.listNote = novalistNote;

        this.tamanhoDaLista = novalistNote.length;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    db = new DatabaseHelper();
    db.initDb();

    Future<List<Note>> listNote = db.getListNotes();

    listNote.then((novalistNote) {
      setState(() {
        this.listNote = novalistNote;

        this.tamanhoDaLista = novalistNote.length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.titulo),
      ),
      body: _listaDeContatos(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _adicionarContato();
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }

  void _removerItem(Note note, int index) {
    setState(() {
      listNote = List.from(listNote)..removeAt(index);

      db.deleteNote(note.id);
      tamanhoDaLista = tamanhoDaLista - 1;
    });
  }

  void _adicionarContato() {
    _title.text = '';
    _description.text = '';
    _date.text = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Nova Tarefa"),
          content: new Container(
            child: new Form(
              key: _formKey,
              child: new Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  campoTitle(),
                  Divider(
                    color: Colors.transparent,
                    height: 20.0,
                  ),
                  campoDescription(),
                  Divider(
                    color: Colors.transparent,
                    height: 20.0,
                  ),
                  campoDate()
                ],
              ),
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Salvar"),
              onPressed: () {
                Note _note;
                if (_formKey.currentState.validate()) {
                  _note = new Note(
                    _title.text,
                    _description.text,
                    _date.text,
                  );

                  db.insertNote(_note);

                  _carregarLista();

                  _formKey.currentState.reset();

                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _atualizarContato(Note note) {
    _title.text = note.title;
    _description.text = note.description;
    _date.text = note.date;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Atualizar Contato"),
          content: new Container(
            child: new Form(
              key: _formKey,
              child: new Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  campoTitle(),
                  Divider(
                    color: Colors.transparent,
                    height: 20.0,
                  ),
                  campoDescription(),
                  Divider(
                    color: Colors.transparent,
                    height: 20.0,
                  ),
                  campoDate()
                ],
              ),
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Atualizar"),
              onPressed: () {
                Note _note;

                if (_formKey.currentState.validate()) {
                  _note = new Note(
                    _title.text,
                    _description.text,
                    _date.text,
                  );

                  db.updateNote(_note, note.id);

                  _carregarLista();

                  _formKey.currentState.reset();

                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  Widget campoTitle() {
    return new TextFormField(
      controller: _title,
      keyboardType: TextInputType.text,
      validator: (valor) {
        if (valor.isEmpty && valor.length == 0) {
          return "Campo Obrigatório";
        }
      },
      decoration: new InputDecoration(
        hintText: 'Título',
        labelText: 'Título',
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget campoDescription() {
    return new TextFormField(
      controller: _description,
      validator: (valor) {
        if (valor.isEmpty && valor.length == 0) {
          return "Campo Obrigatório";
        }
      },
      decoration: new InputDecoration(
        hintText: 'Descrição',
        labelText: 'Descrição',
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget campoDate() {
    return new TextFormField(
      controller: _date,
      validator: (valor) {
        if (valor.isEmpty && valor.length == 0) {
          return "Campo Obrigatório";
        }
      },
      decoration: new InputDecoration(
        hintText: 'Data',
        labelText: 'Data',
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _listaDeContatos() {
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: tamanhoDaLista,
      itemBuilder: (context, index) {
        return GestureDetector(
          child: ListTile(
            title: Text(listNote[index].title),
            subtitle: Text(listNote[index].description),
            leading: CircleAvatar(
              child: Text(listNote[index].title[0]),
            ),
          ),
          onLongPress: () => _atualizarContato(listNote[index]),
          onTap: () => _removerItem(listNote[0], index),
        );
      },
    );
  }
}
