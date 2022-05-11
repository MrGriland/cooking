import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

const String tableDBRecipe = 'DBRecipe';
const String columnId = '_id';
const String columnTitle = 'title';
const String columnDescription = 'description';
const String columnDate = 'date';

class DBRecipe {

  DBRecipe({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
  });

  int id;
  String title;
  String description;
  String date;

  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      columnTitle: title,
      columnDescription: description,
      columnDate: date
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  factory DBRecipe.fromMap(Map<dynamic, dynamic> map) => DBRecipe(
      id: int.parse(map[columnId].toString()),
      title: map[columnTitle].toString(),
      description: map[columnDescription].toString(),
      date: map[columnDate].toString()
  );
}

class DBRecipeProvider {
  late Database db;

  Future<String> getdbpath() async {
    return join(await getDatabasesPath(), 'cooking.db');
  }

  Future open(String path) async {
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          await db.execute('''
create table $tableDBRecipe ( 
  $columnId integer primary key, 
  $columnTitle text not null,
  $columnDescription text not null,
  $columnDate text not null)
''');
        });
  }

  Future<bool> check(int id) async {
    int? count = Sqflite.firstIntValue(await db.rawQuery("select COUNT(*) from $tableDBRecipe where $columnId = $id"));
    if(count != null && count > 0){
      return true;
    }
    return false;
  }

  Future<List<DBRecipe>> fetchFromDB() async {
    List<Map> recipes = await db.rawQuery("select * from $tableDBRecipe");
    return recipes.isNotEmpty ? recipes.toList().map((c) => DBRecipe.fromMap(c)).toList() : [];
  }

  Future<String> getversion() async {
    print("before version get");
    List<Map> version = await db.rawQuery("select * from $tableDBRecipe order by $columnDate desc LIMIT 1");
    print("version get");
    return version.isNotEmpty ? version.toList().map((c) => DBRecipe.fromMap(c)).toList().first.date : "1970-01-01 00:00:00.000";
  }

  Future<DBRecipe> insert(DBRecipe recipe) async {
    recipe.id = await db.rawInsert("INSERT Into $tableDBRecipe ($columnId,$columnTitle,$columnDescription,$columnDate) VALUES (?,?,?,?)", [recipe.id, recipe.title, recipe.description, recipe.date] );
    return recipe;
  }

  Future<int> update(DBRecipe recipe) async {
    return await db.rawUpdate("UPDATE $tableDBRecipe Set $columnTitle=?, $columnDescription=?, $columnDate=? where $columnId=?", [recipe.title, recipe.description, recipe.date, recipe.id]);
    /*update(tableDBRecipe, recipe.toMap(),
        where: '$columnId = ?', whereArgs: [recipe.id]);*/
  }

  Future<int> delete(int id) async {
    return await db.rawDelete("DELETE FROM $tableDBRecipe WHERE $columnId = ?", [id]);
    /*delete(tableDBRecipe, where: '$columnId = ?', whereArgs: [id]);*/
  }

  Future close() async => db.close();
}