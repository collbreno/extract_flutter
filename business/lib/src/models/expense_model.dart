import 'package:business/src/models/category_model.dart';
import 'package:business/src/models/tag_model.dart';
import 'package:infrastructure/infrastructure.dart';

class Expense {
  int id;
  int value;
  String description;
  DateTime date;
  Category category;
  List<Tag> tags;

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

  Expense copy({
    int id,
    int value,
    String description,
    DateTime date,
    Category category,
    List<Tag> tags,
  }) =>
      Expense(
        id: id ?? this.id,
        value: value ?? this.value,
        date: date ?? this.date,
        tags: tags ?? this.tags.toList(),
        description: description ?? this.description,
        category: category ?? this.category.copy(),
      );
}
