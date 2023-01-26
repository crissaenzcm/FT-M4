const { Sequelize, Op } = require("sequelize");
const modelCharacter = require("./models/Character.js");
const modelAbility = require("./models/Ability.js");
const modelRole = require("./models/Role.js");
require("dotenv").config();

const { DB_USER, DB_PASSWORD, DB_HOST } = process.env;

const db = new Sequelize(
  `postgres://${DB_USER}:${DB_PASSWORD}@${DB_HOST}/henry_sequelize`,
  {
    logging: false,
  }
);

modelCharacter(db);
modelAbility(db);
modelRole(db);

//Relaciones
const { Character, Ability, Role } = db.models;

Character.hasMany(Ability);
Ability.belongsTo(Character);

Character.belongsToMany(Role, { through: "CharacterRole" });
Role.belongsToMany(Character, { through: "CharacterRole" });

module.exports = {
  ...db.models,
  db,
  Op,
};
