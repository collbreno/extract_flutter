import 'package:business/src/models/expense_model.dart';
import 'package:infrastructure/infrastructure.dart';

class ExpenseService {
  final ExpenseRepository _expenseRepository;
  final TagRepository _tagRepository;
  final CategoryRepository _categoryRepository;
  final ExpenseTagsRepository _relationRepository;

  ExpenseService()
      : _expenseRepository = ExpenseRepository(),
        _tagRepository = TagRepository(),
        _categoryRepository = CategoryRepository(),
        _relationRepository = ExpenseTagsRepository();

  Future<int> insertExpense(Expense expense) async {
    int result = await _expenseRepository.insertExpense(expense.toEntity());
    expense.id = result;
    if (expense.tags != null && expense.tags.isNotEmpty) {
      await _relationRepository
          .insertExpenseTags(expense.getExpenseTagsEntity());
    }
    return result;
  }

  Future<int> deleteExpenseWithId(int expenseId) async {
    int result = await _expenseRepository.deleteExpenseWithId(expenseId);
    await _relationRepository.deleteExpenseTagsWithExpenseId(expenseId);
    return result;
  }

  Future<List<Expense>> getExpenses() async {
    List<ExpenseEntity> expenseEntities =
    await _expenseRepository.getExpenses();
    return Future.wait(expenseEntities.map((ExpenseEntity expenseEntity) async {
      return Expense.fromEntities(
        expenseEntity: expenseEntity,
        categoryEntity: await _categoryRepository
            .getCategoryWithId(expenseEntity.categoryId),
        tagEntities:
        await _tagRepository.getTagsOfExpenseWithId(expenseEntity.id),
      );
    }).toList());
  }

  Future<Expense> getExpenseWithId(int expenseId) async {
    ExpenseEntity expenseEntity = await _expenseRepository.getExpenseWithId(
        expenseId);
    return Expense.fromEntities(
      expenseEntity: expenseEntity,
      categoryEntity: await _categoryRepository.getCategoryWithId(
          expenseEntity.categoryId),
      tagEntities: await _tagRepository.getTagsOfExpenseWithId(expenseId),
    );
  }

  Future<int> getTotalValueFromMonth() async {
    int result = await _expenseRepository.getTotalValueFromMonth();
    return result ?? 0;
  }

}
