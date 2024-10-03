class FavClubModel {
  String? idTeam;
  String? team;
  String? badge;

  FavClubModel({
    this.idTeam,
    this.team,
    this.badge,
  });

  FavClubModel.fromJson(Map<String, dynamic> json) {
    idTeam = json['idTeam'] as String?;
    team = json['strTeam'] as String?;
    badge = json['strBadge'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['idTeam'] = idTeam;
    data['strTeam'] = team;
    data['strBadge'] = badge;
    return data;
  }
}