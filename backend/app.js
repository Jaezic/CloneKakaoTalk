var express = require('express');
var path = require("path");
var app = express();
const { createProxyMiddleware } = require('http-proxy-middleware');

app.set("views", path.join(__dirname, "views"));
app.set("view engine", "jade");


var uploadRouter = require("./routes/upload");

app.use(express.json({ limit: "100mb" }));
app.use(express.urlencoded({ limit: "100mb", extended: false }));

app.use("/api/upload", uploadRouter);
app.use("/upload", express.static("upload"));

app.use(express.static(path.join(__dirname, "public")));
app.use(express.static(path.join(__dirname, "/../../gachon_qr_code/frontend/build/web")));

app.get(["/"], (req, res) => {
   res.sendFile(path.join(__dirname + "../../../gachon_qr_code/frontend/build/web/index.html"));
});




// catch 404 and forward to error handler
app.use(function (req, res, next) {
   next(createError(404));
});

// error handler
app.use(function (err, req, res, next) {
   // set locals, only providing error in development
   res.locals.message = err.message;
   // res.locals.error = req.app.get("env") === "development" ? err : {};
   res.locals.error = err;

   // render the error page
   res.status(err.status || 500);
   // res.render("error");
   res.status(500).json({ message: err.message });
});

module.exports = app;