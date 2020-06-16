import 'package:business/src/models/category_model.dart';
import 'package:business/src/models/tag_model.dart';
import 'package:infrastructure/infrastructure.dart';

class Expense {
  int id;
  final int value;
  final String description;
  final DateTime date;
  final Category category;
  final List<Tag> tags;

  Expense({
    this.id,
    this.value,
    this.description,
    this.date,
    this.category,
    this.tags,
  });

  Expense.fromEntities({
    ExpenseEntity expenseEntity,
    CategoryEntity categoryEntity,
    List<TagEntity> tagEntities,
  })  : id = expenseEntity.id,
        value = expenseEntity.value,
        description = expenseEntity.description,
        date = expenseEntity.date,
        category = Category.fromEntity(categoryEntity),
        tags = tagEntities
            ?.map((tagEntity) => Tag.fromEntity(tagEntity))
            ?.toList();

  ExpenseEntity toEntity() {
    return ExpenseEntity(
      id: id,
      categoryId: category.id,
      date: date,
      description: description,
      value: value,
    );
  }

  List<ExpenseTagsEntity> getExpenseTagsEntity() {
    return tags?.map((Tag tag) {
      return ExpenseTagsEntity(expenseId: id, tagId: tag.id);
    })?.toList();
  }
}
