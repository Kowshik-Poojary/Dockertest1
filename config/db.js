const mongoose = require('mongoose');

const connectDB = async () => {
  try {
    const mongoURI = process.env.MONGO_URI;

    if (!mongoURI) {
      console.error('❌ ERROR: MONGO_URI is not defined in environment variables');
      console.error('Please create a .env file based on .env.example');
      process.exit(1);
    }

    console.log('🔄 Connecting to MongoDB...');

    await mongoose.connect(mongoURI);

    console.log('✅ MongoDB connected successfully');
    console.log(`📦 Database: ${mongoose.connection.name}`);

  } catch (error) {
    console.error('❌ MongoDB connection failed:', error.message);
    console.error('\nTroubleshooting tips:');
    console.error('1. Ensure MongoDB is running on your system');
    console.error('2. Verify MONGO_URI in your .env file');
    console.error('3. Check MongoDB credentials and database name');
    process.exit(1);
  }
};

module.exports = connectDB;
