init <- function() {
  library(Rcpp)
  library(openxlsx)
  library(plyr)
}

load.data <- function() {
  survey <<- read.xlsx("../data/master.xlsx", sheet=1)
  all.coded <<- read.xlsx("../data/all-coded.xlsx", sheet=1)
}

prep.data <- function() {
  # Drop unwanted colums
  survey <<- subset(survey, select = c(Doctype, ProgExp, DesignCourse, JetUML, ProgLang, GenExp, UMLExp, English))
  
  # Doctype: Convert to factors
  survey$Doctype <<- as.factor(survey$Doctype)
  
  # ProgExp: Convert to factors and rename
  survey$ProgExp <<- as.factor(survey$ProgExp)
  survey$ProgExp <<- revalue(survey$ProgExp, c("1-2 years"="low", 
                                 "3-5 years"="low",
                                 "More than 5 years"="High"))
  
  # DesignCourse: convert to factors
  survey$DesignCourse <<- as.factor(survey$DesignCourse)
  
  # JetUML: convert to factors, remap, and rename
  survey$JetUML <<- as.factor(survey$JetUML)
  survey$JetUML <<- revalue(survey$JetUML, c("Heard of it but never used it. Used ArgoUML instead"="No", 
                                             "I have looked at JetUML source code and/or documentation before this"="Yes",
                                             "I have never heard of JetUML"="No",
                                             "I have used JetUML frequently, I have looked at JetUML source code and/or documentation before this"="Yes",
                                             "I have used JetUML frequently, I have looked at JetUML source code and/or documentation before this, I have studied JetUML as part of a course."="Yes",
                                             "I have used JetUML once or twice"="No",
                                             "I have used JetUML once or twice, I have looked at JetUML source code and/or documentation before this"="Yes",
                                             "I only used it as part of a class (COMP 529)"="Yes",
                                             "I'v heard of JetUML"="No"))
  
  # ProgLang: convert to factor, only look if they know Java
  survey$ProgLang <<- as.factor(survey$ProgLang)
  survey$ProgLang <<- revalue(survey$ProgLang, c("C/C++, Java"="Yes",
                                                  "C/C++, Java, C#, Javascript"="Yes",
                                                  "C/C++, Java, Javascript, Swift, Bash"="Yes",
                                                  "C/C++, Java, Python"="Yes",
                                                  "C/C++, Java, Python, C#"="Yes",
                                                  "C/C++, Java, Python, C#, Javascript"="Yes",
                                                  "C/C++, Java, Python, C#, Javascript, Scala, PHP"="Yes",
                                                  "C/C++, Java, Python, C#, Javascript, SML, Ruby"="Yes",
                                                  "C/C++, Java, Python, Javascript"="Yes",
                                                  "C/C++, Java, Python, Javascript, Kotlin, Haskell, TypeScript, Elm"="Yes",
                                                  "C/C++, Java, Python, Javascript, Ruby"="Yes",
                                                  "C/C++, Python"="No",
                                                  "C/C++, Python, Javascript"="No",
                                                  "Java"="Yes",
                                                  "Java, C#"="Yes",
                                                  "Java, Javascript"="Yes",
                                                  "Java, Python"="Yes",
                                                  "Java, Python, C#"="Yes",
                                                  "Java, Python, C#, Javascript"="Yes",
                                                  "Java, Python, Javascript"="Yes",
                                                  "Python, C#"="No",
                                                  "Python, Javascript"="No"))

  # GenExp: convert to factor, collapse to two
  survey$GenExp <<- as.factor(survey$GenExp)
  survey$GenExp <<- revalue(survey$GenExp, c("I worked, or I am working, as a software developer, outside of co-op or internships."="Yes",
                                             "I have taken several undergraduate courses in software engineering."="No",
                                             "I have taken several undergraduate courses in software engineering., I have done software engineering as an intern or co-op student., I worked, or I am working, as a software developer, outside of co-op or internships."="Yes",
                                             "I have taken several undergraduate courses in software engineering., I worked, or I am working, as a software developer, outside of co-op or internships."="Yes",
                                             "I have taken several undergraduate courses in software engineering., I have done software engineering as an intern or co-op student."="Yes",
                                             "I have done software engineering as an intern or co-op student."="Yes"))
  
  # UMLExp: convert to factor, collapse to two
  survey$UMLExp <<- as.factor(survey$UMLExp)
  survey$UMLExp <<- revalue(survey$UMLExp, c("I have never used UML."="No",
                                             "I have used UML in course work."="Yes",
                                             "I have used UML in course work., I have read UML diagrams in industry., I have created UML diagrams in industry."="Yes",
                                             "I have used UML in course work., I have read UML diagrams in industry."="Yes",
                                             "I have created UML diagrams in industry."="Yes"))

  # English: Convert to factors
  survey$English <<- as.factor(survey$English)
  
  # Q2: Add from coded
  survey$Q2 <<- all.coded$Q2Code
  
  # Q3: Add from coded
  survey$Q3 <<- all.coded$Q3Code
  
  # Q4: Add from coded
  survey$Q4 <<- all.coded$Q3Code
}

factorize <- function() {
  # change responses to factors from numeric 
  survey$Q2 <<- factor(survey$Q2, ordered = TRUE, levels = c(0,1,2,3) )
  survey$Q2 <- ordered(survey$Q2)
  # Q3: Add from coded
  survey$Q3 <<- factor(survey$Q3, ordered = TRUE, levels = c(0,1,2,3) )
  survey$Q3 <- ordered(survey$Q3)
  # Q4: Add from coded
  survey$Q4 <<- factor(survey$Q4, ordered = TRUE, levels = c(0,1,2,3) )
  survey$Q4 <- ordered(survey$Q4)
}

