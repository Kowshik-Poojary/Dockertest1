const Student = require('../models/Student');

const registerStudent = async (req, res) => {
  try {
    const { name, membership } = req.body;

    // Validate required fields
    if (!name || !membership) {
      return res.status(400).json({
        success: false,
        message: 'Missing required fields',
        required: ['name', 'membership']
      });
    }

    // Create new student
    const student = new Student({
      name,
      membership
    });

    // Save to database
    await student.save();

    // Return success response
    return res.status(201).json({
      success: true,
      message: 'Student registered successfully',
      data: {
        id: student._id,
        name: student.name,
        membership: student.membership,
        registeredAt: student.createdAt
      }
    });

  } catch (error) {
    console.error('Error registering student:', error);

    // Handle validation errors
    if (error.name === 'ValidationError') {
      return res.status(400).json({
        success: false,
        message: 'Validation failed',
        errors: Object.values(error.errors).map(err => err.message)
      });
    }

    // Handle other errors
    return res.status(500).json({
      success: false,
      message: 'Internal server error',
      error: error.message
    });
  }
};

module.exports = {
  registerStudent
};
