%dw 2.0
output application/json
---
payload.students reduce (student, acc = {}) -> 
  acc ++ {
    (student.id as String): {
      name: student.name
    } ++ (student.subjects reduce (subject, subjectAcc = {}) ->
      subjectAcc ++ {
        ((subject.name lower) ++ "Score"): subject.score
      }
    )
  }
