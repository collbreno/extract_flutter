import 'package:business/src/models/tag_model.dart';
import 'package:infrastructure/infrastructure.dart';

class TagService {
  final TagRepository _tagRepository;
  final ExpenseTagsRepository _relationRepository;

  TagService()
      : _tagRepository = TagRepository(),
        _relationRepository = ExpenseTagsRepository();

  Future<List<Tag>> getTags() async {
    List<TagEntity> tagsEntity = await _tagRepository.getTags();
    return tagsEntity
        .map((TagEntity entity) => Tag.fromEntity(entity))
        .toList();
  }

  Future<Tag> getTagWithId(int tagId) async {
    return Tag.fromEntity(await _tagRepository.getTagWithId(tagId));
  }

  Future<int> deleteTagWithId(int tagId) async {
    return await _tagRepository.deleteTagWithId(tagId);
  }

  Future<int> insert(Tag tag) async {
    return await _tagRepository.insertTag(tag.toEntity());
  }

  Future<int> updateTag(Tag tag) async {
    return await _tagRepository.updateTag(tag.toEntity());
  }

  Future<int> getUsagesOfTag(int tagId) async {
    int result = await _relationRepository.getUsagesOfTag(tagId);
    return result ?? 0;
  }
}
