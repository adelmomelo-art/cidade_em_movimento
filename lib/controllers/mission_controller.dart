import 'package:flutter/foundation.dart';

import '../models/mission.dart';
import '../models/mission_option.dart';
import '../models/mission_result.dart';
import '../services/scoring_service.dart';

enum MissionStage { intro, choosing, consequence, feedback, completed }

class MissionController extends ChangeNotifier {
  MissionController({
    required this.mission,
    this._scoringService = const ScoringService(),
  });

  final Mission mission;
  final ScoringService _scoringService;

  MissionStage _stage = MissionStage.intro;
  MissionOption? _selectedOption;
  int _errors = 0;
  MissionResult? _result;

  MissionStage get stage => _stage;
  MissionOption? get selectedOption => _selectedOption;
  int get errors => _errors;
  MissionResult? get result => _result;

  void start() {
    if (_stage != MissionStage.intro) {
      return;
    }

    _stage = MissionStage.choosing;
    notifyListeners();
  }

  void selectOption(MissionOption option) {
    if (_stage != MissionStage.choosing) {
      return;
    }

    _selectedOption = option;

    if (!option.isCorrect) {
      _errors++;
    }

    _stage = MissionStage.consequence;
    notifyListeners();
  }

  void showFeedback() {
    if (_stage != MissionStage.consequence) {
      return;
    }

    if (_selectedOption == null) {
      return;
    }

    _stage = MissionStage.feedback;
    notifyListeners();
  }

  void continueAfterFeedback() {
    if (_stage != MissionStage.feedback) {
      return;
    }

    final option = _selectedOption;

    if (option == null) {
      return;
    }

    if (option.isCorrect) {
      _result = _scoringService.calculate(mission: mission, errors: _errors);

      _stage = MissionStage.completed;
    } else {
      _selectedOption = null;
      _stage = MissionStage.choosing;
    }

    notifyListeners();
  }
}
