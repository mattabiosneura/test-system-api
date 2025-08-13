%dw 2.0
output application/json
---
payload.students reduce (student, acc = {}) -> 
  acc ++ {
    (student.id as String): {
      name: student.name,
      mathScore: (student.subjects filter ($.name == "Math"))[0].score,
      scienceScore: (student.subjects filter ($.name == "Science"))[0].score
    }
  }
