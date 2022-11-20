var express = require("express");
var router = express.Router();
var multer = require("multer");
const crypto = require("crypto");
var pool = require("../mysql");

var storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, "upload/");
  },
  filename: (req, file, cb) => {
    let ext = file.originalname.substring(
      file.originalname.lastIndexOf("."),
      file.originalname.length
    );
    let customFileName = crypto.randomBytes(18).toString("hex");
    cb(null, customFileName + ext);
  },
});

var upload = multer({ storage: storage });

router.get("/", (req, res) => {
  res.render("post");
});

router.post("/", upload.single("userfile"), async (req, res) => {
    // res.send("Uploaded! : " + req.file); // object를 리턴함
    let {
      fieldname,
      originalname,
      encoding,
      mimetype,
      destination,
      filename,
      path,
      size,
    } = req.file; 
    
    let user_id = req.body.id;
    sql = `insert into User_file(fieldname, user_id, originalname, encoding, mimetype, destination, filename, path, size) values (?,?,?,?,?,?,?,?,?)`;
    result = await pool.query(sql, [
      fieldname,
      user_id,
      originalname,
      encoding,
      mimetype,
      destination,
      filename,
      path,
      size,
    ]);
    res.status(200).json({
      id: result[0].insertId,
      user_id,
      fieldname,
      originalname,
      encoding,
      mimetype,
      destination,
      filename,
      path,
      size,
    });
});

module.exports = router;