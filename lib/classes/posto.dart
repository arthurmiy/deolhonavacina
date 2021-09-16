class Posto {
  final String name;
  final String address;
  final String type;
  final int idType;
  final int idDistrict;
  final String District;
  final int idRegion;
  final String Region;
  final String time;
  final int queueStatus;
  final String queueStatusStr;
  final bool coronavac;
  final bool astrazeneca;
  final bool pfizer;
  final int id;

  Posto(
    this.name,
    this.address,
    this.type,
    this.idType,
    this.idDistrict,
    this.District,
    this.idRegion,
    this.Region,
    this.time,
    this.queueStatus,
    this.queueStatusStr,
    this.coronavac,
    this.astrazeneca,
    this.pfizer,
    this.id,
  );

  factory Posto.fromJson(Map<String, dynamic> json) {
    return Posto(
        json['equipamento'] ?? '',
        json['endereco'] ?? '',
        json['tipo_posto'] ?? '',
        int.parse(json['id_tipo_posto'] ?? '-1'),
        int.parse(json['id_distrito'] ?? '-1'),
        json['distrito'] ?? '',
        int.parse(json['id_crs']),
        json['crs'] ?? '',
        json['data_hora'] ?? '',
        int.parse(json['indice_fila'] ?? '-1'),
        json['status_fila'] ?? 'Não informado',
        json['coronavac'] == "1",
        json['astrazeneca'] == "1",
        json['pfizer'] == "1",
        int.parse(json['id_tb_unidades'] ?? '-1'));
  }

  String getParameterByLabel(String label) {
    String? result = "";
    if (label.toLowerCase() == "bairro") {
      result = this.District;
    }
    if (label.toLowerCase() == "tipo") {
      result = this.type;
    }
    if (label.toLowerCase() == "região") {
      result = this.Region;
    }
    if (label.toLowerCase() == "status da fila") {
      result = this.queueStatusStr;
    }
    return result;
  }
}
