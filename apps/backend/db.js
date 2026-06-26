const sqlite3 = require('sqlite3').verbose();
const path = require('path');
const bcrypt = require('bcryptjs');

const dbPath = path.resolve(__dirname, 'database.sqlite');

const db = new sqlite3.Database(dbPath, (err) => {
  if (err) {
    console.error('Error connecting to database', err);
  } else {
    console.log('Connected to SQLite database');
    db.run('PRAGMA foreign_keys = ON');
  }
});

// Initialize tables
db.serialize(() => {
  db.run(`
    CREATE TABLE IF NOT EXISTS users (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      username TEXT UNIQUE,
      password TEXT,
      name TEXT,
      avatarUrl TEXT,
      joinedDate TEXT,
      bio TEXT
    )
  `);

  db.run(`
    CREATE TABLE IF NOT EXISTS custom_lists (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      user_id INTEGER,
      list_name TEXT,
      FOREIGN KEY(user_id) REFERENCES users(id)
    )
  `);

  db.run(`
    CREATE TABLE IF NOT EXISTS tracking_items (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      list_id INTEGER,
      anime_id INTEGER,
      title TEXT,
      imageUrl TEXT,
      current_episode INTEGER,
      total_episodes INTEGER,
      FOREIGN KEY(list_id) REFERENCES custom_lists(id)
    )
  `);

  // Migration for existing db
  db.run(`ALTER TABLE tracking_items ADD COLUMN title TEXT;`, (err) => {});
  db.run(`ALTER TABLE tracking_items ADD COLUMN imageUrl TEXT;`, (err) => {});

  // Insert mock user if not exists
  db.get(`SELECT id FROM users WHERE id = 1`, (err, row) => {
    if (!row) {
      const salt = bcrypt.genSaltSync(10);
      const hashedPassword = bcrypt.hashSync('123456', salt);

      db.run(`
        INSERT INTO users (id, username, password, name, avatarUrl, joinedDate, bio)
        VALUES (
          1, 
          'anifan', 
          ?,
          'AniFan2026', 
          'https://i.pinimg.com/736x/21/df/b8/21dfb85e054457e5e34b9d038a8e3f94.jpg', 
          'March 2026', 
          'I love watching anime!'
        )
      `, [hashedPassword]);
      console.log('Mock user inserted with hashed password.');
    }
  });
});

module.exports = db;
