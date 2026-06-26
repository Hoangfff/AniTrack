const sqlite3 = require('sqlite3').verbose();
const db = new sqlite3.Database('database.sqlite');
db.run("DELETE FROM users WHERE username = 'test'", function(err) {
  if (err) console.error(err);
  else console.log('Deleted test user: ' + this.changes);
});
