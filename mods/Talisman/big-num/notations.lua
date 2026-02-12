Notations = {
    BaseLetterNotation = assert(love.filesystem.load(Talisman.mod_path.."/big-num/notations/baseletternotation.lua"))(),
    LetterNotation = assert(love.filesystem.load(Talisman.mod_path.."/big-num/notations/letternotation.lua"))(),
    CyrillicNotation = assert(love.filesystem.load(Talisman.mod_path.."/big-num/notations/cyrillicnotation.lua"))(),
    GreekNotation = assert(love.filesystem.load(Talisman.mod_path.."/big-num/notations/greeknotation.lua"))(),
    HebrewNotation = assert(love.filesystem.load(Talisman.mod_path.."/big-num/notations/hebrewnotation.lua"))(),
    ScientificNotation = assert(love.filesystem.load(Talisman.mod_path.."/big-num/notations/scientificnotation.lua"))(),
    EngineeringNotation = assert(love.filesystem.load(Talisman.mod_path.."/big-num/notations/engineeringnotation.lua"))(),
    BaseStandardNotation = assert(love.filesystem.load(Talisman.mod_path.."/big-num/notations/basestandardnotation.lua"))(),
    StandardNotation = assert(love.filesystem.load(Talisman.mod_path.."/big-num/notations/standardnotation.lua"))(),
    ThousandNotation = assert(love.filesystem.load(Talisman.mod_path.."/big-num/notations/thousandnotation.lua"))(),
    DynamicNotation = assert(love.filesystem.load(Talisman.mod_path.."/big-num/notations/dynamicnotation.lua"))(),
    Balatro = assert(love.filesystem.load(Talisman.mod_path.."/big-num/notations/Balatro.lua"))(),
    ArrayNotation = assert(love.filesystem.load(Talisman.mod_path.."/big-num/notations/arraynotation.lua"))(),
    AnteNotation = assert(love.filesystem.load(Talisman.mod_path.."/big-num/notations/antenotation.lua"))(),
}

return Notations
