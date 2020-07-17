import 'package:consumir_web_api/models/materia.dart';
import 'package:flutter/material.dart';

import 'package:consumir_web_api/database/database_helper.dart';

final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

class FormAddScreen extends StatefulWidget {
  final Materia materia;
  FormAddScreen({this.materia});

  @override
  _FormAddScreenState createState() => _FormAddScreenState();
}

class _FormAddScreenState extends State<FormAddScreen> {
  bool _isLoading = false;
  //final _database = DataBaseHelper.instancia;
  DataBaseHelper _database;
  
  bool _isFieldNombreValid;
  bool _isFieldProfesorValid;
  bool _isFieldCuatriValid;
  bool _isFieldHorarioValid;

  TextEditingController _controllerNombre   = TextEditingController();
  TextEditingController _controllerProfesor = TextEditingController();
  TextEditingController _controllerCuatri   = TextEditingController();
  TextEditingController _controllerHorario  = TextEditingController();

  @override
  void initState() {
    
    if (widget.materia != null) {
      _isFieldNombreValid = true;
      _controllerNombre.text = widget.materia.Nombre;
      _isFieldProfesorValid = true;
      _controllerProfesor.text = widget.materia.Profesor;
      _isFieldCuatriValid = true;
      _controllerCuatri.text = widget.materia.Cuatrimestre;
      _isFieldHorarioValid = true;
      _controllerHorario.text = widget.materia.Horario;
    }
    super.initState();
    _database = DataBaseHelper();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldState,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          widget.materia == null ? "Form Add" : "Change Data",
          style: TextStyle(color: Colors.white), 
        ),
      ),
      body: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _buildTextFieldNombre(),
                _buildTextFieldProfesor(),
                _buildTextFieldCuatri(),
                _buildTextFieldHorario(),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: RaisedButton(
                    child: Text(
                      widget.materia == null ? "Submit".toUpperCase() : "Update Data".toUpperCase(),
                      style: TextStyle(
                        color: Colors.white
                      ),
                    ),
                    onPressed: (){
                      if( _isFieldNombreValid == null || _isFieldProfesorValid == null || _isFieldCuatriValid == null || _isFieldHorarioValid == null || !_isFieldNombreValid || !_isFieldProfesorValid || !_isFieldCuatriValid || !_isFieldHorarioValid ){
                        _scaffoldState.currentState.showSnackBar(
                          SnackBar(content: Text("Please fill all field"),)
                        );
                        return;
                      }
                      setState( ()=>_isLoading = true );
                      String nombre   = _controllerNombre.text.toString();
                      String profesor = _controllerProfesor.text.toString();
                      String cuatri   = _controllerCuatri.text.toString();
                      String horario  = _controllerHorario.text.toString();
                      Materia materia = Materia(Id: 1,Nombre: nombre, Profesor: profesor, Cuatrimestre: cuatri, Horario: horario);
                      if( widget.materia == null ){
                        _database.insertar(materia.toJson()).then((noChanges) {
                          setState(()=> _isLoading = false);
                          if( noChanges > 0 ){
                            Navigator.pop(_scaffoldState.currentState.context);
                          }else{
                            _scaffoldState.currentState.showSnackBar(
                              SnackBar(
                                content: Text("Submit data failed"),
                              )
                            );
                          }
                        });
                      }else{
                        materia.Id = widget.materia.Id;
                        _database.actualizar(materia.toJson()).then((noChanges) {
                          setState(() => _isLoading=false );
                          if( noChanges > 0 ){
                            Navigator.pop(_scaffoldState.currentState.context);
                          }else{
                            _scaffoldState.currentState.showSnackBar(
                              SnackBar(content: Text('Update data failed'))
                            );
                          }
                        });
                      }
                    },
                    color: Colors.orange[600],
                  ),
                ),
              ],
            ),
          ),
          _isLoading ? Stack(
                  children: <Widget>[
                    Opacity(
                      opacity: 0.3,
                      child: ModalBarrier(
                        dismissible: false,
                        color: Colors.grey,
                      ),
                    ),
                    Center(child: CircularProgressIndicator()),
                  ],
                ) : Container(),
        ],
      ),
    );
  }
  
  Widget _buildTextFieldNombre(){
    return TextField(
      controller: _controllerNombre,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: "Name of subject",
        errorText: _isFieldNombreValid == null || _isFieldNombreValid
            ? null
            : "The name of subject is required",
      ),
      onChanged: (value) {
        bool isFieldValid = value.trim().isNotEmpty;
        if (isFieldValid != _isFieldNombreValid) {
          setState(() => _isFieldNombreValid = isFieldValid);
        }
      },
    );
  }
  
  Widget _buildTextFieldProfesor(){
    return TextField(
      controller: _controllerProfesor,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: "Teacher",
        errorText: _isFieldProfesorValid == null || _isFieldProfesorValid
            ? null
            : "The Teacher is required",
      ),
      onChanged: (value) {
        bool isFieldValid = value.trim().isNotEmpty;
        if (isFieldValid != _isFieldProfesorValid) {
          setState(() => _isFieldProfesorValid = isFieldValid);
        }
      },
    );
  }
  
  Widget _buildTextFieldCuatri(){
    return TextField(
      controller: _controllerCuatri,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: "Quarter",
        errorText: _isFieldCuatriValid == null || _isFieldCuatriValid
            ? null
            : "The Quarter is required",
      ),
      onChanged: (value) {
        bool isFieldValid = value.trim().isNotEmpty;
        if (isFieldValid != _isFieldCuatriValid) {
          setState(() => _isFieldCuatriValid = isFieldValid);
        }
      },
    );
  }
  
  Widget _buildTextFieldHorario(){
    return TextField(
      controller: _controllerHorario,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: "Schedule",
        errorText: _isFieldHorarioValid == null || _isFieldHorarioValid
            ? null
            : "The Schedule is required",
      ),
      onChanged: (value) {
        bool isFieldValid = value.trim().isNotEmpty;
        if (isFieldValid != _isFieldHorarioValid) {
          setState(() => _isFieldHorarioValid = isFieldValid);
        }
      },
    );
  }
}