class UserLevelDetails {
  static Map<int, Map<String, dynamic>> levelDetails = {
    1: {
      "condition":
          "Inscription et ajout de la première plante dans le catalogue.",
      "description":
          "Bienvenue dans la communauté ! Tu viens de planter ta première graine.",
      "requiredPoints": 50,
      "rewardedActions": {
        "Inscription": 25,
        "Ajout d’une première plante": 25,
      },
    },
    2: {
      "condition": "Réaliser 4 échanges ou dons.",
      "description":
          "Tu commences à échanger tes plantes et à partager ta passion !",
      "requiredPoints": 150,
      "rewardedActions": {
        "1 échange ou dons réussi": 50,
        "Chaque échange ou dons supplémentaire": 25,
      },
    },
  };

  static Map<String, dynamic> getLevelDetails(int level) {
    return levelDetails[level] ??
        {
          "conditions": "Non défini",
          "description": "Niveau inconnu.",
          "requiredPoints": 0,
          "rewardedActions": {},
        };
  }
}
