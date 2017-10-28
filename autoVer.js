var randomstring = require("randomstring");
module.exports = function (src) {
  return src.replace(/\{\{auto_ver\}\}/g, randomstring.generate())
}