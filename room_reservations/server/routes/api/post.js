const express = require('express');
const router = express.Router();
const admin = require('firebase-admin');

const settings = require('../../settings.json');
const database = require('../../modules/database');
const logger = require('../../modules/logger');

/** //TODO: tradurre
 * Funzione utilizzata per verificare se l'utente ha
 * l'autorizzazione ad accedere nella sezione admin.
 *
 * @param {*} req
 * @param {*} res
 * @param {*} next
 */
function _checkAutentication(req, res, next) {
  if (!(req.session.user == '' || req.session.user == undefined))
    if (req.session.user.logged)
      next();
    else
      res.json({ status: 401, message: 'You must log in before doing this operation.' });
  else
    res.json({ status: 401, message: 'You must log in before doing this operation.' });
}


router.post('/event', _checkAutentication, async (req, res, next) => {
  await logger.user('api/post/event', req, res);

  try {
    let teacher = database.escape(req.body.teacher);
    let schoolClass = database.escape(req.body.schoolClass);
    let schoolClassYear = database.escape(req.body.schoolClass.substring(0, 1));
    let schoolClassSection = database.escape(req.body.schoolClass.substring(1));
    let room = database.escape(req.body.room);
    let day = database.escape(req.body.day);
    let dateFrom = database.escape(req.body.dateFrom);
    let dateTo = database.escape(req.body.dateTo);

    if (req.body.teacher == req.session.user.email || req.session.user.isAdmin) {
      if (teacher != null && teacher != "null" && teacher != undefined && teacher != 'NULL' && teacher != "'" &&
        schoolClass != null && schoolClass != "null" && schoolClass != undefined && schoolClass != 'NULL' && schoolClass != "'" &&
        room != null && room != "null" && room != undefined && room != 'NULL' && room != "'" &&
        day != null && day != "null" && day != undefined && day != 'NULL' && day != "'" &&
        dateFrom != null && dateFrom != "null" && dateFrom != undefined && dateFrom != 'NULL' && dateFrom != "'" &&
        dateTo != null && dateTo != "null" && dateTo != undefined && dateTo != 'NULL' && dateTo != "'" &&
        schoolClassYear != null && schoolClassYear != "null" && schoolClassYear != undefined && schoolClassYear != 'NULL' && schoolClassYear != "'" &&
        schoolClassSection != null && schoolClassSection != "null" && schoolClassSection != undefined && schoolClassSection != 'NULL' && schoolClassSection != "'") {

        let reservations = await database.query(`SELECT COUNT(*) AS total
                                                FROM reservations
                                                WHERE roomId = (SELECT id FROM rooms WHERE identifier = ${room})
                                                    AND (dateFrom BETWEEN "${req.body.day} ${req.body.dateFrom}" AND "${req.body.day} ${req.body.dateTo}"
                                                    OR dateTo BETWEEN "${req.body.day} ${req.body.dateFrom}" AND "${req.body.day} ${req.body.dateTo}")`);

        if (reservations[0].total == 0) {
          let result = await database.query(`INSERT INTO reservations(teacherId, roomId, classId, dateFrom, dateTo) VALUES(
                                                (SELECT id FROM teachers WHERE email=${teacher}), 
                                                (SELECT id FROM rooms WHERE identifier = ${room}), 
                                                (SELECT id FROM classes WHERE year = ${schoolClassYear} AND section = ${schoolClassSection}),
                                                "${req.body.day} ${req.body.dateFrom}:00", "${req.body.day} ${req.body.dateTo}:00")`);

          let teacherDb = await database.query(`SELECT id, uid, fcmToken, name, email, emailNotifications, notifications FROM teachers WHERE email = ${teacher}`);
          
          if (teacherDb[0].notifications == 1) {
            admin.messaging().send({
              token: teacherDb[0].fcmToken,
              notification: {
                title: "New Reservations",
                body: `${teacherDb[0].name}, a reservation has just been made for the day ${req.body.day} from ${req.body.dateFrom} to ${req.body.dateTo} for the ${req.body.schoolClass} class`
              }
            }).catch((error) => console.log(error));
          }

          if (teacherDb[0].emailNotifications == 1) {
            require('../../modules/email').send({
              subject: 'New reservation!',
              to: [{
                email: teacherDb[0].email
              }],
              data: {
                html: `<p>${teacherDb[0].name}, a reservation has just been made for the day ${req.body.day} from ${req.body.dateFrom} to ${req.body.dateTo} for the ${req.body.schoolClass} class.</p>`
              }
            });
          }

          res.json({ status: 200, data: { eventId: result.insertId } });
        } else {
          res.json({ status: 405, message: "This operation is not allowed as there is already a reservation in the selected time and classroom!" });
        }
      } else {
        res.json({ status: 400, message: "The data you have provided is incorrect!" });
      }
    } else {
      res.json({ status: 401, message: "You are not authorized to perform this operation!" });
    }
  } catch (e) {
    console.log(e);
    res.json({ status: 500, message: "Internal server error." });
  }
});

module.exports = router;
