// Simple server for Bun
const express = require("express")
const app = express()
const port = process.env.PORT || 3000

app.use(express.static("public"))

app.get("/", (req, res) => {
  res.send("Flutter Cocktail Timeline App - Please use Flutter to build and run this project")
})

app.listen(port, () => {
  console.log(`Server listening at http://localhost:${port}`)
})
