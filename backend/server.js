const express = require('express');
const mysql = require('mysql2/promise');
const redis = require('redis');
const os = require('os');

const app = express();
const port = process.env.PORT || 5000;

const redisClient = redis.createClient({
  socket: {
    host: process.env.REDIS_HOST || 'localhost',
    port: 6379
  }
});

redisClient.on('error', err => console.error('Redis error:', err));
redisClient.connect();

app.get('/api/test-react-nginx', (req, res) => {
  res.json({ message: 'React/Nginx is working!', host: os.hostname() });
});

app.get('/api/test-load-balancer', (req, res) => {
  res.json({ message: 'Load Balancer reached this backend!', host: os.hostname() });
});

app.get('/api/test-express', (req, res) => {
  res.json({ message: 'Express server is running!', host: os.hostname() });
});

app.get('/api/test-db', async (req, res) => {
  try {
    const connection = await mysql.createConnection({
      host: process.env.MYSQL_HOST || 'localhost',
      user: process.env.MYSQL_USER || 'root',
      password: process.env.MYSQL_PASSWORD || 'password',
      database: process.env.MYSQL_DB || 'test_db',
      port: process.env.MYSQL_PORT || '3306',

    });

    const [rows] = await connection.execute('SELECT NOW() AS now');
    await connection.end();

    res.json({ message: 'MySQL connected', now: rows[0].now });
  } catch (err) {
    res.status(500).json({ error: 'MySQL connection failed', details: err.message });
  }
});

app.get('/api/test-redis', async (req, res) => {
  try {
    await redisClient.set('healthcheck', 'ok');
    const value = await redisClient.get('healthcheck');
    res.json({ message: 'Redis connected', value });
  } catch (err) {
    res.status(500).json({ error: 'Redis connection failed', details: err.message });
  }
});

app.listen(port, () => {
  console.log(`API server listening at http://localhost:${port}`);
});
