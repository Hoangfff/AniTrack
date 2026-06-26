const express = require('express');
const cors = require('cors');
const db = require('./db');

const app = express();
const port = 3000;

app.use(cors());
app.use(express.json());

const bcrypt = require('bcryptjs');

// --- Auth Endpoints ---

// Register
app.post('/api/auth/register', (req, res) => {
  const { username, password } = req.body;
  if (!username || !password) {
    return res.status(400).json({ error: 'Username and password are required' });
  }

  // Check if user already exists
  db.get('SELECT id FROM users WHERE username = ?', [username], (err, row) => {
    if (err) return res.status(500).json({ error: err.message });
    if (row) return res.status(400).json({ error: 'Username already exists' });

    const salt = bcrypt.genSaltSync(10);
    const hashedPassword = bcrypt.hashSync(password, salt);
    const joinedDate = new Date().toLocaleDateString('en-US', { month: 'long', year: 'numeric' });

    db.run(
      'INSERT INTO users (username, password, name, avatarUrl, joinedDate, bio) VALUES (?, ?, ?, ?, ?, ?)',
      [username, hashedPassword, username, 'https://i.imgur.com/6VBx3io.png', joinedDate, 'Hello, I am new here!'],
      function(err) {
        if (err) return res.status(500).json({ error: err.message });
        res.json({ message: 'User registered successfully', userId: this.lastID });
      }
    );
  });
});

// Login
app.post('/api/auth/login', (req, res) => {
  const { username, password } = req.body;
  if (!username || !password) {
    return res.status(400).json({ error: 'Username and password are required' });
  }

  db.get('SELECT * FROM users WHERE username = ?', [username], (err, row) => {
    if (err) return res.status(500).json({ error: err.message });
    if (!row) return res.status(400).json({ error: 'User not found' });

    const isValidPassword = bcrypt.compareSync(password, row.password);
    if (!isValidPassword) {
      return res.status(400).json({ error: 'Invalid password' });
    }

    res.json({ message: 'Login successful', userId: row.id });
  });
});

// --- User Profile Endpoints ---

// Get User Profile
app.get('/api/profile/:id', (req, res) => {
  const userId = req.params.id;
  db.get('SELECT * FROM users WHERE id = ?', [userId], (err, row) => {
    if (err) {
      return res.status(500).json({ error: err.message });
    }
    if (!row) {
      return res.status(404).json({ error: 'User not found' });
    }
    res.json(row);
  });
});

// Get User Stats
app.get('/api/profile/:id/stats', (req, res) => {
  const userId = req.params.id;
  db.get(
    `SELECT 
      COUNT(DISTINCT tracking_items.anime_id) as animeCount,
      SUM(tracking_items.current_episode) as episodesCount
     FROM tracking_items 
     JOIN custom_lists ON tracking_items.list_id = custom_lists.id 
     WHERE custom_lists.user_id = ?`,
    [userId],
    (err, row) => {
      if (err) {
        return res.status(500).json({ error: err.message });
      }
      const animeCount = row.animeCount || 0;
      const episodesCount = row.episodesCount || 0;
      // Assume 1 episode = 24 minutes. Days = episodes * 24 / 60 / 24 = episodes / 60
      const daysCount = (episodesCount / 60).toFixed(1);
      res.json({ animeCount, episodesCount, daysCount: parseFloat(daysCount) });
    }
  );
});

// Update User Profile
app.put('/api/profile/:id', (req, res) => {
  const userId = req.params.id;
  const { name, bio, avatarUrl } = req.body;
  
  db.run(
    `UPDATE users SET name = COALESCE(?, name), bio = COALESCE(?, bio), avatarUrl = COALESCE(?, avatarUrl) WHERE id = ?`,
    [name, bio, avatarUrl, userId],
    function(err) {
      if (err) {
        return res.status(500).json({ error: err.message });
      }
      res.json({ message: 'Profile updated successfully', changes: this.changes });
    }
  );
});

// --- Tracking Lists Endpoints ---

// Get all lists for a user
app.get('/api/lists/:userId', (req, res) => {
  const userId = req.params.userId;
  db.all('SELECT * FROM custom_lists WHERE user_id = ?', [userId], (err, rows) => {
    if (err) {
      return res.status(500).json({ error: err.message });
    }
    res.json(rows);
  });
});

// Create a new list
app.post('/api/lists/:userId/create', (req, res) => {
  const userId = req.params.userId;
  const { list_name } = req.body;
  
  db.run('INSERT INTO custom_lists (user_id, list_name) VALUES (?, ?)', [userId, list_name], function(err) {
    if (err) {
      return res.status(500).json({ error: err.message });
    }
    res.json({ message: 'List created', id: this.lastID });
  });
});

// Get tracking items for a user and status
app.get('/api/tracking/:userId/:status', (req, res) => {
  const { userId, status } = req.params;
  
  db.all(
    `SELECT t.anime_id as animeId, t.title, t.imageUrl, t.current_episode as progress, t.total_episodes as totalEpisodes, c.list_name as status 
     FROM tracking_items t 
     JOIN custom_lists c ON t.list_id = c.id 
     WHERE c.user_id = ? AND c.list_name = ?`,
    [userId, status],
    (err, rows) => {
      if (err) return res.status(500).json({ error: err.message });
      res.json(rows);
    }
  );
});

// Sync tracking progress from local to backend
app.post('/api/tracking/progress', (req, res) => {
  const { userId, animeId, currentEpisode, totalEpisodes, status, title, imageUrl } = req.body;
  if (!userId || !animeId) {
    return res.status(400).json({ error: 'Missing userId or animeId' });
  }

  const listName = status || 'Watching';

  // 1. Ensure a list exists for the user
  db.get("SELECT id FROM custom_lists WHERE user_id = ? AND list_name = ?", [userId, listName], (err, listRow) => {
    if (err) return res.status(500).json({ error: err.message });
    
    if (listRow) {
       updateOrInsertTrackingItem(userId, listRow.id, animeId, currentEpisode || 0, totalEpisodes || 0, title, imageUrl, res);
    } else {
       db.run("INSERT INTO custom_lists (user_id, list_name) VALUES (?, ?)", [userId, listName], function(err) {
         if (err) return res.status(500).json({ error: err.message });
         updateOrInsertTrackingItem(userId, this.lastID, animeId, currentEpisode || 0, totalEpisodes || 0, title, imageUrl, res);
       });
    }
  });
});

function updateOrInsertTrackingItem(userId, listId, animeId, currentEpisode, totalEpisodes, title, imageUrl, res) {
  db.get("SELECT id, current_episode FROM tracking_items WHERE list_id = ? AND anime_id = ?", [listId, animeId], (err, row) => {
    if (err) return res.status(500).json({ error: err.message });
    
    const newEpisode = Math.max(row ? (row.current_episode || 0) : 0, currentEpisode);
    
    const finishUpsert = () => {
      // Sync progress across all lists for this user
      db.run(`
        UPDATE tracking_items 
        SET current_episode = MAX(current_episode, ?), 
            total_episodes = CASE WHEN ? > 0 THEN ? ELSE total_episodes END
        WHERE anime_id = ? AND list_id IN (SELECT id FROM custom_lists WHERE user_id = ?)
      `, [newEpisode, totalEpisodes, totalEpisodes, animeId, userId], function(err) {
        if (err) return res.status(500).json({ error: err.message });
        
        checkAndMoveToCompleted(userId, animeId, res, listId);
      });
    };

    if (row) {
      // Update specific list item first
      db.run("UPDATE tracking_items SET current_episode = ?, total_episodes = CASE WHEN ? > 0 THEN ? ELSE total_episodes END, title = COALESCE(?, title), imageUrl = COALESCE(?, imageUrl) WHERE id = ?", 
        [newEpisode, totalEpisodes, totalEpisodes, title, imageUrl, row.id], function(err) {
          if (err) return res.status(500).json({ error: err.message });
          finishUpsert();
        });
    } else {
      // Insert specific list item first
      db.run("INSERT INTO tracking_items (list_id, anime_id, title, imageUrl, current_episode, total_episodes) VALUES (?, ?, ?, ?, ?, ?)",
        [listId, animeId, title, imageUrl, currentEpisode, totalEpisodes], function(err) {
          if (err) return res.status(500).json({ error: err.message });
          finishUpsert();
        });
    }
  });
}

function checkAndMoveToCompleted(userId, animeId, res, originalListId) {
  // Check if this anime is completed
  db.get(`
    SELECT current_episode, total_episodes, title, imageUrl
    FROM tracking_items 
    WHERE anime_id = ? AND list_id IN (SELECT id FROM custom_lists WHERE user_id = ?)
    LIMIT 1
  `, [animeId, userId], (err, row) => {
    if (err) return res.status(500).json({ error: err.message });
    
    if (row && row.total_episodes > 0 && row.current_episode >= row.total_episodes) {
      // Ensure 'Completed' list exists
      db.get("SELECT id FROM custom_lists WHERE user_id = ? AND list_name = 'Completed'", [userId], (err, completedListRow) => {
        if (err) return res.status(500).json({ error: err.message });
        
        const moveToCompleted = (completedListId) => {
          // Find 'Watching' list
          db.get("SELECT id FROM custom_lists WHERE user_id = ? AND list_name = 'Watching'", [userId], (err, watchingListRow) => {
             if (watchingListRow) {
                // Delete from 'Watching'
                db.run("DELETE FROM tracking_items WHERE list_id = ? AND anime_id = ?", [watchingListRow.id, animeId]);
             }
             
             // Ensure it exists in 'Completed'
             db.get("SELECT id FROM tracking_items WHERE list_id = ? AND anime_id = ?", [completedListId, animeId], (err, existingCompleted) => {
               if (!existingCompleted) {
                 db.run("INSERT INTO tracking_items (list_id, anime_id, title, imageUrl, current_episode, total_episodes) VALUES (?, ?, ?, ?, ?, ?)",
                  [completedListId, animeId, row.title, row.imageUrl, row.current_episode, row.total_episodes]);
               }
               res.json({ success: true, listId: originalListId });
             });
          });
        };

        if (completedListRow) {
           moveToCompleted(completedListRow.id);
        } else {
           db.run("INSERT INTO custom_lists (user_id, list_name) VALUES (?, 'Completed')", [userId], function(err) {
             if (err) return res.status(500).json({ error: err.message });
             moveToCompleted(this.lastID);
           });
        }
      });
    } else {
      res.json({ success: true, listId: originalListId });
    }
  });
}

app.listen(port, () => {
  console.log(`Backend server running at http://localhost:${port}`);
});

// Delete a specific anime from a tracking list
app.delete('/api/tracking/:userId/:status/:animeId', (req, res) => {
  const { userId, status, animeId } = req.params;
  
  db.get("SELECT id FROM custom_lists WHERE user_id = ? AND list_name = ?", [userId, status], (err, listRow) => {
    if (err) return res.status(500).json({ error: err.message });
    if (!listRow) return res.status(404).json({ error: 'List not found' });
    
    db.run("DELETE FROM tracking_items WHERE list_id = ? AND anime_id = ?", [listRow.id, animeId], function(err) {
      if (err) return res.status(500).json({ error: err.message });
      res.json({ success: true, message: 'Anime removed from list' });
    });
  });
});

// Delete an entire custom list
app.delete('/api/lists/:userId/:listName', (req, res) => {
  const { userId, listName } = req.params;
  
  db.get("SELECT id FROM custom_lists WHERE user_id = ? AND list_name = ?", [userId, listName], (err, listRow) => {
    if (err) return res.status(500).json({ error: err.message });
    if (!listRow) return res.status(404).json({ error: 'List not found' });
    
    // Delete all tracking items inside this list first (since we don't have ON DELETE CASCADE)
    db.run("DELETE FROM tracking_items WHERE list_id = ?", [listRow.id], function(err) {
      if (err) return res.status(500).json({ error: err.message });
      
      // Now delete the list
      db.run("DELETE FROM custom_lists WHERE id = ?", [listRow.id], function(err) {
        if (err) return res.status(500).json({ error: err.message });
        res.json({ success: true, message: 'List deleted' });
      });
    });
  });
});
