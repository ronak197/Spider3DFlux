import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/material.dart';
import 'package:quiver/strings.dart';

import '../common/constants.dart';
import '../services/index.dart';
import 'entities/category.dart';

class CategoryModel with ChangeNotifier {
  final Services _service = Services();
  List<Category>? categories;
  List<Category> myIncluded_categories = [];
  Map<String?, Category> categoryList = {};

  bool isLoading = false;
  String? message;

  /// Format the Category List and assign the List by Category ID
  void sortCategoryList(
      {List<Category>? categoryList,
      dynamic sortingList,
      String? categoryLayout}) {
    var _categoryList = <String?, Category>{};
    var result = categoryList;

    if (sortingList != null) {
      var _categories = <Category>[];
      var _subCategories = <Category>[];
      var isParent = true;
      for (var category in sortingList) {
        var item = categoryList!.firstWhereOrNull(
            (Category cat) => cat.id.toString() == category.toString());
        if (item != null) {
          if (item.parent != '0') {
            isParent = false;
          }
          _categories.add(item);
        }
      }
      if (!['column', 'grid', 'subCategories'].contains(categoryLayout)) {
        for (var category in categoryList!) {
          var item =
              _categories.firstWhereOrNull((cat) => cat.id == category.id);
          if (item == null && isParent && category.parent != '0') {
            _subCategories.add(category);
          }
        }
      }
      result = [..._categories, ..._subCategories];
      print("category result");
      print(result);
    }

    for (var cat in result!) {
      _categoryList[cat.id] = cat;
    }
    this.categoryList = _categoryList;
    categories = result;
    notifyListeners();

    // My exclude categories
/*    var myIncluded_ids = [
      '2342', '5249', '2343',
      // 4939,
      '2341', '2352', '5161',
      // 4905,
      '5188',
    ];*/
    // print('categories');
    // print(categories);

    // for (var cat in categories!) {
    //   if (myIncluded_ids.contains(cat.id)) {
    //     myIncluded_categories.add(cat);
    //   }
    // }

    myIncluded_categories = categories!;

    // My Replace places of values in the list (A,B,C -> B,A,C), At Least 1 value should be in list!
    void replaceInList(List list, a, b) {
      // Define values places
      var list_len = list.length;
      var a_index = list.indexOf(a);
      var b_index = list.indexOf(b);

      // Add (1) Value if not in list
      if (a_index == -1) list.add(a); // AKA null
      if (b_index == -1) list.add(b);

      // Redefine values places
      a_index = list.indexOf(a);
      b_index = list.indexOf(b);

      // Switch between their places
      list.insert(a_index, b); // means .addAt
      list.removeAt(a_index + 1);

      list.insert(b_index, a); // means .addAt
      list.removeAt(b_index + 1);

      // Remove rest unnecessary value if left
      if (list_len != list.length) list.removeAt(list.length - 1);
    }

    // List<Category> setCategoriesOrder() {final categories = Provider.of<CategoryModel>(context).myIncluded_categories;

    print(
        "ccategories X Be = $categories"); // ccategories X Be = [Category { id: 5249  name: חבילות חיסכון והוזלות}, Category { id: 2352  name: חומרי גלם להדפסה}, Category { id: 5188  name: חלפים מקוריים Artillery Genius}, Category { id: 5161  name: חלקי חילוף מקוריים לארטילרי}, Category { id: 2343  name: כלי עבודה וחומרים ל-DIY}, Category { id: 2341  name: מדפסות תלת מימד}, Category { id: 2342  name: שדרוגים וחלפים למדפסות}]
    // print('ccategories X Be = ${categories[0].name}'); // case
    // replaceInList(categories, categories[0],categories[1]); // Equals = replaceInList(categories, 'חבילות חיסכון והוזלות', 'חומרי גלם להדפסה');

    var forIndex = 0;
    // if (1 == 1) return categories!;
    for (var item in categories!) {
      switch (item.name) {
        case 'מדפסות תלת מימד':
          replaceInList(categories!, categories![forIndex], categories![0]);
          printLog(
              '${item.name} - category moved from $forIndex to [0] in list.');
          forIndex++;
          break;
        case 'חומרי גלם להדפסה': // categories![forIndex] = 'חבילות חיסכון והוזלות'
          replaceInList(categories!, categories![forIndex], categories![1]);
          printLog(
              '${item.name} - category moved from $forIndex to [1] in list.');
          // print('$forIndex');
          forIndex++;
          break;
        case 'כלי עבודה וחומרים ל-DIY':
          replaceInList(categories!, categories![forIndex], categories![2]);
          printLog(
              '${item.name} - category moved from $forIndex to [2] in list.');
          forIndex++;
          break;
        case 'שדרוגים וחלפים למדפסות':
          replaceInList(categories!, categories![forIndex], categories![3]);
          printLog(
              '${item.name} - category moved from $forIndex to [3] in list.');
          forIndex++;
          break;
        default:
          // print('$forIndex');
          forIndex++;
        // print(forIndex);
      }
    }
    print("ccategories X Af = $categories");
    // return categories;
    // }

    // print('myIncluded_categories');
    // print(myIncluded_categories);
    notifyListeners();
  }

  Future<void> getCategories({lang, sortingList, categoryLayout}) async {
    try {
      printLog('[Category] getCategories');
      isLoading = true;
      notifyListeners();
      categories = await _service.api.getCategories(lang: lang);
      message = null;

      sortCategoryList(
          categoryList: categories,
          sortingList: sortingList,
          categoryLayout: categoryLayout);
      isLoading = false;
      notifyListeners();
    } catch (err, _) {
      isLoading = false;
      message = 'There is an issue with the app during request the data, '
              'please contact admin for fixing the issues ' +
          err.toString();
      //notifyListeners();
    }
  }

  /// Prase category list from json Object
  static List<Category> parseCategoryList(response) {
    var categories = <Category>[];
    if (response is Map && isNotBlank(response['message'])) {
      throw Exception(response['message']);
    } else {
      for (var item in response) {
        if (item['slug'] != 'uncategorized') {
          categories.add(Category.fromJson(item));
        }
      }
      return categories;
    }
  }
}
