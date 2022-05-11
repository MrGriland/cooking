import 'dart:convert';
import 'package:cooking/db/dbcontext.dart';
import 'package:cooking/models/container.dart';
import 'package:cooking/models/recipe.dart';
import 'package:cooking/network/address.dart';
import 'package:cooking/network/cookie.dart';
import 'package:http/http.dart' as http;

import '../models/addrecipe.dart';
import '../models/viewrecipe.dart';

class RecipesNetworkService {
  Map<String, String> headers = {
    "content-type": "application/x-www-form-urlencoded"
  };
  String? recipes = "";
  final DBRecipeProvider _dbRecipeProvider = DBRecipeProvider();

  Future<List<Recipe>> getAllRecipes() {
    Map<String, String> getheaders = {
      "content-type": "application/x-www-form-urlencoded"
    };
    getheaders["Cookie"] = ".AspNet.ApplicationCookie=" + UserCookie.cookie;
    return http
        .get(
            Uri.parse("http://" +
                Address.address +
                "/CookingServerAuth/api/recipes/"),
            headers: getheaders)
        .then((http.Response response) {
      final int statusCode = response.statusCode;

      if (statusCode == 200) {
        return recipeFromJson(response.body);
      } else {
        return List<Recipe>.empty();
      }
    });
  }

  Future<List<Viewrecipe>> getFavorite() {
    Map<String, String> getheaders = {
      "content-type": "application/x-www-form-urlencoded"
    };
    getheaders["Cookie"] = ".AspNet.ApplicationCookie=" + UserCookie.cookie;
    return http
        .get(
            Uri.parse("http://" +
                Address.address +
                "/CookingServerAuth/api/favorite/"),
            headers: getheaders)
        .then((http.Response response) {
      final int statusCode = response.statusCode;

      if (statusCode == 200) {
        return viewrecipeFromJson(response.body);
      } else {
        return List<Viewrecipe>.empty();
      }
    });
  }

  Future<bool> addRecipe(Addrecipe recipe) {
    Map<String, String> getheaders = {};
    getheaders["Cookie"] = ".AspNet.ApplicationCookie=" + UserCookie.cookie;
    return http
        .post(
            Uri.parse("http://" +
                Address.address +
                "/CookingServerAuth/api/recipes/"),
            body: recipe.toJson(),
            encoding: Encoding.getByName('utf-8'),
            headers: getheaders)
        .then((http.Response response) {
      final int statusCode = response.statusCode;
      if (statusCode == 200) {
        return true;
      } else {
        return false;
      }
    });
  }

  Future<bool> addFavorite(Idcontainer idcontainer) {
    Map<String, String> getheaders = {"content-type": "application/json"};
    getheaders["Cookie"] = ".AspNet.ApplicationCookie=" + UserCookie.cookie;
    return http
        .post(
            Uri.parse("http://" +
                Address.address +
                "/CookingServerAuth/api/favorite/"),
            body: json.encode(idcontainer),
            encoding: Encoding.getByName('utf-8'),
            headers: getheaders)
        .then((http.Response response) {
      final int statusCode = response.statusCode;
      if (statusCode == 204) {
        return true;
      } else {
        return false;
      }
    });
  }

  Future<bool> removeFavorite(Idcontainer idcontainer) {
    Map<String, String> getheaders = {"content-type": "application/json"};
    getheaders["Cookie"] = ".AspNet.ApplicationCookie=" + UserCookie.cookie;
    return http
        .delete(
            Uri.parse("http://" +
                Address.address +
                "/CookingServerAuth/api/favorite/"),
            body: json.encode(idcontainer),
            encoding: Encoding.getByName('utf-8'),
            headers: getheaders)
        .then((http.Response response) {
      final int statusCode = response.statusCode;
      if (statusCode == 204) {
        return true;
      } else {
        return false;
      }
    });
  }

  Future<List<DBRecipe>> sync() async {
    Map<String, String> getheaders = {"content-type": "application/json"};
    getheaders["Cookie"] = ".AspNet.ApplicationCookie=" + UserCookie.cookie;
    await _dbRecipeProvider.open(await _dbRecipeProvider.getdbpath());
    print('db opened');
    Datecontainer datecontainer =
        Datecontainer(date: await _dbRecipeProvider.getversion());
    try {
      return http
          .post(
          Uri.parse(
              "http://" + Address.address + "/CookingServerAuth/api/sync/"),
          body: json.encode(datecontainer),
          encoding: Encoding.getByName('utf-8'),
          headers: getheaders)
          .timeout(
        const Duration(seconds: 4),
        onTimeout: () {
          return http.Response('Error', 100);
        },
      ).onError((error, stackTrace) => throw Exception("ffff")).then(
            (http.Response response) async {
          if (response.statusCode == 200) {
            print('recieved sync list');
            for (var recipe in recipeFromJson(response.body)) {
              print('iteration begin');
              DBRecipe dbRecipe = DBRecipe(
                  id: recipe.id,
                  title: recipe.title,
                  description: recipe.description,
                  date: recipe.date.toString());
              if (await _dbRecipeProvider.check(recipe.id)) {
                if (recipe.deleted) {
                  _dbRecipeProvider.delete(recipe.id);
                } else {
                  _dbRecipeProvider.update(dbRecipe);
                }
              } else if (!recipe.deleted) {
                _dbRecipeProvider.insert(dbRecipe);
              }
            }
            return await _dbRecipeProvider.fetchFromDB();
          }
          return await _dbRecipeProvider.fetchFromDB();
        },
      );
    }
    on Exception catch (e) {
      return _dbRecipeProvider.fetchFromDB();
    }
  }
}
