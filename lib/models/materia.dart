import 'dart:convert';

class Materia{
  int Id;
  String Nombre;
  String Profesor;
  String Cuatrimestre;
  String Horario;

  Materia({this.Id,this.Nombre,this.Profesor,this.Cuatrimestre,this.Horario});
  factory Materia.fromJson(Map<String,dynamic> map){
    return Materia(
      Id            : map['id'],
      Nombre        : map['nombre'] ?? '',
      Profesor      : map['profesor'] ?? '',
      Cuatrimestre  : map['cuatrimestre'] ?? '',
      Horario       : map['horario'] ?? ''
    );
  }

  Map<String,dynamic> toJson(){
    return {"id" : Id, "nombre" : Nombre, "profesor" : Profesor, "cuatrimestre" : Cuatrimestre, "horario" : Horario};
  }

  @override
  String toString(){
    return 'Materia {Id: $Id, Nombre: $Nombre, Profesor: $Profesor, Cuatrimestre: $Cuatrimestre, Horario: $Horario}';
  }

  static List<Materia> materiaFromJson(String jsonData){
    final data = json.decode(jsonData);
    return List<Materia>.from(data.map(
      (item) => Materia.fromJson(item)
    ));
  }

  static String materiaToJson(Materia data){
    final jsonData = data.toJson();
    return json.encode(jsonData);
  }
}

