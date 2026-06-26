import Foundation

struct LocalizationService {
    static func text(_ key: String, language: AppLanguage) -> String {
        translations[key]?[language.languageCode] ?? translations[key]?[AppLanguage.german.languageCode] ?? key
    }

    private static let translations: [String: [String: String]] = [
        "tab.home": ["de": "Home", "en": "Home", "es": "Inicio", "fr": "Accueil"],
        "tab.statistics": ["de": "Statistik", "en": "Statistics", "es": "Estadísticas", "fr": "Statistiques"],
        "tab.trophies": ["de": "Trophäen", "en": "Trophies", "es": "Trofeos", "fr": "Trophées"],
        "tab.settings": ["de": "Einstellungen", "en": "Settings", "es": "Ajustes", "fr": "Réglages"],

        "app.title": ["de": "Work Hours", "en": "Work Hours", "es": "Work Hours", "fr": "Work Hours"],
        "common.save": ["de": "Speichern", "en": "Save", "es": "Guardar", "fr": "Enregistrer"],
        "common.cancel": ["de": "Abbrechen", "en": "Cancel", "es": "Cancelar", "fr": "Annuler"],
        "common.delete": ["de": "Löschen", "en": "Delete", "es": "Eliminar", "fr": "Supprimer"],
        "common.optional": ["de": "Optional", "en": "Optional", "es": "Opcional", "fr": "Facultatif"],
        "common.status": ["de": "Status", "en": "Status", "es": "Estado", "fr": "Statut"],
        "common.minutes": ["de": "Minuten", "en": "minutes", "es": "minutos", "fr": "minutes"],
        "common.hourShort": ["de": "h", "en": "h", "es": "h", "fr": "h"],
        "common.minuteShort": ["de": "min", "en": "min", "es": "min", "fr": "min"],

        "home.earnings": ["de": "Verdienst", "en": "Earnings", "es": "Ingresos", "fr": "Revenus"],
        "home.monthHours": ["de": "Arbeitsstunden diesen Monat", "en": "Work hours this month", "es": "Horas trabajadas este mes", "fr": "Heures travaillées ce mois-ci"],
        "home.hourlyRate": ["de": "Stundenlohn", "en": "Hourly rate", "es": "Tarifa por hora", "fr": "Taux horaire"],
        "home.addWorkTime": ["de": "Arbeitszeit hinzufügen", "en": "Add work time", "es": "Añadir horas de trabajo", "fr": "Ajouter du temps de travail"],
        "home.editWorkTime": ["de": "Arbeitszeit bearbeiten", "en": "Edit work time", "es": "Editar horas de trabajo", "fr": "Modifier le temps de travail"],
        "home.workDays": ["de": "Arbeitstage", "en": "Work days", "es": "Días de trabajo", "fr": "Jours travaillés"],
        "home.emptyTitle": ["de": "Noch keine Arbeitszeiten", "en": "No work times yet", "es": "Aún no hay horas de trabajo", "fr": "Aucun temps de travail"],
        "home.emptyMessage": ["de": "Füge einen Arbeitstag hinzu, um Verdienst und Statistik zu berechnen.", "en": "Add a work day to calculate earnings and statistics.", "es": "Añade un día de trabajo para calcular ingresos y estadísticas.", "fr": "Ajoutez une journée de travail pour calculer les revenus et les statistiques."],
        "home.workTime": ["de": "Arbeitszeit", "en": "Work time", "es": "Tiempo de trabajo", "fr": "Temps de travail"],
        "home.date": ["de": "Datum", "en": "Date", "es": "Fecha", "fr": "Date"],
        "home.start": ["de": "Beginn", "en": "Start", "es": "Inicio", "fr": "Début"],
        "home.end": ["de": "Ende", "en": "End", "es": "Fin", "fr": "Fin"],
        "home.pause": ["de": "Pause", "en": "Break", "es": "Pausa", "fr": "Pause"],
        "home.note": ["de": "Notiz", "en": "Note", "es": "Nota", "fr": "Note"],
        "home.calculation": ["de": "Berechnung", "en": "Calculation", "es": "Cálculo", "fr": "Calcul"],
        "home.previousMonth": ["de": "Vorheriger Monat", "en": "Previous month", "es": "Mes anterior", "fr": "Mois précédent"],
        "home.nextMonth": ["de": "Nächster Monat", "en": "Next month", "es": "Mes siguiente", "fr": "Mois suivant"],

        "statistics.title": ["de": "Statistik", "en": "Statistics", "es": "Estadísticas", "fr": "Statistiques"],
        "statistics.hoursPerDay": ["de": "Arbeitsstunden pro Tag", "en": "Work hours per day", "es": "Horas trabajadas por día", "fr": "Heures travaillées par jour"],
        "statistics.earningsPerDay": ["de": "Verdienst pro Tag", "en": "Earnings per day", "es": "Ingresos por día", "fr": "Revenus par jour"],
        "statistics.totalHours": ["de": "Gesamtstunden", "en": "Total hours", "es": "Horas totales", "fr": "Heures totales"],
        "statistics.totalEarnings": ["de": "Gesamtverdienst", "en": "Total earnings", "es": "Ingresos totales", "fr": "Revenus totaux"],
        "statistics.averageHours": ["de": "Durchschnitt Stunden", "en": "Average hours", "es": "Promedio de horas", "fr": "Moyenne des heures"],
        "statistics.averageEarnings": ["de": "Durchschnitt Verdienst", "en": "Average earnings", "es": "Promedio de ingresos", "fr": "Revenu moyen"],
        "statistics.workDayCount": ["de": "Anzahl Arbeitstage", "en": "Number of work days", "es": "Número de días trabajados", "fr": "Nombre de jours travaillés"],
        "statistics.longestDay": ["de": "Längster Arbeitstag", "en": "Longest work day", "es": "Día de trabajo más largo", "fr": "Journée la plus longue"],
        "statistics.selectMonth": ["de": "Monat auswählen", "en": "Select month", "es": "Seleccionar mes", "fr": "Choisir le mois"],
        "statistics.dayAxis": ["de": "Tag", "en": "Day", "es": "Día", "fr": "Jour"],
        "statistics.hoursAxis": ["de": "Stunden", "en": "Hours", "es": "Horas", "fr": "Heures"],

        "trophies.title": ["de": "Trophäen", "en": "Trophies", "es": "Trofeos", "fr": "Trophées"],
        "trophies.subtitle": ["de": "Verdiene Geld und schalte Meilensteine frei.", "en": "Earn money and unlock milestones.", "es": "Gana dinero y desbloquea hitos.", "fr": "Gagnez de l’argent et débloquez des objectifs."],
        "trophies.unlocked": ["de": "Freigeschaltet", "en": "Unlocked", "es": "Desbloqueado", "fr": "Débloqué"],
        "trophies.locked": ["de": "Noch nicht freigeschaltet", "en": "Not unlocked yet", "es": "Aún no desbloqueado", "fr": "Pas encore débloqué"],
        "trophies.unlockedAt": ["de": "Freigeschaltet am", "en": "Unlocked on", "es": "Desbloqueado el", "fr": "Débloqué le"],
        "trophies.progress": ["de": "Fortschritt", "en": "Progress", "es": "Progreso", "fr": "Progression"],
        "trophies.requiredAmount": ["de": "Benötigter Betrag", "en": "Required amount", "es": "Importe requerido", "fr": "Montant requis"],
        "trophies.currentProgress": ["de": "Aktueller Fortschritt", "en": "Current progress", "es": "Progreso actual", "fr": "Progression actuelle"],
        "trophies.detailTitle": ["de": "Trophäe", "en": "Trophy", "es": "Trofeo", "fr": "Trophée"],
        "trophies.100.title": ["de": "100 € erreicht", "en": "€100 reached", "es": "100 € alcanzados", "fr": "100 € atteints"],
        "trophies.100.description": ["de": "Du hast insgesamt 100 € verdient.", "en": "You have earned €100 in total.", "es": "Has ganado 100 € en total.", "fr": "Vous avez gagné 100 € au total."],
        "trophies.500.title": ["de": "500 € erreicht", "en": "€500 reached", "es": "500 € alcanzados", "fr": "500 € atteints"],
        "trophies.500.description": ["de": "Du hast insgesamt 500 € verdient.", "en": "You have earned €500 in total.", "es": "Has ganado 500 € en total.", "fr": "Vous avez gagné 500 € au total."],
        "trophies.1000.title": ["de": "1.000 € erreicht", "en": "€1,000 reached", "es": "1.000 € alcanzados", "fr": "1 000 € atteints"],
        "trophies.1000.description": ["de": "Du hast insgesamt 1.000 € verdient.", "en": "You have earned €1,000 in total.", "es": "Has ganado 1.000 € en total.", "fr": "Vous avez gagné 1 000 € au total."],

        "settings.title": ["de": "Einstellungen", "en": "Settings", "es": "Ajustes", "fr": "Réglages"],
        "settings.language": ["de": "Sprache", "en": "Language", "es": "Idioma", "fr": "Langue"],
        "settings.preferredHand": ["de": "Bedienhand", "en": "Preferred hand", "es": "Mano preferida", "fr": "Main préférée"],
        "settings.preferredHand.left": ["de": "Linkshänder", "en": "Left-handed", "es": "Zurdo", "fr": "Gaucher"],
        "settings.preferredHand.right": ["de": "Rechtshänder", "en": "Right-handed", "es": "Diestro", "fr": "Droitier"],
        "settings.currency": ["de": "Währung", "en": "Currency", "es": "Moneda", "fr": "Devise"],
        "settings.hourlyRate": ["de": "Stundenlohn", "en": "Hourly rate", "es": "Tarifa por hora", "fr": "Taux horaire"],
        "settings.defaultPause": ["de": "Standardpause", "en": "Default break", "es": "Pausa predeterminada", "fr": "Pause par défaut"],
        "settings.app": ["de": "App", "en": "App", "es": "App", "fr": "App"],
        "settings.appVersion": ["de": "App-Version", "en": "App version", "es": "Versión de la app", "fr": "Version de l’app"]
    ]
}
