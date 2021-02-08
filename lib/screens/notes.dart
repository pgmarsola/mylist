import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:mylist/helpers/db.dart';
import 'package:mylist/models/note.dart';
import 'package:mylist/utils/colors.dart';
import 'package:mylist/widgets/action_button.dart';
import 'package:mylist/widgets/topbar.dart';

class NotesList extends StatefulWidget {
  NotesList({Key key, this.titulo}) : super(key: key);
  final String titulo;
  @override
  _NotesListState createState() => _NotesListState();
}

class _NotesListState extends State<NotesList> {
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
    _title.text = '';
    _description.text = '';
    _date.text = '';

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

  void _removerItem(Note note, int index) {
    setState(() {
      listNote = List.from(listNote)..removeAt(index);

      db.deleteNote(note.id);
      tamanhoDaLista = tamanhoDaLista - 1;
    });
  }

  void _addNote() {
    _title.text = '';
    _description.text = '';
    _date.text = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        var size = MediaQuery.of(context).size;
        var screenHeight = size.height / 100;

        return AlertDialog(
          title: new Text(
            "Nova Tarefa",
            style: TextStyle(color: verde2),
          ),
          content: new Container(
            child: new Form(
              key: _formKey,
              child: SingleChildScrollView(
                  child: Padding(
                      padding: EdgeInsets.only(
                          top: screenHeight * 1.5, bottom: screenHeight * 1.5),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          TextFormField(
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
                              labelStyle: TextStyle(color: verde2),
                              contentPadding: EdgeInsets.only(
                                  left: 14.0, bottom: 8.0, top: 8.0),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: verde2),
                                borderRadius:
                                    BorderRadius.circular(screenHeight * 1.5),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: verde2),
                                borderRadius:
                                    BorderRadius.circular(screenHeight * 1.5),
                              ),
                            ),
                          ),
                          Divider(
                            color: Colors.transparent,
                            height: 20.0,
                          ),
                          TextFormField(
                            controller: _description,
                            keyboardType: TextInputType.text,
                            validator: (valor) {
                              if (valor.isEmpty && valor.length == 0) {
                                return "Campo Obrigatório";
                              }
                            },
                            decoration: new InputDecoration(
                              hintText: 'Descrição',
                              labelText: 'Descrição',
                              labelStyle: TextStyle(color: verde2),
                              contentPadding: EdgeInsets.only(
                                  left: 14.0, bottom: 8.0, top: 8.0),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: verde2),
                                borderRadius:
                                    BorderRadius.circular(screenHeight * 1.5),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: verde2),
                                borderRadius:
                                    BorderRadius.circular(screenHeight * 1.5),
                              ),
                            ),
                          ),
                          Divider(
                            color: Colors.transparent,
                            height: 20.0,
                          ),
                          TextFormField(
                            inputFormatters: [
                              MaskTextInputFormatter(mask: "##/##/####")
                            ],
                            controller: _date,
                            keyboardType: TextInputType.number,
                            validator: (valor) {
                              if (valor.isEmpty && valor.length == 0) {
                                return "Campo Obrigatório";
                              }
                            },
                            decoration: new InputDecoration(
                              hintText: 'Data',
                              labelText: 'Data',
                              labelStyle: TextStyle(color: verde2),
                              contentPadding: EdgeInsets.only(
                                  left: 14.0, bottom: 8.0, top: 8.0),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: verde2),
                                borderRadius:
                                    BorderRadius.circular(screenHeight * 1.5),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: verde2),
                                borderRadius:
                                    BorderRadius.circular(screenHeight * 1.5),
                              ),
                            ),
                          )
                        ],
                      ))),
            ),
          ),
          actions: <Widget>[
            ActionButton(Icon(Icons.save, color: branco), 'Salvar', () {
              Note _note;
              if (_formKey.currentState.validate()) {
                _note = Note(
                  _title.text,
                  _description.text,
                  _date.text,
                );

                db.insertNote(_note);

                _carregarLista();

                _formKey.currentState.reset();

                Navigator.of(context).pop();
              }
            }, screenHeight * 1.5)
          ],
        );
      },
    );
  }

  void _updateNote(Note note) {
    _title.text = note.title;
    _description.text = note.description;
    _date.text = note.date;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        var size = MediaQuery.of(context).size;
        var screenHeight = size.height / 100;

        return AlertDialog(
          title: new Text(
            "Atualizar Tarefa",
            style: TextStyle(color: verde2),
          ),
          content: new Container(
            child: new Form(
              key: _formKey,
              child: SingleChildScrollView(
                  child: Padding(
                      padding: EdgeInsets.only(
                          top: screenHeight * 1.5, bottom: screenHeight * 1.5),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          TextFormField(
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
                              labelStyle: TextStyle(color: verde2),
                              contentPadding: EdgeInsets.only(
                                  left: 14.0, bottom: 8.0, top: 8.0),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: verde2),
                                borderRadius:
                                    BorderRadius.circular(screenHeight * 1.5),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: verde2),
                                borderRadius:
                                    BorderRadius.circular(screenHeight * 1.5),
                              ),
                            ),
                          ),
                          Divider(
                            color: Colors.transparent,
                            height: 20.0,
                          ),
                          TextFormField(
                            controller: _description,
                            keyboardType: TextInputType.text,
                            validator: (valor) {
                              if (valor.isEmpty && valor.length == 0) {
                                return "Campo Obrigatório";
                              }
                            },
                            decoration: new InputDecoration(
                              hintText: 'Descrição',
                              labelText: 'Descrição',
                              labelStyle: TextStyle(color: verde2),
                              contentPadding: EdgeInsets.only(
                                  left: 14.0, bottom: 8.0, top: 8.0),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: verde2),
                                borderRadius:
                                    BorderRadius.circular(screenHeight * 1.5),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: verde2),
                                borderRadius:
                                    BorderRadius.circular(screenHeight * 1.5),
                              ),
                            ),
                          ),
                          Divider(
                            color: Colors.transparent,
                            height: 20.0,
                          ),
                          TextFormField(
                            inputFormatters: [
                              MaskTextInputFormatter(mask: "##/##/####")
                            ],
                            controller: _date,
                            keyboardType: TextInputType.number,
                            validator: (valor) {
                              if (valor.isEmpty && valor.length == 0) {
                                return "Campo Obrigatório";
                              }
                            },
                            decoration: new InputDecoration(
                              hintText: 'Data',
                              labelText: 'Data',
                              labelStyle: TextStyle(color: verde2),
                              contentPadding: EdgeInsets.only(
                                  left: 14.0, bottom: 8.0, top: 8.0),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: verde2),
                                borderRadius:
                                    BorderRadius.circular(screenHeight * 1.5),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: verde2),
                                borderRadius:
                                    BorderRadius.circular(screenHeight * 1.5),
                              ),
                            ),
                          )
                        ],
                      ))),
            ),
          ),
          actions: <Widget>[
            ActionButton(Icon(Icons.refresh, color: branco), 'Atualizar', () {
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
            }, screenHeight * 1.5),
          ],
        );
      },
    );
  }

  Widget slideRightBackground() {
    return Container(
      color: Colors.green,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: 20,
            ),
            Icon(
              Icons.edit,
              color: Colors.white,
            ),
            Text(
              " Edit",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.left,
            ),
          ],
        ),
        alignment: Alignment.centerLeft,
      ),
    );
  }

  Widget slideLeftBackground() {
    return Container(
      color: Colors.red,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Icon(
              Icons.delete,
              color: Colors.white,
            ),
            Text(
              " Delete",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.right,
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
        alignment: Alignment.centerRight,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(),
      body: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: tamanhoDaLista,
        itemBuilder: (context, index) {
          return Dismissible(
            key: UniqueKey(),
            child: InkWell(
              child: ListTile(
                title: Text(listNote[index].title),
                subtitle: Text(listNote[index].description),
                leading: Text(listNote[index].date),
              ),
              onTap: () => _updateNote(listNote[index]),
            ),
            background: slideRightBackground(),
            secondaryBackground: slideLeftBackground(),
            confirmDismiss: (direction) {
              if (direction == DismissDirection.endToStart) {
                _removerItem(listNote[index], index);
              } else {
                _updateNote(listNote[index]);
              }
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: verde2,
        foregroundColor: branco,
        onPressed: () {
          _addNote();
        },
        icon: Icon(Icons.add),
        label: Text('Tarefas'.toUpperCase()),
      ),
    );
  }
}
