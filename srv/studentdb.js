const cds = require('@sap/cds');

function calcAge(dob) {
    var today = new Date();
    var birthDate = new Date(Date.parse(dob));
    var age = today.getFullYear() - birthDate.getFullYear();
    var m = today.getMonth() - birthDate.getMonth();
    if (m < 0 || (m === 0 && today.getDate() < birthDate.getDate())) {
        age--;
    }
    return age;
}


module.exports = cds.service.impl(function () {

    const { Student, Gender } = this.entities();

    // Read operation for Student with Age Calculation
    this.on('READ', Student, async (req) => {
        const results = await cds.run(req.query);
        if (Array.isArray(results)) {
            results.forEach(element => {
                element.age = calcAge(element.dob);
                element.gender = getDisplayGender(element.gender);

            });
        } else {
            results.age = calcAge(results.dob);
            results.gender = getDisplayGender(results.gender);

        }
        return results;
    });

    function getDisplayGender(code) {
        var gender_description;
        console.log(code);
        if(code === "F"){
            gender_description="Female";
        }
        else{
            gender_description="Male";
        }
        return gender_description;
        
    }
    
    // Before Create Operation for Student
    this.before(['CREATE'], Student, async (req) => {
        const age = calcAge(req.data.dob);
        if (age < 18 || age > 45) {
            req.error({ code: 'WRONGDOB', message: 'Student not the right age for school: ' + age, target: 'dob' });
        }

        const emailQuery = SELECT.from(Student).where({ email_id: req.data.email_id });
        const emailResult = await cds.run(emailQuery);
        if (emailResult.length > 0) {
            req.error({ code: 'STEMAILEXISTS', message: 'Student with such email already exists', target: 'email_id' });
        }

        const panQuery = SELECT.from(Student).where({ pan_no: req.data.pan_no });
        const panResult = await cds.run(panQuery);
        if (panResult.length > 0) {
            req.error({ code: 'STPANEXISTS', message: 'Student with such pan_no already exists', target: 'pan_no' });
        }
    });

    // Before Update Operation for Student
    this.before(['UPDATE'], Student, async (req) => {
        const { email_id, stdid } = req.data;
        if (email_id) {
            const query = SELECT.from(Student).where({ email_id: email_id }).and({ stdid: { '!=': stdid } });
            const result = await cds.run(query);
            if (result.length > 0) {
                req.error({ code: 'STEMAILEXISTS', message: 'Student with such email already exists', target: 'email_id' });
            }
        }
    });

    // Read operation for Gender
    this.on('READ', Gender, async (req) => {
        const genders = [
            { "code": "M", "description": "Male" },
            { "code": "F", "description": "Female" }
        ];
        genders.$count = genders.length;
        return genders;
    });
    

});
