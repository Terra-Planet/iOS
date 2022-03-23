const express = require('express')
const port = 3000
const wallet_router = require('./lib/wallet')
const anchor_router = require('./lib/anchor')
const app = express()

app.use(express.json());

app.use('/wallet', wallet_router);
app.use('/anchor', anchor_router);

module.exports = app;