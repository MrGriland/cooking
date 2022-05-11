import 'package:cooking/db/dbcontext.dart';
import 'package:cooking/models/addrecipe.dart';
import 'package:cooking/models/container.dart';
import 'package:cooking/models/recipe.dart';
import 'package:cooking/network/auth.dart';
import 'package:cooking/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_login/flutter_login.dart';

import '../models/viewrecipe.dart';
import '../network/recipesnetwork.dart';
import '../widgets/recipes.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  String title = "";
  String description = "";
  DBRecipeProvider _dbRecipeProvider = DBRecipeProvider();

  Duration get loginTime => const Duration(milliseconds: 1250);
  final NetworkService _networkService = NetworkService();
  final RecipesNetworkService _recipesNetworkService = RecipesNetworkService();
  int _selectedIndex = 0;

  void like(int id) {
    Future.value(_recipesNetworkService.addFavorite(Idcontainer(id: id))).then(
      (x) {
        if (x) {
          final snackBar = SnackBar(
            content: const Text('Добавлено в избранные'),
            action: SnackBarAction(
              label: 'Отмена',
              onPressed: () {
                unlike(id);
                setState(() {});
              },
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      },
    );
  }

  void unlike(int id) {
    Future.value(_recipesNetworkService.removeFavorite(Idcontainer(id: id)))
        .then(
      (x) {
        if (x) {
          final snackBar = SnackBar(
            content: const Text('Убрано из избранных'),
            action: SnackBarAction(
              label: 'Отмена',
              onPressed: () {
                like(id);
                setState(() {});
              },
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      },
    );
  }

  ListTile _maintile(DBRecipe recipe) {
    return ListTile(
      onLongPress: () {
        like(recipe.id);
        setState(() {});
      },
      title: Text(recipe.title,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 20,
          )),
      subtitle: Text(recipe.description.length < 81
          ? recipe.description
          : recipe.description),
    );
  }

  ListTile _favoritetile(Viewrecipe recipe) {
    return ListTile(
      onLongPress: () {
        unlike(recipe.id);
        setState(() {});
      },
      title: Text(recipe.title,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 20,
          )),
      subtitle: Text(recipe.description.length < 81
          ? recipe.description
          : recipe.description),
    );
  }

  Widget buildListWidget(List<DBRecipe> _recipes) {
    return ListView.separated(
      padding: const EdgeInsets.all(8),
      itemCount: _recipes.length,
      itemBuilder: (BuildContext context, int index) {
        return SizedBox(
          child: _maintile(_recipes[index]),
        );
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }

  Widget buildFavoriteListWidget(List<Viewrecipe> _recipes) {
    return ListView.separated(
      padding: const EdgeInsets.all(8),
      itemCount: _recipes.length,
      itemBuilder: (BuildContext context, int index) {
        return SizedBox(
          child: _favoritetile(_recipes[index]),
        );
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  FutureBuilder<List<DBRecipe>> _buildCurrentList(BuildContext context) {
    return FutureBuilder<List<DBRecipe>>(
      future: _recipesNetworkService.sync(),
      builder: (context, snapshot) {
        if (snapshot.data != null) {
          return buildListWidget(snapshot.data!);
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Future<List<DBRecipe>> dbOperations() async {
    await _dbRecipeProvider.open(await _dbRecipeProvider.getdbpath());
    return _dbRecipeProvider.fetchFromDB();
  }

  FutureBuilder<List<Viewrecipe>> _buildFavoriteList(BuildContext context) {
    return FutureBuilder<List<Viewrecipe>>(
      future: _recipesNetworkService.getFavorite(),
      builder: (context, snapshot) {
        if (snapshot.data != null) {
          return buildFavoriteListWidget(snapshot.data!);
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _buildNewRecipe() {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 100, 16, 16),
        child: Column(
          children: <Widget>[
            const Align(
              alignment: Alignment.topLeft,
              child: Text("Добавьте новый рецепт",
                  style: TextStyle(
                    fontSize: 24,
                  )),
            ),
            const SizedBox(
              height: 20,
            ),
            Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  TextFormField(
                    decoration: const InputDecoration(
                        labelText: 'Название',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          borderSide:
                              BorderSide(color: Colors.grey, width: 0.0),
                        ),
                        border: OutlineInputBorder()),
                    onFieldSubmitted: (value) {
                      setState(() {
                        title = value;
                      });
                    },
                    onChanged: (value) {
                      setState(() {
                        title = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Название не может быть пустым';
                      }
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                        labelText: 'Описание',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          borderSide:
                              BorderSide(color: Colors.grey, width: 0.0),
                        ),
                        border: OutlineInputBorder()),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Описание не может быть пустым';
                      }
                    },
                    onFieldSubmitted: (value) {
                      setState(() {
                        description = value;
                      });
                    },
                    onChanged: (value) {
                      setState(() {
                        description = value;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: const Color.fromRGBO(70, 30, 100, 0.8),
                      minimumSize: const Size.fromHeight(60),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Future.value(_recipesNetworkService.addRecipe(Addrecipe(
                                title: title, description: description)))
                            .then(
                          (x) {
                            Navigator.pop(context);
                          },
                        );
                        //_submit();
                      }
                    },
                    child: const Text("Добавить"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Выход',
            onPressed: () {
              Future.value(_networkService.logout()).then(
                (x) {},
              );
              Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
            },
          ),
        ],
      ),
      body: _selectedIndex == 0
          ? _buildCurrentList(context)
          : _buildFavoriteList(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) => _buildNewRecipe(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt),
            label: 'Рецепты',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Избранные',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
