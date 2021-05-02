const nodemailer = require('nodemailer');
const logger = require("./logger");

const settings = require('../settings.json');

/**
 * This function is used to send emails to other users.
 * 
 * @param {*} data data used to send the email and some arguments that needs to be rendered in the template eventually.
 */
exports.send = function (data) {
  let transporter = nodemailer.createTransport({
    host: settings.email.host,
    port: settings.email.port,
    secure: settings.email.secure,
    pool: settings.email.pool,
    auth: {
      user: settings.email.auth.user,
      pass: settings.email.auth.password
    }
  });

  for (var i = 0; i < data.to.length; i++) {
    transporter.sendMail({
      from: settings.email.from,
      to: data.to[i].email,
      subject: data.subject,
      attachments: data.attachments,
      html: data.data.html
    }, function (error, info) {
      if (error) {
        logger.error(error, "email");
      } else {
        logger.log(`Email sent &aTO&r: &a${info.envelope.to}&r with the &a${template} template&r. &aEmail ID&r: &a${info.messageId}&r.`, "email");
      }
    });
  }
};