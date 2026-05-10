const fs = require('fs');
const dotenv = require('dotenv');
const mongoose = require('mongoose');
const app = require('./app');

const setSecretAsEnv = (envname, path) => {
    const text = fs.readFileSync(path, { encoding: 'utf8', flag: 'r' }).trim();
    console.log(text);
    process.env[envname] = text;
}

setSecretAsEnv("DATABASE", '/run/secrets/DATABASE');
setSecretAsEnv("PORT", '/run/secrets/PORT');
setSecretAsEnv("DATABASE_PASSWORD", '/run/secrets/DATABASE_PASSWORD');

const DB = process.env.DATABASE.replace('<PASSWORD>',process.env.DATABASE_PASSWORD);

mongoose.connect(DB)
    .then(() => {
        console.log('Connection successful');
    })
    .catch(err => {
        console.log('Connection failed due to: ', err.message);
        process.exit(1);
    })

const port = process.env.PORT;

app.listen(port, () => {
    console.log(`starting server on port ${port}`);
})
