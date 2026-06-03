const mongoose = require('mongoose');

const studentSchema = new mongoose.Schema(
  {
    name: {
      type: String,
      required: [true, 'Student name is required'],
      trim: true,
      minlength: [2, 'Name must be at least 2 characters long'],
      maxlength: [100, 'Name cannot exceed 100 characters']
    },
    membership: {
      type: String,
      required: [true, 'Membership type is required'],
      enum: {
        values: ['Basic', 'Premium', 'Elite'],
        message: 'Membership must be either Basic, Premium, or Elite'
      }
    }
  },
  {
    timestamps: true
  }
);

const Student = mongoose.model('Student', studentSchema);

module.exports = Student;
