import 'dart:convert';
import 'package:cooking/models/recipe.dart';
import 'package:cooking/network/address.dart';
import 'package:cooking/network/cookie.dart';
import 'package:http/http.dart' as http;

import '../models/addrecipe.dart';
import '../models/viewrecipe.dart';
class RecipesNetworkService {
  Map<String, String> headers = {"content-type": "application/x-www-form-urlencoded"};
  String? recipes = "";

  Future<List<Recipe>> getAllRecipes() {
    Map<String, String> getheaders = {"content-type": "application/x-www-form-urlencoded"};
    getheaders["Cookie"] = ".AspNet.ApplicationCookie="+UserCookie.cookie;
    return http.get(Uri.parse("http://"+Address.address+"/CookingServerAuth/api/recipes/"), headers: getheaders).then((http.Response response) {
      final int statusCode = response.statusCode;

      if (statusCode == 200 ) {
        return recipeFromJson(response.body);
      }
      else{
        return List<Recipe>.empty();
      }
    });
  }

  Future<List<Viewrecipe>> getFavorite() {
    Map<String, String> getheaders = {"content-type": "application/x-www-form-urlencoded"};
    getheaders["Cookie"] = ".AspNet.ApplicationCookie="+UserCookie.cookie;
    return http.get(Uri.parse("http://"+Address.address+"/CookingServerAuth/api/favorite/"), headers: getheaders).then((http.Response response) {
      final int statusCode = response.statusCode;

      if (statusCode == 200 ) {
        return viewrecipeFromJson(response.body);
      }
      else{
        return List<Viewrecipe>.empty();
      }
    });
  }

  Future<bool> addRecipe(Addrecipe recipe) {
    Map<String, String> getheaders = {};
    getheaders["Cookie"] = ".AspNet.ApplicationCookie="+UserCookie.cookie;
    return http.post(Uri.parse("http://"+Address.address+"/CookingServerAuth/api/recipes/"), body: recipe.toJson(), encoding: Encoding.getByName('utf-8'), headers: getheaders).then((http.Response response) {
      final int statusCode = response.statusCode;
      if (statusCode == 200 ) {
        return true;
      }
      else{
        return false;
      }
    });
  }
}