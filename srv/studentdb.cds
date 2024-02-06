using { com.satinfotech.studentdb as db} from '../db/schema';

service StudentDB {
    entity Student as projection on db.Student;
    entity Student.Languages as projection on db.Student.Languages;
    entity Gender as projection on db.Gender;
    entity Courses.Books as projection on db.Courses.Books;
    entity Books as projection on db.Books;
    entity Languages as projection on db.Languages {
        @UI.Hidden
        ID,
        *
    };
    entity Courses as projection on db.Courses {
        @UI.Hidden: true
        ID,
        *
    };
}

annotate StudentDB.Student with @odata.draft.enabled;
annotate StudentDB.Courses with @odata.draft.enabled;
annotate StudentDB.Languages with @odata.draft.enabled;


annotate StudentDB.Student with {
    first_name @assert.format: '^[a-zA-Z]{2,}$';
    last_name @assert.format: '^[a-zA-Z]{2,}$';    
    email_id @assert.format: '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    pan_no @assert.format: '^[A-Z]{5}[0-9]{4}[A-Z]{1}';
}

annotate StudentDB.Student.Languages with @(
    UI.LineItem: [
        {
            Label: 'Languages',
            Value: lang_ID
        },
    ]
);

annotate StudentDB.Courses.Books with @(
    UI.LineItem: [
        {
            Label: 'Books',
            Value: books_ID
        },
    ]
);

annotate StudentDB.Languages with @(
    UI.LineItem: [
        {
            Value: code
        },
        {
            Value: description
        }
    ],
    UI.FieldGroup #Languages: {
        $Type: 'UI.FieldGroupType',
        Data: [
            {
                Value: code,
            },
            {
                Value: description,
            }
        ],
    },
    UI.Facets: [
        {
            $Type: 'UI.ReferenceFacet',
            ID: 'LanguagesFacet',
            Label: 'Languages',
            Target: '@UI.FieldGroup#Languages',
        },
    ],
);

annotate StudentDB.Courses with @(
    UI.LineItem: [
        {
            Value: code
        },
        {
            Value: description
        },
        {
            Label: 'Books',
            Value: Books.books.description
        },
    ],
    UI.FieldGroup #CourseInformation: {
        $Type: 'UI.FieldGroupType',
        Data: [
            {
                Value: code,
            },
            {
                Value: description,
            },
            {
                Value: books,
            },
        ],
    },
    UI.Facets: [
        {
            $Type: 'UI.ReferenceFacet',
            ID: 'CourseInformationFacet',
            Label: 'Course Information',
            Target: '@UI.FieldGroup#CourseInformation',
        },
        {
            $Type: 'UI.ReferenceFacet',
            ID: 'CourseBooksFacet',
            Label: 'Books Information',
            Target: 'Books/@UI.LineItem',
        },
    ],
);

annotate StudentDB.Gender with @(
    UI.LineItem: [
        {
            @Type: 'UI.DataField',
            Value: code
        },
        {
            @Type: 'UI.DataField',
            Value: description
        },
    ]
);

annotate StudentDB.Books with @(
    UI.LineItem:[
        {
            @Type: 'UI.DataField',
            Value: code
        },
        {
            @Type: 'UI.DataField',
            Value: description
        },
    ],
    UI.FieldGroup #Books : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                Value : code,
            },
            {
                Value : description,
            },
        ],
    },
    UI.Facets : [
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'BooksFacet',
            Label : 'Books',
            Target : '@UI.FieldGroup#Books',
        },
    ],
);

annotate StudentDB.Courses.Books with {
    books @(
        Common.Text: books.description,
        Common.TextArrangement: #TextOnly,
        Common.ValueListWithFixedValues: true,
        Common.ValueList: {
            Label: 'Books',
            CollectionPath: 'Books',
            Parameters: [   
                {
                    $Type: 'Common.ValueListParameterInOut',
                    LocalDataProperty: books_ID,
                    ValueListProperty: 'ID'
                },
                {
                    $Type: 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'code'
                },
                {
                    $Type: 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'books.description'
                },
            ]
        }
    );
}



annotate StudentDB.Student with @(
    UI.LineItem: [
        {
            $Type: 'UI.DataField',
            Value: stdid
        },
        {
            $Type: 'UI.DataField',
            Label: 'Gender',
            Value: gender
        },
        {
            $Type: 'UI.DataField',
            Value: first_name
        },
        {
            $Type: 'UI.DataField',
            Value: last_name
        },
        {
            $Type: 'UI.DataField',
            Value: email_id
        },
        {
            $Type: 'UI.DataField',
            Value: pan_no 
        },
        {
            $Type: 'UI.DataField',
            Value: dob
        },
        {
            Value: course.code
        },
        {
            Value: is_alumni
        }
    ],
    UI.SelectionFields: [first_name, last_name, email_id],
    UI.FieldGroup #StudentInformation: {
        $Type: 'UI.FieldGroupType',
        Data: [
            {
                $Type: 'UI.DataField',
                Value: stdid,
            },
            {
                $Type: 'UI.DataField',
                Label: 'Gender',
                Value: gender,
            },
            {
                $Type: 'UI.DataField',
                Value: first_name,
            },
            {
                $Type: 'UI.DataField',
                Value: last_name,
            },
            {
                $Type: 'UI.DataField',
                Value: email_id,
            },
            {
                $Type: 'UI.DataField',
                Value: pan_no,
            },
            {
                $Type: 'UI.DataField',
                Value: dob,
            },
            {
                $Type: 'UI.DataField',
                Value: course_ID,
            }
        ],
    },
    UI.Facets: [
        {
            $Type: 'UI.ReferenceFacet',
            ID: 'StudentInfoFacet',
            Label: 'Student Information',
            Target: '@UI.FieldGroup#StudentInformation',
        },
        {
            $Type: 'UI.ReferenceFacet',
            ID: 'StudentLanguagesFacet',
            Label: 'Student Languages Information',
            Target: 'Languages/@UI.LineItem',
        },
    ],
);

annotate StudentDB.Student.Languages with {
    lang @(
        Common.Text: lang.description,
        Common.TextArrangement: #TextOnly,
        Common.ValueListWithFixedValues: true,
        Common.ValueList: {
            Label: 'Languages',
            CollectionPath: 'Languages',
            Parameters: [
                {
                    $Type: 'Common.ValueListParameterInOut',
                    LocalDataProperty: lang_ID,
                    ValueListProperty: 'ID'
                },
                {
                    $Type: 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'code'
                },
                {
                    $Type: 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'description'
                },
            ]
        }
    );
}

annotate StudentDB.Student with {
    gender @(
        Common.ValueListWithFixedValues: true,
        Common.ValueList: {
            Label: 'Genders',
            CollectionPath: 'Gender',
            Parameters: [
                {
                    $Type: 'Common.ValueListParameterInOut',
                    LocalDataProperty: gender,
                    ValueListProperty: 'code'
                },
                {
                    $Type: 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'description'
                }
            ]
        }
    );
    course @(
        Common.Text: course.description,
        Common.TextArrangement: #TextOnly,
        Common.ValueListWithFixedValues: true,
        Common.ValueList: {
            Label: 'Courses',
            CollectionPath: 'Courses',
            Parameters: [
                {
                    $Type: 'Common.ValueListParameterInOut',
                    LocalDataProperty: course_ID,
                    ValueListProperty: 'ID'
                },
                {
                    $Type: 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'code'
                },
                {
                    $Type: 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'description'
                }
            ]
        }
    );
};