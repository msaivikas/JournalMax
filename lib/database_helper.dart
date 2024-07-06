import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;

  final String tableFullJournal = "fullJournal";
  final String columnUserId = "userId";
  final String columnTextContent = "textContent";
  final String columnDate = "date";
  final String columnTimeStamp = "timeStamp";

  final String tableActionItems = "actionItems";
  final String columnAIActionableItems = "ai_actionable_items";

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    var databasesPath = await getDatabasesPath();
    String path = p.join(databasesPath, 'journal.db');

    return await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
          CREATE TABLE $tableFullJournal (
          $columnUserId TEXT NOT NULL,
          $columnTextContent TEXT NOT NULL,
          $columnDate TEXT NOT NULL,
          $columnTimeStamp TEXT NOT NULL
        )
        ''');

      await db.execute('''
        CREATE TABLE $tableActionItems (
          $columnUserId TEXT NOT NULL,
          $columnAIActionableItems TEXT NOT NULL,
          $columnDate TEXT NOT NULL
        )
      ''');
    });
  }

  Future<int> insertJournal(String userEmail, String textContent, String date,
      String timeStamp) async {
    Database db = await database;
    Map<String, dynamic> row = {
      columnUserId: userEmail,
      columnTextContent: textContent,
      columnDate: date,
      columnTimeStamp: timeStamp,
    };
    return await db.insert(tableFullJournal, row);
  }

  Future<List<Map<String, dynamic>>> getTodaysJournal(
      String userEmail, String? date) async {
    Database db = await database;

    return db.query(tableFullJournal,
        where: '$columnUserId=? AND $columnDate=?',
        whereArgs: [userEmail, date],
        orderBy: '$columnTimeStamp DESC');
  }

  Future<int> insertActionItem(
      String userEmail, String textContent, String date) async {
    Database db = await database;
    Map<String, dynamic> row = {
      columnUserId: userEmail,
      columnAIActionableItems: textContent,
      columnDate: date,
    };
    return db.insert(tableActionItems, row);
  }

  Future<String?> getActionItem(String userEmail, String date) async {
    Database db = await database;
    List<Map<String, dynamic>> result = await db.query(
      tableActionItems,
      where: '$columnUserId = ? AND $columnDate = ?',
      whereArgs: [userEmail, date],
    );
    if (result.isNotEmpty) {
      return result.first[columnAIActionableItems] as String?;
    }

    return null;
  }

  Future<List<Map<String, dynamic>>> getTodaysActionItems(
      String userEmail, String date) async {
    Database db = await database;
    return await db.query(tableActionItems,
        where: '$columnUserId = ? AND $columnDate = ?',
        whereArgs: [userEmail, date]);
  }

  Future<int> deleteJournalItem(String userEmail, String timeStamp) async {
    Database db = await database;
    return db.delete(
      tableFullJournal,
      where: '$columnUserId = ? AND $columnTimeStamp = ?',
      whereArgs: [userEmail, timeStamp],
    );
  }

  Future<int> editJournalItem(
      String userEmail, String timeStamp, String newTextContent) async {
    Database db = await database;
    return db.update(tableFullJournal, {columnTextContent: newTextContent},
        where: '$columnUserId = ? AND $columnTimeStamp = ?',
        whereArgs: [userEmail, newTextContent]);
  }

  Future<int> deleteAllUserJournals(String userEmail) async {
    Database db = await database;
    return db.delete(
      tableFullJournal,
      where: '$columnUserId = ?',
      whereArgs: [userEmail],
    );
  }

  Future<int> deleteAllActionItems(String userEmail) async {
    Database db = await database;
    return db.delete(
      tableActionItems,
      where: '$columnUserId = ?',
      whereArgs: [userEmail],
    );
  }
}
