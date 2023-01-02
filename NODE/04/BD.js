const events = require('events');

class DB extends events.EventEmitter {
    data = [];

    Select() {
        return new Promise((resolve, reject) => resolve(this.data));
    }

    Insert(user) {
        return new Promise((resolve, reject) => {
            if (this.data.find(u => u.id === user.id) !== undefined)
                reject("User already exists");
            else {
                this.data.push(user);
                resolve('Success');
            }
        });
    }

    Update(user) {
        return new Promise((resolve, reject) => {
            const index = this.data.findIndex(u => u.id === user.id);
            if (index !== -1) {
                this.data[index] = user;
                resolve('Success');
            } else {
                reject('User not found');
            }
        });
    }

    Delete(id) {
        return new Promise((resolve, reject) => {
            const index = this.data.findIndex(u => u.id === id);
            console.log(this.data);
            console.log(index);
            if (index !== -1) {
                const user = this.data[index];
                this.data.splice(index, 1);
                resolve(user);
            } else {
                reject();
            }
        });
    }
}

module.exports = new DB();