class Notificacion {
  final String idNotificador;
  final String idUsuario;
  final String mensaje;
  final String subtitulo;
  final String istipoAdmin;
  final bool visto;
  final DateTime fecha;

  Notificacion({
    required this.idNotificador,
    required this.idUsuario,
    required this.istipoAdmin,
    required this.mensaje,
    required this.subtitulo,
    required this.visto,
    required this.fecha,
  });
}
