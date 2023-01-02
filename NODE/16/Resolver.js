const resolver = {
  getFaculties: (args, context) => {
    return args.FACULTY
      ? context.getOneRecord("FACULTY", args.FACULTY)
      : context.getFullTable("FACULTY");
  },
  getTeachers: (args, context) => {
    return args.TEACHER
      ? context.getOneRecord("TEACHER", args.TEACHER)
    : context.getFullTable("TEACHER");
  },
  getPulpits: (args, context) => {
    return args.PULPIT
      ? context.getOneRecord("PULPIT", args.PULPIT)
      : context.getFullTable("PULPIT");
  },
  getSubjects: (args, context) => {
    return args.SUBJECT
      ? context.getOneRecord("SUBJECT", args.SUBJECT)
      : context.getFullTable("SUBJECT");
  },
  setFaculty: async (args, context) => {
    return (
        (await context.updateOneRecord("FACULTY", args)) ??
        (await context.insertOneRecord("FACULTY", args))
    );
  },
  setTeacher: async (args, context) => {
    return (
      (await context.updateOneRecord("TEACHER", args)) ??
      (await context.insertOneRecord("TEACHER", args))
    );
  },
  setPulpit: async (args, context) => {
    return (
      (await context.updateOneRecord("PULPIT", args)) ??
      (await context.insertOneRecord("PULPIT", args))
    );
  },
  setSubject: async (args, context) => {
    return (
      (await context.updateOneRecord("SUBJECT", args)) ??
      (await context.insertOneRecord("SUBJECT", args))
    );
  },
  delFaculty: (args, context) =>
    context.deleteOneRecord("FACULTY", args.FACULTY),

  delTeacher: (args, context) =>
    context.deleteOneRecord("TEACHER", args.TEACHER),

  delPulpit: (args, context) => context.deleteOneRecord("PULPIT", args.PULPIT),

  delSubject: (args, context) =>
    context.deleteOneRecord("SUBJECT", args.SUBJECT),

  getTeachersByFaculty: (args, context) => context.getTeachersByFaculty(args),

  getSubjectsByFaculties: (args, context) =>
      context.getSubjectsByFaculties(args, context),
};

module.exports = resolver;
