import 'package:business/src/models/tag_model.dart';
import 'package:infrastructure/infrastructure.dart';

class TagService {
  final TagRepository _repository;

  TagService() : _repository = TagRepository();

  Future<List<Tag>> getTags() async {
    List<TagEntity> tagsEntity = await _repository.getTags();
    return tagsEntity
        .map((TagEntity entity) => Tag.fromEntity(entity))
        .toList();
  }

  Future<Tag> getTagWithId(int tagId) async {
    return Tag.fromEntity(await _repository.getTagWithId(tagId));
  }

  Future<int> deleteTagWithId(int tagId) async {
    return await _repository.deleteTagWithId(tagId);
  }

  Future<int> insert(Tag tag) async {
    return await _repository.insertTag(tag.toEntity());
  }

  Future<int> updateTag(Tag tag) async {
    return await _repository.updateTag(tag.toEntity());
  }



}
