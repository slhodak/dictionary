const path = require("path");
const fs = require("fs");
const express = require("express");
const app = express();
const port = 7070;
const fsPromises = fs.promises;

app.use(express.static("public"));
app.use(express.json());

// route to get all entries
app.get("/entries", async (_req, res) => {
  const glossaryItems = await fsPromises.readFile(path.resolve(__dirname, "../data/sampleItems.json"));
  res.send(glossaryItems);
});

// route to edit an entry
app.put("/entry", async (req, res) => {
  console.log(req.body);
  res.send("OK");
});

// route to add an entry


app.listen(port, () => {
  // tslint:disable-next-line:no-console
    console.log(`Glossary Server started at ${port}`);
});
