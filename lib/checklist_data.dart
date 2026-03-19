class ChecklistSection {
  final String title;
  final List<ChecklistItem> items;
  ChecklistSection({required this.title, required this.items});
}

class ChecklistItem {
  final String action;
  final String status;
  ChecklistItem({required this.action, required this.status});
}

final Map<String, List<ChecklistSection>> aircraftChecklists = {
  'F-GYKX': [
    ChecklistSection(title: 'AVANT MISE EN ROUTE', items: [
      ChecklistItem(action: 'ATIS (par téléphone ou radio)', status: 'notée'),
      ChecklistItem(action: 'Verrière', status: 'fermée'),
      ChecklistItem(action: 'Frein de parc', status: 'serré'),
      ChecklistItem(action: 'Sièges', status: 'réglés, verrouillés'),
      ChecklistItem(action: 'Ceintures et harnais', status: 'attachés'),
      ChecklistItem(action: 'Commandes de vol', status: 'libres'),
      ChecklistItem(action: 'Radio MASTER', status: 'OFF'),
      ChecklistItem(action: 'Robinet essence', status: 'ouvert'),
      ChecklistItem(action: 'Jaugeur essence et autonomie', status: 'vérifié'),
      ChecklistItem(action: 'Horamètre', status: 'noté'),
      ChecklistItem(action: 'Volets', status: 'rentrés'),
    ]),
    ChecklistSection(title: 'DÉMARRAGE DU MOTEUR', items: [
      ChecklistItem(action: 'Interrupteur batterie', status: 'ON'),
      ChecklistItem(action: 'Réchauffage carburateur', status: 'froid (pousser)'),
      ChecklistItem(action: 'Mixture', status: 'plein riche (vers le haut)'),
      ChecklistItem(action: 'Feu anti-collision', status: 'ON'),
      ChecklistItem(action: 'Sélecteur magnétos', status: 'position L (LEFT)'),
      ChecklistItem(action: 'Pompe électrique', status: 'ON'),
      ChecklistItem(action: 'Manette des gaz', status: '3 injections puis 1/4 en avant'),
      ChecklistItem(action: 'Zone hélice', status: 'dégagée'),
      ChecklistItem(action: 'Démarreur', status: 'marche (15 à 20 sec max)'),
    ]),
    ChecklistSection(title: 'APRÈS MISE EN ROUTE', items: [
      ChecklistItem(action: 'Pression d’huile dans les 20 sec max', status: 'plage verte'),
      ChecklistItem(action: 'Sélecteur magnétos', status: 'L+R (Both)'),
      ChecklistItem(action: 'Régime', status: '1200 tr/min'),
      ChecklistItem(action: 'Alternateur', status: 'ON'),
      ChecklistItem(action: 'Voltmètre', status: 'plage verte'),
      ChecklistItem(action: 'Pompe électrique', status: 'OFF'),
      ChecklistItem(action: 'Pression d’essence', status: 'plage verte'),
      ChecklistItem(action: 'Radio MASTER', status: 'ON'),
      ChecklistItem(action: 'Fréquences et transpondeur (GND)', status: 'réglés'),
      ChecklistItem(action: 'Voyants', status: 'testés'),
      ChecklistItem(action: 'Altimètre', status: 'réglé QNH'),
      ChecklistItem(action: 'Indicateur de dépression', status: 'vérifié'),
      ChecklistItem(action: 'Horizon artificiel', status: 'vérifié'),
      ChecklistItem(action: 'Heure bloc', status: 'notée'),
    ]),
    ChecklistSection(title: 'DÉBUT DU ROULAGE', items: [
      ChecklistItem(action: 'Phares', status: 'ON'),
      ChecklistItem(action: 'Frein de parc', status: 'desserré'),
      ChecklistItem(action: 'Freins', status: 'essayés et symétriques'),
      ChecklistItem(action: 'Gyroscopes et bille', status: 'vérifiés'),
      ChecklistItem(action: 'NOTE', status: 'Éviter de dépasser 1200 tr/min tant que la température d’huile reste en plage jaune'),
    ]),
    ChecklistSection(title: 'POINT FIXE', items: [
      ChecklistItem(action: 'Frein de parc', status: 'serré'),
      ChecklistItem(action: 'Pression et température d’huile', status: 'plage verte'),
      ChecklistItem(action: 'Pression d’essence', status: 'plage verte'),
      ChecklistItem(action: 'Mixture', status: 'plein riche (vers le haut)'),
      ChecklistItem(action: 'Réchauffage carburateur', status: 'froid (pousser)'),
      ChecklistItem(action: 'Vérification magnétos (2000 tr/min)', status: 'Chute maxi 175, écart 50'),
      ChecklistItem(action: 'Vérification réchauffage carburateur', status: 'Chute ~100 tr/min'),
      ChecklistItem(action: 'Vérification mixture', status: 'Appauvrir puis Plein riche'),
      ChecklistItem(action: 'Vérification ralenti', status: '600 à 850 tr/min'),
      ChecklistItem(action: 'Gaz', status: '1200 tr/min'),
    ]),
    ChecklistSection(title: 'AVANT DÉCOLLAGE', items: [
      ChecklistItem(action: 'Commandes', status: 'libres'),
      ChecklistItem(action: 'Sélecteur magnétos', status: 'L+R (Both)'),
      ChecklistItem(action: 'Cabine (sièges, ceintures)', status: 'vérifiée'),
      ChecklistItem(action: 'Verrière', status: 'fermée, verrouillée'),
      ChecklistItem(action: 'Robinet essence', status: 'ouvert'),
      ChecklistItem(action: 'Pompe électrique', status: 'ON'),
      ChecklistItem(action: 'Trim de profondeur', status: 'position décollage'),
      ChecklistItem(action: 'Instruments moteur', status: 'plages vertes'),
      ChecklistItem(action: 'Volets', status: 'plein sortis, puis 1er cran'),
      ChecklistItem(action: 'Conservateur de cap', status: 'réglé'),
      ChecklistItem(action: 'Transpondeur', status: 'ALT'),
      ChecklistItem(action: 'Voyants alarmes', status: 'éteints'),
    ]),
    ChecklistSection(title: 'BRIEFINGS', items: [
      ChecklistItem(action: 'Briefing décollage', status: 'fait'),
      ChecklistItem(action: 'Briefing arrivée', status: 'fait'),
    ]),
    ChecklistSection(title: 'APRÈS ATTERRISSAGE', items: [
      ChecklistItem(action: 'Pompe électrique', status: 'OFF'),
      ChecklistItem(action: 'Volets', status: 'rentrés'),
      ChecklistItem(action: 'Transpondeur', status: 'GND'),
    ]),
    ChecklistSection(title: 'ARRÊT MOTEUR', items: [
      ChecklistItem(action: 'Frein de parc', status: 'serré'),
      ChecklistItem(action: 'Radio MASTER', status: 'OFF'),
      ChecklistItem(action: 'Phares et feux de nav', status: 'OFF'),
      ChecklistItem(action: 'Essai coupure au ralenti', status: 'vérifié'),
      ChecklistItem(action: 'Régime', status: '1000 tr/min'),
      ChecklistItem(action: 'Mixture', status: 'étouffoir'),
      ChecklistItem(action: 'Magnétos / Clés', status: 'OFF / retirées'),
      ChecklistItem(action: 'Alternateur / Batterie', status: 'OFF'),
      ChecklistItem(action: 'Horamètre / Heure bloc', status: 'notés'),
      ChecklistItem(action: 'Volets', status: 'Sortis (2e cran)'),
      ChecklistItem(action: 'Frein de parc', status: 'desserré (si possible)'),
    ]),
  ],
  'F-BVCY': [], // À compléter plus tard
  'F-HAIX': [], // À compléter plus tard
};
