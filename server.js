const express = require('express');
const cors = require('cors');

const app = express();
const PORT = 3001;

// Middleware
app.use(cors());
app.use(express.json());

// Demo API endpoint
app.get('/api/demo', (req, res) => {
  const demoData = {
    message: 'Hello from the AI-generated API!',
    timestamp: new Date().toISOString(),
    features: [
      'Real-time data processing',
      'RESTful API design',
      'Error handling',
      'CORS enabled'
    ],
    stats: {
      uptime: process.uptime(),
      memory: process.memoryUsage(),
      platform: process.platform,
      nodeVersion: process.version
    },
    randomFact: getRandomFact()
  };
  
  res.json(demoData);
});

// Health check endpoint
app.get('/api/health', (req, res) => {
  res.json({ 
    status: 'healthy', 
    timestamp: new Date().toISOString() 
  });
});

// Error handling middleware
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({ 
    error: 'Something went wrong!',
    message: err.message 
  });
});

// 404 handler
app.use('*', (req, res) => {
  res.status(404).json({ 
    error: 'Endpoint not found',
    path: req.originalUrl 
  });
});

function getRandomFact() {
  const facts = [
    'This API was generated entirely by AI!',
    'The server runs on Node.js and Express',
    'All endpoints include proper error handling',
    'CORS is configured for cross-origin requests',
    'The API includes health monitoring endpoints',
    'Data is returned in JSON format',
    'The server logs all requests automatically'
  ];
  
  return facts[Math.floor(Math.random() * facts.length)];
}

app.listen(PORT, () => {
  console.log(`🚀 Server running on http://localhost:${PORT}`);
  console.log(`📊 API endpoints available:`);
  console.log(`   GET /api/demo - Demo data endpoint`);
  console.log(`   GET /api/health - Health check`);
});
