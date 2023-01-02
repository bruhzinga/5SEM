class StudentError extends Error {
    constructor(message, error) {
        super(message);
        this.name = 'StudentError';
        this.error = error;
    }
}
module.exports = {StudentError};