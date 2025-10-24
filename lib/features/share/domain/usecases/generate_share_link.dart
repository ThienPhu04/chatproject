import 'package:finalproject/features/share/domain/repositories/share_repository.dart';
import '../entities/share_content.dart';

class GenerateShareLink {
  final ShareRepository repository;

  GenerateShareLink(this.repository);

  @override
  Future<String> call(ShareContent params) async {
    return await repository.generateShareLink(params);
  }
}