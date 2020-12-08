/**
 * Author: Lorenzo Vaccher
 * Author URI: https://lorenzovaccher.com
 * Copyright 2020 Lorenzo Vaccher
 */

const fs = require('fs');

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
  REVERSE: '&m',
  BLINK: '&n',
  UNDERSCORE: '&b',
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

/**
 * This costant is used to save all the months' name which will be used to create folders later.
 */
const _MONTH_NAME = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];

let log = (string, target, args = []) => {
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

  console.log(string); //TODO: da eliminare, solo per debug

  for (let i = 0; i < Object.keys(args).length; i++)
    string = string.split('%' + Object.keys(args)[i] + '%').join(Object.values(args)[i]);

  for (let i = 0; i < Object.values(_COLOR_CODE).length; i++)
    string = string.split(Object.values(_COLOR_CODE)[i]).join(Object.values(_COLOR)[i]);

  console.log(getConsoleDate() + _TYPE.ERROR + string + _COLOR.RESET);

  for (let i = 0; i < Object.values(_COLOR).length; i++)
    string = string.split(Object.values(_COLOR)[i]).join('');

  fileWrite('[ERROR] ' + string);
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

module.exports._COLOR = _COLOR;
module.exports.log = log;
module.exports.warn = warn;
module.exports.error = error;
module.exports.clearConsole = clearConsole;