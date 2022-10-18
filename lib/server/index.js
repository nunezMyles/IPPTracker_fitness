
const express = require('express'); // similar to 'import'
const PORT = 3000;
const app = express();

// Creating API Calls
app.get("/", (req, res) => { // if website is localhost:3000/hello-world, output:
    res.json({"name":"Myles"});
})


app.listen(PORT, "0.0.0.0", () => {
    console.log(`Connected at port ${PORT}`);
})