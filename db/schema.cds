namespace com.satinfotech.studentdb;
using { cuid, managed } from '@sap/cds/common';

@assert.unique.stdid: [stdid]
entity Student: cuid, managed {
    @title: 'Student ID'
    stdid: String(5);
    @title: 'Gender'
    gender: String(1);
    @title: 'First Name'
    first_name: String(40) @mandatory;
    @title: 'Last Name'
    last_name: String(40) @mandatory;
    @title: 'Email ID'
    email_id: String(100) @mandatory;
    @title: 'Date of Birth'
    dob: Date @mandatory;
    @title: 'PAN'
    pan_no: String(10) @mandatory;
    @title: 'Course'
    course: Association to Courses;
    @title: 'Languages Known'
    Languages: Composition of many {
        key ID: UUID;
        lang: Association to Languages;
    };
    @title: 'Age'
    virtual age: Integer @Core.Computed;
    @title: 'Is Alumini'
    is_alumni: Boolean default false;
}

entity StudentLanguages: managed, cuid {
    studentid: Association to Student;
    langid: Association to Languages;
}

@cds.persistence.skip
entity Gender {
    @title: 'code'
    key code: String(1);
    @title: 'Description'
    description: String(10);
}

entity Courses: cuid, managed {
    @title: 'Code'
    code: String(3);
    @title: 'Description'
    description: String(50);
    @title: 'Books'
    Books: Composition of many {
        key ID: UUID;
        books: Association to Books;
    };
}

entity Languages: cuid, managed {
    @title: 'Code'
    code: String(2);
    @title: 'Description'
    description: String(20);
}

entity Books: cuid, managed {
    @title: 'Code'
    code: String(5);
    @title: 'Description'
    description: String(200);
}
