config = {
    UseOx = true,
    Notify = 'GTA', --QBCORE or GTA
    AfkTimer = 900, --seconds
    QuestionTime = 180, --seconds
    QuestionNumber = 1,

    LangType = 'EN',
    Lang = {
        ['EN'] = {
            ['chat'] = 'Questions',
            ['questions'] = 'What is ',
            ['kick_message'] = 'You were kicked for being AFK.',
        }
    }
}

if config.UseOx then
    local file = 'init.lua';
    local import = LoadResourceFile('ox_lib', file);
    local chunk = assert(load(import, ('@@ox_lib/%s'):format(file)));

    chunk();
end