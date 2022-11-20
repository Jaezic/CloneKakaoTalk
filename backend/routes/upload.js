var express = require("express");
var router = express.Router();

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
    
    //let user_id = req.id;
    // sql = `insert into User_file(fieldname, user_id, originalname, encoding, mimetype, destination, filename, path, size) values (?,?,?,?,?,?,?,?,?)`;
    // result = await pool.query(sql, [
    //   fieldname,
    //   user_id,
    //   originalname,
    //   encoding,
    //   mimetype,
    //   destination,
    //   filename,
    //   path,
    //   size,
    // ]);
    console.log(req); // 콘솔(터미널)을 통해서 req.file Object 내용 확인 가능.
    // res.json({
    //   id: result[0].insertId,
    //   user_id,
    //   fieldname,
    //   originalname,
    //   encoding,
    //   mimetype,
    //   destination,
    //   filename,
    //   path,
    //   size,
    // });
});

module.exports = router;