/**
 * Author: Lorenzo Vaccher
 * Author URI: https://lorenzovaccher.com
 * Copyright 2020 Lorenzo Vaccher
 */

const fs = require('fs');
const geoip = require('geoip-lite');
const countries = require('i18n-iso-countries');

const database = require('./database');

/**
 * Colors' code, used for the console coloring.
 */
const _COLOR = {
  RESET: '\x1b[0m',
  HIDDEN: '\x1b[8m',
  REVERSE: '\x1b[7m',
  BLINK: '\x1b[5m',
  UNDERSCORE: '\x1b[4m',
  BLACK: '\x1b[30m',
  RED: '\x1b[31m',
  GREEN: '\x1b[32m',
  YELLOW: '\x1b[33m',
  BLUE: '\x1b[34m',
  MAGENTA: '\x1b[35m',
  CYAN: '\x1b[36m',
  WHITE: '\x1b[37m',
}

/**
 * Simplified codes which are used to refer to the costant _COLOR's colors
 */
const _COLOR_CODE = {
  RESET: '&r',
  HIDDEN: '&k',
  REVERSE: '&x',
  BLINK: '&z',
  UNDERSCORE: '&n',
  BLACK: '&0',
  RED: '&c',
  GREEN: '&a',
  YELLOW: '&e',
  BLUE: '&9',
  MAGENTA: '&5',
  CYAN: '&b',
  WHITE: '&f',
};

const _TYPE = {
  INFO: _COLOR.CYAN + '[' + _COLOR.GREEN + 'INFO' + _COLOR.CYAN + '] ' + _COLOR.RESET,
  WARNING: _COLOR.CYAN + '[' + _COLOR.YELLOW + 'WARNING' + _COLOR.CYAN + '] ' + _COLOR.RESET,
  ERROR: _COLOR.CYAN + '[' + _COLOR.RED + 'ERROR' + _COLOR.CYAN + '] ' + _COLOR.RESET
}

const _TARGET = {
  database: '&b[&cDATABASE&b]&r ',
  website: '&b[&eWEBSITE&b]&r ',
  email: '&b[&5EMAIL&b]&r '
}

/**
 * This costant is used to save all the months' name which will be used to create folders later.
 */
const _MONTH_NAME = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];

let log = (string, target, args = []) => {
  if (target != undefined || target != null)
    if (_TARGET[target.toLocaleLowerCase()] != undefined)
      string = _TARGET[target.toLocaleLowerCase()] + string;
    else
      error('The target is not defined for the following message!');

  for (let i = 0; i < Object.keys(args).length; i++)
    string = string.split('%' + Object.keys(args)[i] + '%').join(Object.values(args)[i]);

  for (let i = 0; i < Object.values(_COLOR_CODE).length; i++)
    string = string.split(Object.values(_COLOR_CODE)[i]).join(Object.values(_COLOR)[i]);

  console.log(getConsoleDate() + _TYPE.INFO + string + _COLOR.RESET);

  for (let i = 0; i < Object.values(_COLOR).length; i++)
    string = string.split(Object.values(_COLOR)[i]).join('');

  fileWrite('[INFO] ' + string);
}

let warn = (string, target, args = []) => {
  if (target != undefined || target != null)
    if (_TARGET[target.toLocaleLowerCase()] != undefined)
      string = _TARGET[target.toLocaleLowerCase()] + string;
    else
      error('The target is not defined for the following message!');

  for (let i = 0; i < Object.keys(args).length; i++)
    string = string.split('%' + Object.keys(args)[i] + '%').join(Object.values(args)[i]);

  for (let i = 0; i < Object.values(_COLOR_CODE).length; i++)
    string = string.split(Object.values(_COLOR_CODE)[i]).join(Object.values(_COLOR)[i]);

  console.log(getConsoleDate() + _TYPE.WARNING + string + _COLOR.RESET);

  for (let i = 0; i < Object.values(_COLOR).length; i++)
    string = string.split(Object.values(_COLOR)[i]).join('');

  fileWrite('[WARN] ' + string);
}

let error = (string, target, args = []) => {
  console.log(string);
  if (target != undefined || target != null)
    if (_TARGET[target.toLocaleLowerCase()] != undefined)
      string = _TARGET[target.toLocaleLowerCase()] + string;
    else
      error('The target is not defined for the following message!');

  for (let i = 0; i < Object.keys(args).length; i++)
    string = string.split('%' + Object.keys(args)[i] + '%').join(Object.values(args)[i]);

  /*for (let i = 0; i < Object.values(_COLOR_CODE).length; i++)
  string = string.split(Object.values(_COLOR_CODE)[i]).join(Object.values(_COLOR)[i]);*/ //TODO: lancia un errore, vedere perchè

  console.log(getConsoleDate() + _TYPE.ERROR + string + _COLOR.RESET);
  /*for (let i = 0; i < Object.values(_COLOR).length; i++)
      string = string.split(Object.values(_COLOR)[i]).join('');*/

  fileWrite('[ERROR] ' + string);
  fileWrite(string.stack);
}

function fileWrite(string) {
  let date = new Date();
  if (!fs.existsSync('log')) fs.mkdirSync('log');

  if (!fs.existsSync('log/' + date.getFullYear())) fs.mkdirSync('log/' + date.getFullYear());

  if (!fs.existsSync('log/' + date.getFullYear() + '/' + _MONTH_NAME[date.getMonth()])) fs.mkdirSync('log/' + date.getFullYear() + '/' + _MONTH_NAME[date.getMonth()]);

  fs.appendFile('log/' + date.getFullYear() + '/' + _MONTH_NAME[date.getMonth()] + '/' + ("0" + date.getDate()).slice(-2) + '-' + ("0" + (date.getMonth() + 1)).slice(-2) + '-' + date.getFullYear() + '.log', getLogDate() + string + '\n', function (err) {
    if (err)
      error(err);
  });
}

/**
 * This function is used to clear the console.
 */
let clearConsole = () => {
  console.clear();
}

/**
 * This function is used for the log files. It just returns the date, as files are generated day by day.
 */
function getLogDate() {
  let date = new Date();
  return '[' + ("0" + date.getHours()).slice(-2) + ':' + ("0" + date.getMinutes()).slice(-2) + ':' + ("0" + date.getSeconds()).slice(-2) + '] ';
}

/**
 * This function returns the date and time.
 */
function getConsoleDate() {
  let date = new Date();
  return _COLOR.CYAN + '[' + _COLOR.RESET + ("0" + date.getDate()).slice(-2) + '/' + ("0" + (date.getMonth() + 1)).slice(-2) + '/' + date.getFullYear() + ' ' + ("0" + date.getHours()).slice(-2) + ':' + ("0" + date.getMinutes()).slice(-2) + ':' + ("0" + date.getSeconds()).slice(-2) + '' + _COLOR.CYAN + '] ' + _COLOR.RESET;
}

/**
 * This function is used to print the user's location and to update the database with the last viewed display by the user.
 *
 * @param {String} position the position of the user (es: index, rule)
 */
let user = async (position, req, res) => {
  let userIp = req.ip.split(':')[req.ip.split(':').length - 1];
  let country = countries.getName(geoip.lookup(userIp).country, "en");

  log(_TARGET.website + 'User ' + _COLOR.GREEN + userIp + _COLOR.RESET + ' (' + country + ') is viewing the ' + _COLOR.GREEN + position + ' ' + _COLOR.RESET + 'page');
  let data = await database.query('SELECT COUNT(*) AS n FROM visitors WHERE lastIp=\'' + userIp + '\';');

  if (data[0].n >= 1)
    await database.query('UPDATE visitors SET lastVisitDate=CURRENT_TIMESTAMP, lastPagePosition=\'' + position + '\', country=\'' + country + '\' WHERE lastIp=\'' + userIp + '\';');
  else
    await database.query('INSERT INTO visitors (lastIp, country, lastPagePosition) VALUES (\'' + userIp + '\', \'' + country + '\', \'' + position + '\')');

  if (!(req.session.user == '' || req.session.user == undefined))
    if (req.session.user.logged)
      await database.query('UPDATE accounts SET lastAccessDate=CURRENT_TIMESTAMP() WHERE id=' + req.session.user.id);
}

module.exports._COLOR = _COLOR;
module.exports.log = log;
module.exports.warn = warn;
module.exports.error = error;
module.exports.clearConsole = clearConsole;
module.exports.user = user;