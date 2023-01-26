const { Router } = require("express");
const { Ability } = require("../db");
const router = Router();

router.post("/", async (req, res) => {
  const { name, description, mana_cost } = req.body;
  try {
    if (!name || !mana_cost) throw Error("Falta enviar datos obligatorios");
    const newAbility = await Ability.create({ name, description, mana_cost });
    res.status(201).json(newAbility);
  } catch (error) {
    res.status(404).send(error.message);
  }
});

router.put("/setCharacter", async (req, res) => {
  const { idAbility, codeCharacter } = req.body;
  const ability = await Ability.findByPk(idAbility);
  await ability.setCharacter(codeCharacter);

  res.status(200).json(ability);
});

module.exports = router;
