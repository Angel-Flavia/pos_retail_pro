import 'package:path/path.dart'; 
import 'package:sqflite/sqflite.dart'; 
 
class DatabaseHelper { 
  static final DatabaseHelper instance = DatabaseHelper._(); 
  DatabaseHelper._(); 
 
  static Database? _db; 
 
  Future<Database> get database async { 
    _db ??= await _initDb(); 
    return _db!; 
  } 
 
  Future<Database> _initDb() async { 
    final path = join(await getDatabasesPath(), 'pos_retail.db'); 
    return await openDatabase( 
      path, 
      version: 1, 
      onCreate: (db, version) async { 
        await db.execute(''' 
          CREATE TABLE products( 
            id INTEGER PRIMARY KEY AUTOINCREMENT, 
            name TEXT NOT NULL, 
            category TEXT NOT NULL, 
            price REAL NOT NULL, 
            stock INTEGER NOT NULL 
          ) 
        '''); 
        await db.execute(''' 
          CREATE TABLE sales( 
            id INTEGER PRIMARY KEY AUTOINCREMENT, 
            uuid TEXT NOT NULL, 
            total REAL NOT NULL, 
            tax REAL NOT NULL, 
            subtotal REAL NOT NULL, 
            paymentMethod TEXT NOT NULL, 
            items TEXT NOT NULL, 
            createdAt TEXT NOT NULL, 
            latitude REAL, 
            longitude REAL, 
            isSynced INTEGER DEFAULT 0 
          ) 
        '''); 
        await db.execute(''' 
          CREATE TABLE customers( 
            id INTEGER PRIMARY KEY AUTOINCREMENT, 
            name TEXT NOT NULL, 
            phone TEXT, 
            email TEXT, 
            createdAt TEXT NOT NULL 
          ) 
        '''); 
        final demo = [ 
          {'name': 'Coca Cola 500ml', 'category': 'Beverages', 'price': 2500.0, 'stock': 30}, 
          {'name': 'Sprite 500ml', 'category': 'Beverages', 'price': 2500.0, 'stock': 40}, 
          {'name': 'Water 500ml', 'category': 'Beverages', 'price': 1500.0, 'stock': 100}, 
          {'name': 'Bread', 'category': 'Groceries', 'price': 3000.0, 'stock': 30}, 
          {'name': 'Chips', 'category': 'Snacks', 'price': 2000.0, 'stock': 45}, 
          {'name': 'Milk 1L', 'category': 'Groceries', 'price': 4000.0, 'stock': 25}, 
        ]; 
        for (final p in demo) { 
          await db.insert('products', p); 
        } 
      }, 
    ); 
  } 
 
  Future<List<Map<String, dynamic>>> getProducts() async { 
    final db = await database; 
    return db.query('products', orderBy: 'name ASC'); 
  } 
 
  Future<int> insertProduct(Map<String, dynamic> p) async { 
    final db = await database; 
    return db.insert('products', p); 
  } 
 
  Future<int> updateProduct(int id, Map<String, dynamic> p) async { 
    final db = await database; 
    return db.update('products', p, where: 'id = ?', whereArgs: [id]); 
  } 
 
  Future<int> deleteProduct(int id) async { 
    final db = await database; 
    return db.delete('products', where: 'id = ?', whereArgs: [id]); 
  } 
 
  Future<void> decreaseStock(int id, int qty) async { 
    final db = await database; 
    await db.rawUpdate('UPDATE products SET stock = stock - ? WHERE id = ?', [qty, id]); 
  } 
 
  Future<int> insertSale(Map<String, dynamic> s) async { 
    final db = await database; 
    return db.insert('sales', s); 
  } 
 
  Future<List<Map<String, dynamic>>> getSales() async { 
    final db = await database; 
    return db.query('sales', orderBy: 'createdAt DESC'); 
  } 
 
  Future<double> getTodayTotal() async { 
    final db = await database; 
    final now = DateTime.now(); 
    final start = DateTime(now.year, now.month, now.day).toIso8601String(); 
    final r = await db.rawQuery('SELECT SUM(total) as total FROM sales WHERE createdAt >= ?', [start]); 
    return (r.first['total'] as num?)?.toDouble() ?? 0.0; 
  } 
 
  Future<List<Map<String, dynamic>>> getCustomers() async { 
    final db = await database; 
    return db.query('customers', orderBy: 'name ASC'); 
  } 
 
  Future<int> insertCustomer(Map<String, dynamic> c) async { 
    final db = await database; 
    return db.insert('customers', c); 
  } 
 
  Future<int> deleteCustomer(int id) async { 
    final db = await database; 
    return db.delete('customers', where: 'id = ?', whereArgs: [id]); 
  } 
}