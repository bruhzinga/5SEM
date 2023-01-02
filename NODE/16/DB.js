const mysql = require("mysql2");

const pool = mysql.createPool({
  host: 'localhost',
  user: 'root',
  database: 'LABA14',
  password: 'example',
  connectionLimit:"10",
}).promise();

function DB(cb) {
  this.getFullTable = async (tableName) => {
    const [rows, fields] = await pool.execute(`SELECT * FROM ${tableName} `);
    return rows;
  };

  this.getOneRecord = async (tableName, value) => {
    const [rows, fields] = await pool.execute(`SELECT * FROM ${tableName} where ${tableName} = ?`, [value]);
    return rows;
  };

  this.deleteOneRecord = async (tableName, value) => {
    const [rows, fields,] = await pool.execute(`delete from ${tableName} where ${tableName} = ?`, [value]);
    return rows.affectedRows != 0;
  };

  this.insertOneRecord = async (tableName, args) => {
    let keys = Object.keys(args);
    let values = Object.values(args);
    let query = `insert into ${tableName} (${keys.join(",")}) values (${values.map((v) => "?").join(",")})`;
    await pool.execute(query, values);
    const [rows, fields2,] = await pool.execute(`SELECT * FROM ${tableName} where ${tableName} = ?`, [args[tableName]]);
    return rows[0];

  };

  this.updateOneRecord = async (tableName, args) => {
    let updateComponent = "";
    const keys = Object.keys(args);
    const values = Object.values(args);
    for (let i = 0; i < keys.length; i++) {
      updateComponent += `${keys[i]} = '${values[i]}', `;
    }
    updateComponent = updateComponent.slice(0, -2);
    let sqlToUpd = `update ${tableName} set ${updateComponent} where ${tableName} = ?`;
      await pool.execute(sqlToUpd, [args[tableName]]);
      let sqlToSel =`SELECT * FROM ${tableName} where ${tableName} = ?`;
      const [rows, fields2,] = await pool.execute(sqlToSel, [args[tableName]]);
      return rows[0]??null;


    }


    this.getTeachersByFaculty = async (args, context) => {
      const [rows, fields,] = await pool.query(`select TEACHER.*,P.FACULTY,P.FACULTY from TEACHER
       join PULPIT P on P.PULPIT = TEACHER.PULPIT
       where P.FACULTY = ?`, [args.FACULTY]);
      let dataToReturn = [];
      let faculties = rows.map((item) => item.FACULTY);
      let uniqueFaculties = [...new Set(faculties)];
      uniqueFaculties.forEach((faculty) => {
        let teachers = rows.filter((item) => item.FACULTY === faculty);
        dataToReturn.push({
          FACULTY: faculty,
          TEACHERS: teachers.map((item) => {
            return {
              TEACHER: item.TEACHER,
              TEACHER_NAME: item.TEACHER_NAME,
              PULPIT: item.PULPIT,
            }
          })
        })
        });

      return dataToReturn;
    };

    this.getSubjectsByFaculties = async (args, context) => {

      const [rows, fields] = await pool.query(`select SUBJECT.*, PULPIT.PULPIT_NAME, PULPIT.FACULTY from SUBJECT join PULPIT on SUBJECT.PULPIT = PULPIT.PULPIT join FACULTY on PULPIT.FACULTY = FACULTY.FACULTY where FACULTY.FACULTY = ?`, [args.FACULTY]);
      let dataToReturn = [];
      let pulpits = rows.map((item) => item.PULPIT);
      let uniquePulpits = [...new Set(pulpits)];
        uniquePulpits.forEach((item) => {
            let subjects = rows.filter((row) => row.PULPIT === item);
            dataToReturn.push({
                FACULTY: args.FACULTY,
                PULPIT: item,
                PULPIT_NAME: subjects[0].PULPIT_NAME,
                SUBJECTS: subjects.map((subject) => {
                return {
                    SUBJECT: subject.SUBJECT,
                    SUBJECT_NAME: subject.SUBJECT_NAME,
                    PULPIT: subject.PULPIT,
                }
                })
            })
        });
      return dataToReturn;
    };
}




exports.DB = (cb) => new DB(cb);
