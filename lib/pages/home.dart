import 'package:cooking/models/addrecipe.dart';
import 'package:cooking/models/recipe.dart';
import 'package:cooking/network/auth.dart';
import 'package:cooking/pages/login.dart';
import 'package:flutter/material.dart';
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
  String firstName = "";
  String lastName = "";
  String bodyTemp = "";
  var measure;

  Duration get loginTime => const Duration(milliseconds: 1250);
  final NetworkService _networkService = NetworkService();
  RecipesNetworkService _recipesNetworkService = RecipesNetworkService();
  int _selectedIndex = 0;

  ListTile _tile(String title, String subtitle) {
    return ListTile(
      title: Text(title,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 20,
          )),
      subtitle: Text(subtitle),
    );
  }

  Widget buildListWidget(List<Recipe> _recipes) {
    return ListView.separated(
      padding: const EdgeInsets.all(8),
      itemCount: _recipes.length,
      itemBuilder: (BuildContext context, int index) {
        return SizedBox(
          height: 70,
          child: _tile(_recipes[index].title,
              _recipes[index].description.substring(0, 80) + "..."),
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
          height: 70,
          child: _tile(_recipes[index].title,
              _recipes[index].description.substring(0, 80) + "..."),
        );
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }

  void _addRecipe() {}

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  FutureBuilder<List<Recipe>> _buildCurrentList(BuildContext context) {
    return FutureBuilder<List<Recipe>>(
      future: _recipesNetworkService.getAllRecipes(),
      builder: (context, snapshot) {
        if (snapshot.data != null) {
          List<Recipe> _recipes = snapshot.data!;
          return buildListWidget(_recipes);
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  FutureBuilder<List<Viewrecipe>> _buildFavoriteList(BuildContext context) {
    return FutureBuilder<List<Viewrecipe>>(
      future: _recipesNetworkService.getFavorite(),
      builder: (context, snapshot) {
        if (snapshot.data != null) {
          List<Viewrecipe> _recipes = snapshot.data!;
          return buildFavoriteListWidget(_recipes);
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
              child: Text("Добавьте рецепт",
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
                        firstName = value;
                        // firstNameList.add(firstName);
                      });
                    },
                    onChanged: (value) {
                      setState(() {
                        firstName = value;
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
                        lastName = value;
                        // lastNameList.add(lastName);
                      });
                    },
                    onChanged: (value) {
                      setState(() {
                        lastName = value;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 20,
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
                                title: "ttttt", description: "fdsfsdf")))
                            .then(
                          (x) {
                            if (x) {
                              Navigator.pop(context);
                            }
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
                (x) {
                  Navigator.of(context)
                      .pushReplacementNamed(LoginScreen.routeName);
                },
              );
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
        backgroundColor: const Color.fromRGBO(70, 30, 100, 0.8),
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
