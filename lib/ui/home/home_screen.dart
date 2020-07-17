import 'package:consumir_web_api/models/materia.dart';

import 'package:flutter/rendering.dart';
import 'package:consumir_web_api/ui/home/form_add_screen.dart';
import 'package:flutter/material.dart';
import 'package:consumir_web_api/database/database_helper.dart';

class HomeScreen extends StatefulWidget {

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  BuildContext context;
  Future<List<Materia>> materias;
  DataBaseHelper _database;

  @override
  void initState() {
    super.initState();
    _database = DataBaseHelper();
    materias = _database.listarTodos();
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return SafeArea(
      child: FutureBuilder(
        future: materias,
        builder: (BuildContext context, AsyncSnapshot<List<Materia>> snapshot){
          if(snapshot.hasError){
            return Center(
              child: Text("Something wrong with message: ${snapshot.error.toString()}"),
            );
          }else if(snapshot.connectionState == ConnectionState.done){
            List<Materia> materias = snapshot.data;
            return _buildListView(materias);
          }else{
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        }
      ),
    );
  }

  Widget _buildListView(List<Materia> materias){
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ListView.builder(
        itemBuilder: (context, index){
          Materia materia = materias[index];
          return Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      materia.Nombre,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    Text(materia.Profesor),
                    Text(materia.Cuatrimestre),
                    Text(materia.Horario),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        FlatButton(
                          onPressed: (){
                            showDialog(
                              context: context,
                              builder: (context){
                                return AlertDialog(
                                  title: Text('Warning'),
                                  content: Text('Are you sure want to delete data subject ${materia.Nombre}?'),
                                  actions: <Widget>[
                                    FlatButton(
                                      onPressed: (){
                                        Navigator.pop(context);
                                        _database
                                          .eliminar(materia.Id)
                                          .then((noChanges){
                                            if(noChanges > 0){
                                              setState(() {
                                                Scaffold.of(context)
                                                  .showSnackBar(SnackBar(
                                                    content: Text('Delete data success'),
                                                  ));
                                              });
                                            }else{
                                              Scaffold.of(context).showSnackBar(
                                                SnackBar(
                                                  content: Text('Delete data failed')
                                                )
                                              );
                                            }
                                          });
                                      }, 
                                      child: Text('Yes')
                                    ),
                                    FlatButton(
                                      onPressed: (){ Navigator.pop(context);},
                                      child: Text('No'),
                                    )
                                  ],
                                );
                              }
                            );
                          }, 
                          child: Text(
                            'Delete',
                            style: TextStyle(color: Colors.red),
                          )
                        ),
                        FlatButton(
                          onPressed: (){
                            Navigator.push(
                              context, 
                              MaterialPageRoute(
                                builder: (context){ return FormAddScreen(materia: materia);}
                              )
                            );
                          }, 
                          child: Text(
                            'Edit',
                            style: TextStyle(color: Colors.blue),
                          )
                        )
                      ],
                    )
                  ],
                ),
              )
            ),
          );
        },
        itemCount: materias.length,
      ),
    );
  }
}