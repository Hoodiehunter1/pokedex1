class Usuario {
  String _nombre = "";
  String _password = "";

  String get nombre => _nombre;
  String get password => _password;

  set nombre(String nombre) {
    _nombre = nombre;
  }

  set password(String password) {
    _password = password;
  }
}

class Pokemon {
  String _nombre = "";
  List<String> _habilidades = [];
  int _vida = 0;
  int _ataque = 0;
  int _ataqueEspecial = 0;
  int _defensa = 0;
  int _defensaEspecial = 0;
  int _velocidad = 0;
  String _habilidad = "";

  String get nombre => _nombre;
  List<String> get habilidades => _habilidades;
  int get vida => _vida;
  int get ataque => _ataque;
  int get ataqueEspecial => _ataqueEspecial;
  int get defensa => _defensa;
  int get defensaEspecial => _defensaEspecial;
  int get velocidad => _velocidad;
  String get habilidad => _habilidad;

  set nombre(String nombre) {
    _nombre = nombre;
  }

  set habilidades(List<String> habilidades) {
    _habilidades = habilidades;
  }

  set vida(int vida) {
    _vida = vida;
  }

  set ataque(int ataque) {
    _ataque = ataque;
  }

  set ataqueEspecial(int ataqueEspecial) {
    _ataqueEspecial = ataqueEspecial;
  }

  set defensa(int defensa) {
    _defensa = defensa;
  }

  set defensaEspecial(int defensaEspecial) {
    _defensaEspecial = defensaEspecial;
  }

  set velocidad(int velocidad) {
    _velocidad = velocidad;
  }

  set habilidad(String habilidad) {
    _habilidad = habilidad;
  }
}
