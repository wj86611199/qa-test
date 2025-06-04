const express = require('express');
const app = express();
const port = 3000;

app.get('/', (req, res) => {
  res.send('VNC Server is running!');
});

app.listen(port, '0.0.0.0', () => {
  console.log(`Server listening on port ${port}`);
});
