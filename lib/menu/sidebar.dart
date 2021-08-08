import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:inspireui/inspireui.dart';
import 'package:provider/provider.dart';

import '../common/config.dart';
import '../common/constants.dart';
import '../common/tools/adaptive_tools.dart';
import '../generated/l10n.dart';
import '../models/index.dart'
    show AppModel, Category, CategoryModel, ProductModel, UserModel;
import '../modules/dynamic_layout/config/app_config.dart';
import '../services/service_config.dart';
import 'maintab_delegate.dart';

class SideBarMenu extends StatefulWidget {
  SideBarMenu();

  @override
  _MenuBarState createState() => _MenuBarState();
}

class _MenuBarState extends State<SideBarMenu> {
  void pushNavigation(String name) {
    eventBus.fire(const EventCloseNativeDrawer());
    return MainTabControlDelegate.getInstance()
        .changeTab(name.replaceFirst('/', ''));
  }

  @override
  Widget build(BuildContext context) {
    printLog('[AppState] Load Menu');
    var drawer =
        Provider.of<AppModel>(context, listen: false).appConfig!.drawer;

    return Column(
      key: drawer!.key != null ? Key(drawer.key as String) : UniqueKey(),
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 50),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (drawer.logo != null)
                    Container(
                      height: 50,
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(bottom: 10),
                      // child: FluxImage(imageUrl: drawer.logo as String),
                      child: const FluxImage(
                          imageUrl: 'https://i.imgur.com/LQWSjzt.png'),
                    ),
                  // const Divider(),
                  ...List.generate(
                    drawer.items!.length,
                    (index) {
                      return drawerItem(drawer.items![index]);
                    },
                  ),
                  isDisplayDesktop(context)
                      ? const SizedBox(height: 300)
                      : const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget drawerItem(DrawerItemsConfig item) {
    // final isTablet = Tools.isTablet(MediaQuery.of(context));

    if (item.show == false) return const SizedBox();

    final isListing = Config().isListingType;

    switch (item.type) {
      case 'home':
        {
          return ListTile(
            leading: Icon(
              isListing ? Icons.home : Icons.shopping_basket,
              size: 20,
            ),
            title: Text(
              isListing ? S.of(context).home : S.of(context).shop,
            ),
            onTap: () {
              pushNavigation(RouteList.home);
            },
          );
        }
      case 'categories':
        {
          return ListTile(
            leading: const Icon(Icons.category, size: 20),
            title: Text(S.of(context).categories),
            onTap: () => pushNavigation(
              Provider.of<AppModel>(context, listen: false).vendorType ==
                      VendorType.single
                  ? RouteList.category
                  : RouteList.vendorCategory,
            ),
          );
        }
      case 'cart':
        {
          if (Config().isListingType) {
            return Container();
          }
          return ListTile(
            leading: const Icon(Icons.shopping_cart, size: 20),
            title: Text(S.of(context).cart),
            onTap: () => pushNavigation(RouteList.cart),
          );
        }
      case 'profile':
        {
          return ListTile(
            // minVerticalPadding: 0,
            // contentPadding: const EdgeInsets.all(0),
            leading: const Icon(Icons.person, size: 22),
            title: Text(S.of(context).settings),
            onTap: () => pushNavigation(RouteList.profile),
          );
        }
      case 'web':
        {
          return kIsWeb || isDisplayDesktop(context)
              ? Column(
                  children: [
                    ListTile(
                      leading: const Icon(
                        Icons.list,
                        size: 20,
                      ),
                      title: Text(S.of(context).category),
                      onTap: () {
                        pushNavigation(RouteList.category);
                      },
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.search,
                        size: 20,
                      ),
                      title: Text(S.of(context).search),
                      onTap: () {},
                    ),
                    ListTile(
                      leading: const Icon(Icons.settings, size: 20),
                      title: Text(S.of(context).settings),
                      onTap: () {
                        if (kIsWeb) {
                        } else {
                          Navigator.of(context).pushNamed(RouteList.profile);
                        }
                      },
                    )
                  ],
                )
              : const SizedBox();
        }
      case 'blog':
        {
          return ListTile(
              leading: const Icon(FontAwesomeIcons.graduationCap, size: 18),
              title: Text(S.of(context).blog),
              onTap: () {
                pushNavigation(RouteList.blogs);
              });
        }
      case 'login':
        {
          return ListenableProvider.value(
            value: Provider.of<UserModel>(context, listen: false),
            child: Consumer<UserModel>(builder: (context, userModel, _) {
              final loggedIn = userModel.loggedIn;
              return ListTile(
                leading: const Icon(FontAwesomeIcons.doorOpen, size: 18),
                title: loggedIn
                    ? Text(S.of(context).logout)
                    : Text(S.of(context).login),
                onTap: () {
                  if (loggedIn) {
                    Provider.of<UserModel>(context, listen: false).logout();
                    if (kLoginSetting['IsRequiredLogin'] ?? false) {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        RouteList.login,
                        (route) => false,
                      );
                    } else {
                      pushNavigation(RouteList.dashboard);
                    }
                  } else {
                    pushNavigation(RouteList.login);
                  }
                },
              );
            }),
          );
        }
      case 'category':
        {
          return buildListCategory();
        }
      default:
        return Container();
    }
  }

  Widget buildListCategory() {
    final categories = Provider.of<CategoryModel>(context).categories;
    var widgets = <Widget>[];

    if (categories != null) {
      var list = categories.where((item) => item.parent == '0').toList();
      for (var i = 0; i < list.length; i++) {
        final currentCategory = list[i];
        var childCategories =
            categories.where((o) => o.parent == currentCategory.id).toList();
        widgets.add(Container(
          color: i.isOdd
              ? Theme.of(context).backgroundColor
              : Theme.of(context).primaryColorLight,

          /// Check to add only parent link category
          child: childCategories.isEmpty
              ? InkWell(
                  onTap: () {
                    ProductModel.showList(
                      context: context,
                      cateId: currentCategory.id,
                      cateName: currentCategory.name,
                    );
                  },
                  child: Container(
                    // color: Colors.green,
                    padding: const EdgeInsets.only(
                      right: 20,
                      bottom: 12,
                      left: 16,
                      top: 12,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            child: Text(
                          currentCategory.name!.toUpperCase(),
                          style: const TextStyle(
                            // color: Theme.of(context).primaryColor,
                            fontSize: 14,
                          ),
                        )),
                        const SizedBox(width: 24),
                        currentCategory.totalProduct == null
                            ? const Icon(Icons.chevron_right)
                            : Container(
                                // color: Colors.green,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Text(
                                  S
                                      .of(context)
                                      .nItems(currentCategory.totalProduct!),
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                )
              : ExpansionTile(
                  title: Padding(
                    padding: const EdgeInsets.only(left: 0.0, top: 0),
                    child: Text(
                      currentCategory.name!.toUpperCase(),
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                  textColor: Theme.of(context).primaryColor,
                  iconColor: Theme.of(context).primaryColor,
                  // iconColor: Colors.green,
                  children:
                      getChildren(categories, currentCategory, childCategories)
                          as List<Widget>,
                ),
        ));
      }
    }

    return ExpansionTile(
      iconColor: Theme.of(context).accentColor.withOpacity(0.5),
      // iconColor: Colors.green,
      initiallyExpanded: true,
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      tilePadding: const EdgeInsets.only(left: 16, right: 8),
      title: Text(
        "קטגוריות",
        // S.of(context).byCategory.toUpperCase(),
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).accentColor.withOpacity(0.5),
        ),
      ),
      children: widgets,
    );
  }

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

  List<Category> setCategoriesOrder() {
    final categories = Provider.of<CategoryModel>(context).categories;

    print(
        "ccategories X Be = $categories"); // ccategories X Be = [Category { id: 5249  name: חבילות חיסכון והוזלות}, Category { id: 2352  name: חומרי גלם להדפסה}, Category { id: 5188  name: חלפים מקוריים Artillery Genius}, Category { id: 5161  name: חלקי חילוף מקוריים לארטילרי}, Category { id: 2343  name: כלי עבודה וחומרים ל-DIY}, Category { id: 2341  name: מדפסות תלת מימד}, Category { id: 2342  name: שדרוגים וחלפים למדפסות}]
    // print('ccategories X Be = ${categories[0].name}'); // case
    // replaceInList(categories, categories[0],categories[1]); // Equals = replaceInList(categories, 'חבילות חיסכון והוזלות', 'חומרי גלם להדפסה');

    var forIndex = 0;
    // if (1 == 1) return categories;
    for (var item in categories!) {
      switch (item.name) {
        case 'מדפסות תלת מימד':
          replaceInList(categories, categories[forIndex], categories[0]);
          printLog(
              '${item.name} - category moved from $forIndex to [0] in list.');
          forIndex++;
          break;
        case 'חומרי גלם להדפסה': // categories[forIndex] = 'חבילות חיסכון והוזלות'
          replaceInList(categories, categories[forIndex], categories[1]);
          printLog(
              '${item.name} - category moved from $forIndex to [1] in list.');
          // print('$forIndex');
          forIndex++;
          break;
        case 'כלי עבודה וחומרים ל-DIY':
          replaceInList(categories, categories[forIndex], categories[2]);
          printLog(
              '${item.name} - category moved from $forIndex to [2] in list.');
          forIndex++;
          break;
        case 'שדרוגים וחלפים למדפסות':
          replaceInList(categories, categories[forIndex], categories[3]);
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
    return categories;
  }

  List getChildren(
    List<Category> categories,
    Category currentCategory,
    List<Category> childCategories, {
    double paddingOffset = 0.0,
  }) {
    var list = <Widget>[];

    categories = setCategoriesOrder();
    print('setCategoriesOrder Done');
    list.add(
      ListTile(
        leading: Padding(
          padding: EdgeInsets.only(left: 20 + paddingOffset),
          child: Text(S.of(context).seeAll),
        ),
        trailing: Text(
          S.of(context).nItems(currentCategory.totalProduct!),
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: 12,
          ),
        ),
        onTap: () {
          ProductModel.showList(
            context: context,
            cateId: currentCategory.id,
            cateName: currentCategory.name,
          );
        },
      ),
    );
    for (var i in childCategories) {
      var newChildren = categories.where((cat) => cat.parent == i.id).toList();
      if (newChildren.isNotEmpty) {
        list.add(
          ExpansionTile(
            title: Padding(
              padding: EdgeInsets.only(left: 20.0 + paddingOffset),
              child: Text(
                i.name!.toUpperCase(),
                style: const TextStyle(fontSize: 14),
              ),
            ),
            children: getChildren(
              categories,
              i,
              newChildren,
              paddingOffset: paddingOffset + 10,
            ) as List<Widget>,
          ),
        );
      } else {
        list.add(
          ListTile(
            title: Padding(
              padding: EdgeInsets.only(left: 20 + paddingOffset),
              child: Text(i.name!),
            ),
            trailing: Text(
              S.of(context).nItems(i.totalProduct!),
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 12,
              ),
            ),
            onTap: () {
              ProductModel.showList(
                  context: context, cateId: i.id, cateName: i.name);
            },
          ),
        );
      }
    }
    return list;
  }
}
