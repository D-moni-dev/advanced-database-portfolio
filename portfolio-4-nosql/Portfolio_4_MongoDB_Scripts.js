
use("university_result_db");

// 1. Display all student records
db.student_records.find({});

// 2. Find Computer Science students
db.student_records.find({
  department: "Computer Science"
});

// 3. Find students registered for MIT8103
db.student_records.find({
  "courses.courseCode": "MIT8103"
});

// 4. Find students with an MIT8103 score of at least 80
db.student_records.find({
  courses: {
    $elemMatch: {
      courseCode: "MIT8103",
      score: { $gte: 80 }
    }
  }
});

// 5. Count all student records
db.student_records.countDocuments({});

// 6. Display student names and departments
db.student_records.find(
  {},
  { _id: 0, name: 1, department: 1 }
);
