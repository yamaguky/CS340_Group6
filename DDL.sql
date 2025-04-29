create table Students(
	studentID int auto_increment not null unique,
	firstName  varchar(45) not null,
    lastName varchar(45) not null,
    email 	varchar(145) not null,
	major varchar(45) null,
    primary key(studentID)
);

create table Instructors (
    instructorID int auto_increment not null unique,
    firstName varchar(45) not null,
    lastName VARCHAR(45) not null,
    email 	varchar(145) not null,
    primary key(instructorID)
);

create table Grades (
	gradeID int auto_increment not null unique,
    letterGrade varchar(3) not null,
    gradePoint float not null,
    primary key (gradeID)
);

create table Courses (
    courseID int auto_increment not null unique,
    courseName varchar(45) not null,
    courseCode varchar(45) not null,
    credit int not null, 
    instructorID int not null,
    
    constraint fk_Courses_instructorID
        foreign key (instructorID) references Instructors(instructorID),
        
	primary key (courseID)
);


create table Students_Courses (
    enrollmentID int auto_increment not null unique,
    studentID int not null,
    courseID int not null,
    gradeID int not null,

    constraint fk_Students_Courses_studentID
        foreign key (studentID) references Students(studentID),

    constraint fk_Students_Courses_courseID
        foreign key (courseID) references Courses(courseID),
        
	constraint fk_Students_Courses_gradeID
        foreign key (gradeID) references Grades(gradeID),
        
	primary key (enrollmentID)

);
