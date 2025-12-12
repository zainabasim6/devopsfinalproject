const express = require('express');
const mysql = require('mysql2');
const app = express();
const port = 3000;

// MySQL connection
const connection = mysql.createConnection({
  host: process.env.DB_HOST || 'localhost',
  user: process.env.DB_USER || 'root',
  password: process.env.DB_PASSWORD || 'password',
  database: process.env.DB_NAME || 'testdb'
});

connection.connect();

// Create table if not exists
connection.query(`
  CREATE TABLE IF NOT EXISTS visitors (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255),
    visit_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
  )
`);

app.get('/', (req, res) => {
  // Insert visitor
  connection.query('INSERT INTO visitors (name) VALUES (?)', ['User'], (err) => {
    if (err) throw err;
    
    // Get count
    connection.query('SELECT COUNT(*) as count FROM visitors', (err, results) => {
      if (err) throw err;
      res.send(`<h1>Welcome to DevOps Lab Project!</h1>
                <p>Total visitors: ${results[0].count}</p>
                <p>App is running in a Docker container on Kubernetes!</p>`);
    });
  });
});

app.get('/health', (req, res) => {
  res.json({ status: 'healthy', timestamp: new Date() });
});

app.listen(port, () => {
  console.log(`App running on port ${port}`);
});
