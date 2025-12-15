sometimes a user may need to scaffold a project that has already gone through a non-comme-ca development process, or bring an existing comme-ca project into ocmpliance with latest comme-ca standards. currently cca init throws an error if the project is not in a clean state, e.g. 
```
> cca init                  ~/Dev/larval-prusa-fdm took 59m46s
Error: AGENTS.md, CLAUDE.md, or GEMINI.md already exists in /Users/l/Dev/larval-prusa-fdm

x ls -t                                 ~/Dev/larval-prusa-fdm
_ENTRYPOINT.md       scripts/             what.md
generated/           src/                 why.md
AGENTS.md            GUIDE.md             tpu-72d-presets.ini
```
cca init needs to be smarter about this, discuss some ways handling it. One idea I can think of is maybe if it detects set of files, it should make copies of those and move them to a directory. And then set a flag for the first smart agent that's run in the project to look into it and bring into compliance with the latest comme-ca standards.
