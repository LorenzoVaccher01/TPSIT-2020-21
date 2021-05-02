const express = require('express');
const router = express.Router();
const admin = require('firebase-admin');

const settings = require('../../settings.json');
const database = require('../../modules/database');
const logger = require('../../modules/logger');

/**
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


router.get('/classes', async (req, res, next) => {
  await logger.user('api/get/classes', req, res);
  let classes = await database.query("SELECT id, section, year FROM classes ORDER BY year ASC, section ASC");
  res.json({
    status: 200, data: classes
  });
});

router.get('/teachers', async (req, res, next) => {
  await logger.user('api/get/teachers', req, res);

  if (req.session.user.isAdmin) {
    let teachers = await database.query("SELECT id, name, email FROM teachers ORDER BY name ASC");

    for (let i = 0; i < teachers.length; i++) {
      teachers[i].concourseClass = "";
      teachers[i].profileImage = (await admin.auth().getUserByEmail(teachers[i].email)).photoURL;
    }

    res.json({
      status: 200, data: teachers
    });
  } else {
    res.json({ status: 401, message: "You are not authorized to view this content."});
  }
});

router.get('/rooms', async (req, res, next) => {
  await logger.user('api/get/rooms', req, res);
  let rooms = await database.query("SELECT id, identifier AS identificator FROM rooms ORDER BY identifier ASC");
  res.json({
    status: 200, data: rooms
  });
});

router.get('/events', _checkAutentication, async (req, res, next) => {
  await logger.user('api/get/events', req, res);

  let sorting = req.query.sorting;
  let date = req.query.date;
  let events = [];

  switch (sorting) {
    case 'name':
      sorting = 'ORDER BY teachers.name ASC';
      break;
    case 'hour':
      sorting = 'ORDER BY reservations.dateTo ASC';
      break;
    case 'class':
      sorting = 'ORDER BY classes.year ASC, classes.section ASC';
      break;
    case 'room':
      sorting = 'ORDER BY rooms.identifier ASC';
      break;
    default:
      sorting = 'ORDER BY teachers.name ASC';
  }

  let eventsResult = await database.query(`SELECT reservations.id, reservations.dateFrom, reservations.dateTo, reservations.creationDate, rooms.id AS roomId, rooms.identifier AS roomIdentifier, teachers.id AS teacherId, teachers.name, teachers.email, classes.id as classId, classes.section, classes.year
                                    FROM reservations
                                    INNER JOIN rooms ON rooms.id = reservations.roomId
                                    INNER JOIN teachers ON teachers.id = reservations.teacherId
                                    INNER JOIN classes ON classes.id = reservations.classId
                                    WHERE reservations.dateFrom LIKE "${date} %" ${sorting}`);

  for (let i = 0; i < eventsResult.length; i++) {
    const event = eventsResult[i];
    events.push({
      id: event.id,
      dateFrom: event.dateFrom,
      dateTo: event.dateTo,
      teacher: {
        id: event.teacherId,
        name: event.name,
        email: event.email,
        concourseClass: "", //TODO: da implementare
        profileImage: (await admin.auth().getUserByEmail(event.email)).photoURL
      },
      schoolClass: {
        id: event.classId,
        section: event.section,
        year: event.year
      },
      room: {
        id: event.roomId,
        identificator: event.roomIdentifier
      }
    });
  }

  res.json({
    status: 200, data: events
  });
});

module.exports = router;
