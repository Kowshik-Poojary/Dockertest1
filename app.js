// Load environment variables
require('dotenv').config();

const express = require('express');
const connectDB = require('./config/db');
const studentRoutes = require('./routes/studentRoutes');

// Initialize Express app
const app = express();

// Middleware - Parse JSON request bodies
app.use(express.json());

// Connect to MongoDB
connectDB();

// Health check endpoint
app.get('/health', (req, res) => {
  res.status(200).json({
    status: 'healthy',
    environment: process.env.APP_ENV || 'development',
    timestamp: new Date().toISOString()
  });
});

// Student routes
app.use('/student', studentRoutes);

// Handle undefined routes
app.use('*', (req, res) => {
  res.status(404).json({
    success: false,
    message: 'Route not found',
    availableRoutes: {
      health: 'GET /health',
      registerStudent: 'POST /student'
    }
  });
});

// Start server
const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
  console.log('\n🚀 CampusFit Application Started');
  console.log(`📍 Server running on port ${PORT}`);
  console.log(`🌍 Environment: ${process.env.APP_ENV || 'development'}`);
  console.log(`\n💡 Available endpoints:`);
  console.log(`   GET  http://localhost:${PORT}/health`);
  console.log(`   POST http://localhost:${PORT}/student`);
  console.log('\n✨ Application is ready to accept requests\n');
});
