import 'package:infrastructure/infrastructure.dart';

class BackupService {
  final BackupRepository _repository;

  BackupService() : _repository = BackupRepository();

  Future<void> runScript(String sqlScript) async {
    await _repository.runScript(sqlScript);
  }
}
