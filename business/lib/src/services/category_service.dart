import 'package:business/src/models/category_model.dart';
import 'package:infrastructure/infrastructure.dart';

class CategoryService {
  final CategoryRepository _repository;

  CategoryService() : _repository = CategoryRepository();

  Future<List<Category>> getCategories() async {
    List<CategoryEntity> categoriesEntity = await _repository.getCategories();
    return categoriesEntity
        .map((CategoryEntity entity) => Category.fromEntity(entity))
        .toList();
  }

  Future<Map<Category, int>> getCategoriesWithTotalValue() async {
    List<CategoryWithValueEntity> categoriesWithValueEntity =
        await _repository.getCategoriesWithTotalValue();
    return Map<Category, int>.fromIterable(
      categoriesWithValueEntity,
      key: (entity) => Category.fromEntity(entity),
      value: (entity) => entity.totalValue,
    );
  }

  Future<Category> getCategoryWithId(int categoryId) async {
    return Category.fromEntity(await _repository.getCategoryWithId(categoryId));
  }

  Future<int> deleteCategoryWithId(int categoryId) async {
    return await _repository.deleteCategoryWithId(categoryId);
  }

  Future<int> insert(Category category) async {
    return await _repository.insertCategory(category.toEntity());
  }

  Future<int> updateCategory(Category category) async {
    return await _repository.updateCategory(category.toEntity());
  }

  Future<int> getUsagesOfCategory(int categoryId) async {
    int result = await _repository.getUsagesOfCategory(categoryId);
    return result ?? 0;
  }
}
